using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GetRender : MonoBehaviour
{
    public List<MeshRenderer> meshRenderers;
    RenderTexture rt;
    RenderTexture rt2;
    void Awake()
    {
        //shader = Shader.Find("DistortionShaderPack/RTDistortionMaster");
        //Debug.LogErrorFormat("Awake");
    }
    
    void OnPreRender()
    {
        if (meshRenderers==null|| meshRenderers.Count<=0)
        {
            return;
        }
        //Debug.LogErrorFormat("OnPreRender");
        rt = RenderTexture.GetTemporary(Screen.width, Screen.height, 24);
        GetComponent<Camera>().targetTexture = rt;
    }
    void Update()
    {
        if (meshRenderers == null || meshRenderers.Count <= 0)
        {
            return;
        }
        foreach (var eachMeshRender in meshRenderers)
        {
            if (eachMeshRender.sharedMaterial.HasProperty("_UVOffset"))
            {
                Vector4 offset = eachMeshRender.sharedMaterial.GetVector("_UVOffset");
                offset.z = offset.x * Time.time;
                offset.w = offset.y * Time.time;
                eachMeshRender.sharedMaterial.SetVector("_UVOffset", offset);
            }
        }
    }
    void OnPostRender()
    {
        if (meshRenderers == null || meshRenderers.Count <= 0)
        {
            return;
        }
        //(2)
        rt2 = RenderTexture.GetTemporary(Screen.width, Screen.height, 24);
        GetComponent<Camera>().targetTexture = rt2;
        Graphics.Blit(rt, rt2);
        //Shader.SetGlobalTexture("_RenderTexture", rt2);
        foreach (var eachMeshRender in meshRenderers)
        {
            //DrawMesh要关掉自己,非常重要，否则是黑的
            eachMeshRender.gameObject.SetActive(false);
            eachMeshRender.sharedMaterial.SetTexture("_RenderTexture", rt2);
        }



        //(3)
        GetComponent<Camera>().targetTexture = rt;
        Graphics.SetRenderTarget(rt);//把我们要画的mesh渲染到目标RT中

        foreach (var eachMeshRender in meshRenderers)
        {
            if (eachMeshRender.material.SetPass(0))
            {
                Matrix4x4 TRS = new Matrix4x4();
                TRS.SetTRS(eachMeshRender.transform.position, eachMeshRender.transform.rotation, eachMeshRender.transform.lossyScale);
                Graphics.DrawMeshNow(eachMeshRender.GetComponent<MeshFilter>().mesh, TRS);
            }
        }
        

        //(4)
        GetComponent<Camera>().targetTexture = null;
        Graphics.Blit(rt, (null as RenderTexture));

        RenderTexture.ReleaseTemporary(rt2);
        RenderTexture.ReleaseTemporary(rt);
        //Debug.LogErrorFormat("OnPostRender");
    }


    

    

}
