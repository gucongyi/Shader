using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class _PrePassFinal : MonoBehaviour {
    public GUISkin skin;
    public string lab;
    public Rect labR;
    public Rect slidR;
    public float blendAmt;
    public Material mat;
	// Use this for initialization
	void Start () {
        blendAmt = 0.0f;
	}
	
	// Update is called once per frame
	void Update () {
        mat.SetFloat("_LightAmt",blendAmt);
	}
    void OnGUI()
    {
        GUI.skin = skin;
        GUI.Label(labR,lab);
        blendAmt= GUI.HorizontalSlider(slidR, blendAmt, 0, 1);

    }
}
