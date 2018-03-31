using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class VertexLitLab_2_Slide : MonoBehaviour {

    public Light dir;
    private Transform dirTr;
    public float rx, ry, rz;
    public float cr, cg, cb;
    public Rect[] sli;
    public Rect[] rectTip;
    public string[] tips;
	// Use this for initialization
	void Start () {
        dirTr = dir.transform;
        rx = 30f;
        ry = -60f;

        cr = cg = cb = 0.0f;
        cr = 1.0f;
	}
	
	// Update is called once per frame
	void Update () {
        dir.color = new Color(cr, cg, cb);
        dirTr.localEulerAngles = new Vector3(rx, ry, rz);
	}
    void OnGUI()
    {
        rx = GUI.HorizontalSlider(sli[0], rx, 0f, 90f);
        ry = GUI.HorizontalSlider(sli[1], ry, -90f, 0f);
        rz = GUI.HorizontalSlider(sli[2], rz, 0f, 90f);
        cr = GUI.HorizontalSlider(sli[3], cr, 0f, 1f);
        cg = GUI.HorizontalSlider(sli[4], cg, 0f, 1f);
        cb = GUI.HorizontalSlider(sli[5], cb, 0f, 1f);

        for (int i = 0; i < tips.Length; i++)
        {
            GUI.Label(rectTip[i], tips[i]);
        }
    }
}
