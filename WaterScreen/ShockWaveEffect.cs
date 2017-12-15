using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShockWaveEffect : PostEffectBase
{
    #region play param
    public float waveAmplitude = 0.3f;
    public float waveFreq = 20;
    public float waveSpeed = 1.4f;
    public float waveMaxRadius = 1.0f;
    public float waveScreenX;
    public float waveScreenY;
    public float duration;
    #endregion
    
    class ShaderSlotInfo
    {
        public int SlotIndex;//0-9
        public float StartTime;
        public float Duration;

        ////WaveOParams
        //public float waveScreenX;
        //public float waveScreenY;
        //public float waveAmplitude = 0.3f;
        //public float waveFreq = 20;
        ////Wave1Params
        //public float waveSpeed = 1.4f;
        //public float waveMaxRadius = 1.0f;
    }

    private List<ShaderSlotInfo> shaderFreeSlot = new List<ShaderSlotInfo>();
    private List<ShaderSlotInfo> shaderUsedSlot = new List<ShaderSlotInfo>();
    private List<ShaderSlotInfo> shaderTempSlot = new List<ShaderSlotInfo>();

    private GameObject m_GameObj;
    Material takeThisMaterial;
    private Mesh m_Mesh;
    //16:9
    int m_ScreenGridXRes = 48*5;
    int m_ScreenGridYRes = 27*5;
    
    void Awake()
    {
        m_GameObj = new GameObject();
        if (!shader)
        {
            shader = Shader.Find("Custom/ShockWave Effect");
            takeThisMaterial = this._Material;
        }
        InitMeshes();
        for (int i=0;i<10;i++)//预留10个槽位
        {
            ShaderSlotInfo slotInfo = new ShaderSlotInfo();
            slotInfo.SlotIndex = i;
            shaderFreeSlot.Add(slotInfo);
        }
        m_GameObj.SetActive(false);
    }
    bool InitMeshes()
    {

        m_GameObj.AddComponent<MeshFilter>();
        m_GameObj.AddComponent<MeshRenderer>();

        MeshFilter m_MeshFilter = (MeshFilter)m_GameObj.GetComponent(typeof(MeshFilter));
        MeshRenderer m_MeshRenderer = (MeshRenderer)m_GameObj.GetComponent(typeof(MeshRenderer));

        m_MeshRenderer.GetComponent<Renderer>().material = takeThisMaterial;
        m_MeshRenderer.GetComponent<Renderer>().enabled = true;
        m_MeshRenderer.GetComponent<Renderer>().shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
        m_MeshRenderer.GetComponent<Renderer>().receiveShadows = false;

        m_Mesh = m_MeshFilter.mesh;

        int numVerts = m_ScreenGridXRes * m_ScreenGridYRes;
        int numTris = (m_ScreenGridXRes - 1) * (m_ScreenGridYRes - 1) * 2;

        Vector3[] verts = new Vector3[numVerts];
        Vector2[] uv = new Vector2[numVerts]; // we fill UVs even if it is not used by shader to make Unity happy
        int[] tris = new int[numTris * 3];

        for (int y = 0; y < m_ScreenGridYRes; y++)
        {
            for (int x = 0; x < m_ScreenGridXRes; x++)
            {
                int idx = y * m_ScreenGridXRes + x;

                verts[idx].x = (float)x / (m_ScreenGridXRes - 1);
                verts[idx].y = (float)y / (m_ScreenGridYRes - 1);
                verts[idx].z = 0;

                uv[idx].x = verts[idx].x;
                uv[idx].y = verts[idx].y;
            }
        }

        int currIdx = 0;

        for (int y = 0; y < m_ScreenGridYRes - 1; y++)
        {
            for (int x = 0; x < m_ScreenGridXRes - 1; x++)
            {
                // 0   1
                // +---+
                // |   |
                // +---+
                // 3   2

                int i0 = x + y * m_ScreenGridXRes;
                int i1 = (x + 1) + y * m_ScreenGridXRes;
                int i2 = (x + 1) + (y + 1) * m_ScreenGridXRes;
                int i3 = x + (y + 1) * m_ScreenGridXRes;

                tris[currIdx++] = i3;
                tris[currIdx++] = i1;
                tris[currIdx++] = i0;

                tris[currIdx++] = i3;
                tris[currIdx++] = i2;
                tris[currIdx++] = i1;
            }
        }

        m_Mesh.vertices = verts;
        m_Mesh.uv = uv;
        m_Mesh.triangles = tris;
        m_Mesh.name = "screenspace grid";

        return true;
    }
    
    ////void OnRenderImage(RenderTexture source, RenderTexture destination)
    ////{
    ////    if (!m_InitOK)
    ////    {
    ////        Graphics.Blit(source, destination);
    ////        //Debug.LogErrorFormat("=================InitMeshes not initialized correctly");
    ////        return;
    ////    }
    ////    RenderTexture prevActiveRT = RenderTexture.active;
    ////    RenderTexture.active = destination;

    ////    takeThisMaterial.mainTexture = prevActiveRT;
    ////    SetUVOffset(prevActiveRT);
    ////    SetupWaveShaderParamsOnRender();
    ////    //Debug.LogErrorFormat("=================SetupWaveShaderParamsOnRender()");
    ////    //Graphics.Blit(source, destination, _Material);
    ////    if (takeThisMaterial.SetPass(0))
    ////    {
    ////        //Debug.LogErrorFormat("=================takeThisMaterial SetPass(0)");
    ////        Graphics.DrawMeshNow(m_Mesh, Matrix4x4.identity);
    ////        //Debug.LogErrorFormat("=================Graphics.DrawMeshNow");
    ////    }

    ////    RenderTexture.active = prevActiveRT;
    ////}
    public void PlayEffect()
    {
        SetupWaveShaderParams();
    }

    private bool CheckIsContain(List<ShaderSlotInfo> list,ShaderSlotInfo slotInfo)
    {
        for (int j = 0; j < list.Count; j++)
        {
            if (list[j].SlotIndex == slotInfo.SlotIndex)
            {
                return true;
            }
        }
        return false;
    }
    RenderTexture mainRT;
    void OnPreRender()
    {//设置RenderTexture
        mainRT = RenderTexture.GetTemporary(Screen.width, Screen.height, 16);
        GetComponent<Camera>().targetTexture = mainRT;//render to RenderTexture, not framebuffer
    }
    
    void OnPostRender()
    {//在渲染OnRender的时候已经拿到mainRT，对他进行处理
        GetComponent<Camera>().targetTexture = null; //now render to framebuffer
        RenderTexture.active = null; //must place before set pass，要重新绘制，所以这里要设置为null
        takeThisMaterial.mainTexture = mainRT;
        SetUVOffset(mainRT);
        SetupWaveShaderParamsOnRender();
        //Graphics.Blit(source, destination, _Material);
        if (takeThisMaterial.SetPass(0))
        {
            Graphics.DrawMeshNow(m_Mesh, Matrix4x4.identity);
        }
        //释放mainRT
        RenderTexture.ReleaseTemporary(mainRT);
    }

    public void Update()
    {
        shaderTempSlot.Clear();
        for (int i = 0; i < shaderUsedSlot.Count; i++)//每帧计算槽位
        {
            if (Time.time-shaderUsedSlot[i].StartTime> shaderUsedSlot[i].Duration)
            {
                if (!CheckIsContain(shaderFreeSlot, shaderUsedSlot[i]))
                {
                    shaderFreeSlot.Add(shaderUsedSlot[i]);
                    shaderTempSlot.Add(shaderUsedSlot[i]);
                }
            }
        }
        //删除使用结束的
        for (int i=0;i< shaderTempSlot.Count;i++)
        {
            shaderUsedSlot.Remove(shaderTempSlot[i]);
        }

        //if (Input.GetMouseButtonUp(0))
        //{
        //    SetupWaveShaderParams();
        //}
        if (shaderUsedSlot.Count <= 0)
        {//没有可用的就删掉
            ReleaseRes();
        }
    }

    private void ReleaseRes()
    {
        m_Mesh = null;
        if (m_GameObj != null)
        {
            Destroy(m_GameObj);
        }
        this.SafeDestroy();
    }

    #region shader param
    void SetUVOffset(RenderTexture source)
    {
        if (source == null)
            return;
        Vector4 uvOffs = Vector4.zero;

        uvOffs.x = 0.5f / source.width;
        uvOffs.y = 0.5f / source.height;
        uvOffs.z = 1;
        uvOffs.w = (float)source.height / source.width;

        this._Material.SetVector("_UVOffsAndAspectScale", uvOffs); 
    }

    private float[] radius = new float[10];
    private Vector4[] WaveOParams = new Vector4[10];
    private Vector4[] Wave1Params = new Vector4[10];
    void SetupWaveShaderParams()
    {
        if (shaderFreeSlot.Count>0)
        {
            ShaderSlotInfo oldSlotInfo = shaderFreeSlot[0];//取第一个
            ShaderSlotInfo slotInfo = new ShaderSlotInfo();
            slotInfo.SlotIndex = oldSlotInfo.SlotIndex;//拿到老的槽位信息
            slotInfo.StartTime = Time.time;
            slotInfo.Duration = duration;
            radius[slotInfo.SlotIndex] = 1;//传入波动范围
            //传入效果信息
            //WaveOParams[slotInfo.SlotIndex].x = Input.mousePosition.x / Screen.width;
            //WaveOParams[slotInfo.SlotIndex].y = Input.mousePosition.y / Screen.height;
            WaveOParams[slotInfo.SlotIndex].x = waveScreenX / Screen.width;
            WaveOParams[slotInfo.SlotIndex].y = waveScreenY / Screen.height;
            WaveOParams[slotInfo.SlotIndex].z = waveAmplitude;
            WaveOParams[slotInfo.SlotIndex].w = waveFreq;

            Wave1Params[slotInfo.SlotIndex].x = 1.0f / waveMaxRadius;
            Wave1Params[slotInfo.SlotIndex].y = waveSpeed;
            Wave1Params[slotInfo.SlotIndex].z = Time.time;
            Wave1Params[slotInfo.SlotIndex].w = 1;

            if (!CheckIsContain(shaderUsedSlot, slotInfo))
            {
                shaderUsedSlot.Add(slotInfo);//加入使用列表
            }
            shaderFreeSlot.RemoveAt(0);//删除第一个
        }
        else
        {
            return;
        }
    }
    void SetupWaveShaderParamsOnRender()
    {
        _Material.SetVectorArray("_Wave0ParamSet0", WaveOParams);
        _Material.SetVectorArray("_Wave0ParamSet1", Wave1Params);
        _Material.SetFloat("_EachFramTimeSinceGame",Time.time);
    }


    #endregion


}
