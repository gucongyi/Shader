using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class _PrepassBase : MonoBehaviour {
    public GUISkin skin;
    public Transform cam;
    public Transform obj;
    public float angleCam;
    public float angleObj;
    public Rect rectCam;
    public Rect rectObj;

	// Use this for initialization
	void Start () {
        angleCam = 0;
        angleObj = 0;
	}
	
	// Update is called once per frame
	void Update () {
        cam.eulerAngles = new Vector3(0, 360 * angleCam, 0);
        obj.eulerAngles = new Vector3(0, 360 * angleObj, 0);
	}
    void OnGUI()
    {
        GUI.skin = skin;
        angleCam = GUI.HorizontalSlider(rectCam,angleCam,0f,1f);
        angleObj = GUI.HorizontalSlider(rectObj, angleObj,0f,1f);
    }
}
