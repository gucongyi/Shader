using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestGuildeMat : MonoBehaviour
{
    private Material mat;
    public float ptx;
    public float pty;
    public float rx;
    public float ry;
    public float radio;
    public float glow;

	// Use this for initialization
	void Start () {
        mat = GetComponent<UITexture>().material;
	}
	
	// Update is called once per frame
	void Update () {
        mat.SetFloat("_PtX", ptx);
        mat.SetFloat("_PtY", pty);
        mat.SetFloat("_Rx", rx);
        mat.SetFloat("_Ry", ry);
        mat.SetFloat("_Radio",radio);
        mat.SetFloat("_RadiusGlow", glow);
        GetComponent<UITexture>().enabled = false;
        GetComponent<UITexture>().enabled = true;
	}
}
