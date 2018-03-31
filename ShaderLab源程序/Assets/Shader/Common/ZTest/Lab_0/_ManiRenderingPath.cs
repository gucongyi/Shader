using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class _ManiRenderingPath : MonoBehaviour {
    public Camera cam;
    public GUISkin skin;
    public Rect[] camRec;

	void Update () {

	}
    void OnGUI()
    {
        GUI.skin = skin;
        GUI.Label(camRec[0], "RenderingPath: " + cam.renderingPath + "");
        if (GUI.Button(camRec[1], "VertexLit")) cam.renderingPath = RenderingPath.VertexLit;
        if (GUI.Button(camRec[2], "Forward")) cam.renderingPath = RenderingPath.Forward;
        if (GUI.Button(camRec[3], "Deferred")) cam.renderingPath = RenderingPath.DeferredLighting;
        if (GUI.Button(camRec[4], "_CameraDepthTexture")) cam.depthTextureMode = cam.depthTextureMode|DepthTextureMode.Depth;
    }

}
