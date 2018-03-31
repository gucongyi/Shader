using UnityEngine;
using System.Collections;

public class ShadowMapping_2 : MonoBehaviour {
	
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
			//Shader.SetGlobalTexture("_GlobalDepthTexture",lightViewZDepth);
			//Shader.SetGlobalVector("_GlobalDepthTextureSize",new Vector4(lightViewZDepth.width,lightViewZDepth.height,0,0));
		}
		if(renderCamDepth)
		{
			shadeCam.RenderWithShader(depShader,"RenderType");
		}
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
		//Camera.SetupCurrent(lightPosCam);
		renderLightDepth=true;
	}
	void RenderCamViewZDepth()
	{
		cam.enabled=true;
		lightPosCam.enabled=false;
		shadeCam.targetTexture=camViewZDepth;
		shadeCam.depthTextureMode=DepthTextureMode.Depth;
		//Camera.SetupCurrent(lightPosCam);
		renderCamDepth=true;
	}
}
