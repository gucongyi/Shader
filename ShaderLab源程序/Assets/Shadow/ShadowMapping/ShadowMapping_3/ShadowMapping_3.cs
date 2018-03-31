using UnityEngine;
using System.Collections;

public class ShadowMapping_3 : MonoBehaviour {
	
	public Shader depShader;
	public Light shadowLight;
	
	public RenderTexture lightViewZDepth;
	private Camera lightPosCam;
	private bool renderLightDepth;
	
	public RenderTexture camViewZDepth;
	public Camera cam;
	private Camera shadeCam;
	private bool renderCamDepth;
	//
	public GUISkin skin;
	
	//Project Shadow Map
    Matrix4x4 model2World;
    Matrix4x4 world2ProjView;
    Matrix4x4 projM;
    Matrix4x4 correction;
    Matrix4x4 cm;
    float n=0.3f;
    float f=60f;
    float aspect=1f;
    float fov=1f;
    float d;

	// Use this for initialization
	void Awake () {
        correction = Matrix4x4.identity;
        correction.SetColumn(3,new Vector4(0.5f,0.5f,0.5f,1f));
        correction.m00 = 0.5f;
        correction.m11 = 0.5f;
        correction.m22 = 0.5f;
		
		aspect=cam.aspect;
	}
	// Use this for initialization
	void Start () {
		GameObject lCam=new GameObject("LightPosCam");
		lCam.transform.position=shadowLight.transform.position;
		lCam.transform.rotation=shadowLight.transform.rotation;
		lightPosCam=(Camera)lCam.AddComponent(typeof(Camera));
		
		lightPosCam.aspect=cam.aspect;
		lightPosCam.depthTextureMode=DepthTextureMode.Depth;
		lightPosCam.targetTexture=lightViewZDepth;
		lightPosCam.enabled=false;
		lightPosCam.clearFlags=CameraClearFlags.Depth;
		lightPosCam.farClipPlane=Camera.main.farClipPlane;
		lightPosCam.depth=-1;
		
		GameObject shadeObj=new GameObject("ShadeCamera");
		shadeObj.transform.position=cam.transform.position;
		shadeObj.transform.rotation=cam.transform.rotation;
		shadeCam=(Camera)shadeObj.AddComponent(typeof(Camera));
		
		shadeCam.CopyFrom(cam);
		shadeCam.enabled=false;
		
		lightViewZDepth.width=Screen.width;
		lightViewZDepth.height=Screen.height;
		camViewZDepth.width=Screen.width;
		camViewZDepth.height=Screen.height;
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	void OnGUI()
	{
		GUI.skin=skin;
		if(GUI.Button(new Rect(20,Screen.height-40,110,25),"Light View"))
			Switch2LightView();
		if(GUI.Button(new Rect(140,Screen.height-40,110,25),"Main View"))
			Switch2MainView();
		if(GUI.Button(new Rect(260,Screen.height-40,160,25),"LightView Depth"))
			RenderLightViewZDepth();
		if(GUI.Button(new Rect(440,Screen.height-40,160,25),"CamView Depth"))
			RenderCamViewZDepth();
	}
	void OnPreCull()
	{
		if(renderLightDepth)
		{
			lightPosCam.RenderWithShader(depShader,"RenderType");
			Shader.SetGlobalTexture("_myShadow",lightViewZDepth);
		}
		if(renderCamDepth)
		{
			shadeCam.RenderWithShader(depShader,"RenderType");
		}
		Proj();
	}
	void Switch2LightView()
	{
		cam.enabled=false;
		lightPosCam.enabled=true;
		lightPosCam.targetTexture=null;
		Camera.SetupCurrent(lightPosCam);
	}
	void Switch2MainView()
	{
		cam.enabled=true;
		lightPosCam.enabled=false;
		Camera.SetupCurrent(cam);
	}
	void RenderLightViewZDepth()
	{
		cam.enabled=true;
		lightPosCam.enabled=false;
		lightPosCam.targetTexture=lightViewZDepth;
		lightPosCam.depthTextureMode=DepthTextureMode.Depth;
		renderLightDepth=true;
	}
	void RenderCamViewZDepth()
	{
		cam.enabled=true;
		lightPosCam.enabled=false;
		shadeCam.targetTexture=camViewZDepth;
		shadeCam.depthTextureMode=DepthTextureMode.Depth;
		renderCamDepth=true;
	}
	void Proj()
    {
        model2World = Matrix4x4.identity;
        world2ProjView = shadowLight.transform.worldToLocalMatrix;//
        //world2ProjView = Camera.main.worldToCameraMatrix * world2ProjView;
        //n = Camera.main.near;
        //f = Camera.main.far;
        //aspect = Camera.main.aspect;
        //fov = Camera.main.fieldOfView * Mathf.Deg2Rad;
        d = 1f / Mathf.Tan(fov / 2f);

        projM.m00 = d / aspect;
        projM.m11 = d;
        projM.m22 = (n + f) / (n - f);
        projM.m23 = 2f * n * f / (n - f);
        projM.m32 = 1f;
        projM.m33 = 0;

        cm = correction * projM * world2ProjView * model2World;
        Shader.SetGlobalMatrix("_myShadowProj", cm);
    }
}
