using UnityEngine;
using System.Collections;

public class VolumeFog_1 : MonoBehaviour {

	// Use this for initialization
	void Start () {
        camera.depthTextureMode = DepthTextureMode.Depth | DepthTextureMode.DepthNormals;
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
