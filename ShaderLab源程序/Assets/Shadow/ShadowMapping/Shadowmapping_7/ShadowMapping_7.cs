using UnityEngine;
using System.Collections;

public class ShadowMapping_7 : MonoBehaviour {
	
	public Shader depShader;
	public Light shadowLight;
	
	public RenderTexture lightViewZDepth;
	private Camera lightPosCam;

	public Camera cam;

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
		lightPosCam.clearFlags=CameraClearFlags.SolidColor;
		lightPosCam.farClipPlane=Camera.main.farClipPlane;
		lightPosCam.depth=-1;
		
		lightPosCam.transform.parent=shadowLight.transform;

		lightViewZDepth.width=Screen.width;
		lightViewZDepth.height=Screen.height;
		

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
	}
	void OnPreCull()
	{
			//Shader.SetGlobalMatrix("_litSpace",lightPosCam.worldToCameraMatrix);
			
			lightPosCam.RenderWithShader(depShader,"RenderType");
			Shader.SetGlobalTexture("_myShadow",lightViewZDepth);
			Shader.SetGlobalMatrix("_litMVP",lightPosCam.projectionMatrix*lightPosCam.worldToCameraMatrix);
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
		cam.targetTexture=null;
		Camera.SetupCurrent(cam);
	}
	
}
