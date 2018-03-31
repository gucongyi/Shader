using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class _LightMappingLab_1x : MonoBehaviour {
    public GUISkin skin;
    public Light lit1;
    public Light lit2;
    public string[] labels;
    public Rect[] rects;
    private float oriX1;
    private float oriX2;
    public Rect[] rectC;
    public float[] cs;
    public Rect[] camRec;
	// Use this for initialization
	void Start () {
        oriX1 = lit1.transform.position.x;
        oriX2 = lit2.transform.position.x;
        cs[0] = cs[1] = cs[2] = 1;
        cs[3] = 0.5f;
        cs[4] = 0.5f;
	}
	
	// Update is called once per frame
	void Update () {
        lit1.transform.position = new Vector3(oriX1+(cs[3]-0.5f)*5f,lit1.transform.position.y,lit1.transform.position.z);
        lit2.transform.position = new Vector3(oriX2 +(cs[4] -0.5f)*5f, lit2.transform.position.y, lit2.transform.position.z);
        lit1.color = new Color(cs[0], cs[1], cs[2], 1.0f);
	}
    void OnGUI()
    {
        GUI.skin = skin;
        for (int i = 0; i < rects.Length; i++)
        {
            GUI.Label(rects[i],labels[i]);
        }
        for (int i = 0; i < rectC.Length; i++)
        {
            cs[i] = GUI.HorizontalSlider(rectC[i], cs[i], 0f, 1f);
        }
        GUI.Label(camRec[0],"RenderingPath: "+Camera.main.renderingPath+"");
        if (GUI.Button(camRec[1], "VertexLit")) Camera.main.renderingPath = RenderingPath.VertexLit;
        if (GUI.Button(camRec[2], "Forward")) Camera.main.renderingPath = RenderingPath.Forward;
        if (GUI.Button(camRec[3], "Deferred")) Camera.main.renderingPath = RenderingPath.DeferredLighting;
    }
}
