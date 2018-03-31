using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class VertexLit_MDir_GUI : MonoBehaviour {

    public int ht;
    public int wd1;
   
     int sw, sh;
     public GUISkin skin;
     public Light[] lt;
     public Rect[] Linfo;
     public Rect qua;
     public Rect[] quality;
	// Use this for initialization
	void Awake () {
        sw = Screen.width;
        sh = Screen.height;
        wd1 = sw / 5;
        Linfo = DisplayLight.SplitRegionH(new Rect(0, 200, sw, 300), 5,5);
        qua= new Rect(sw*0.9f,sh*0.8f,sw*0.1f,sh*0.2f);
        quality =DisplayLight.SplitRegionV(qua,5,3);
	}
	
	// Update is called once per frame
	void Update () {
	}
    void OnGUI()
    {
        GUI.skin = skin;
        GUI.BeginGroup(new Rect(0,160,sw,50));
        GUI.Label(new Rect(wd1 * 0, 0, wd1, 50), "_WorldSpaceLightPos0");
        GUI.Label(new Rect(wd1 * 1, 0, wd1, 50), "unity_LightPosition[i]\n0");
        GUI.Label(new Rect(wd1 * 2, 0, wd1, 50), "unity_LightPosition[i]\n0+1");
        GUI.Label(new Rect(wd1 * 3, 0, wd1, 50), "unity_LightPosition[i]\n0+1+2");
        GUI.Label(new Rect(wd1 * 4, 0, wd1, 50), "unity_LightPosition[i]\n0+1+2+3");
        GUI.EndGroup();

        for (int i = 0; i < lt.Length; i++)
        {
            DisplayLight.ShowLight(lt[i], Linfo[i]);
        }

        DisplayLight.DRenderingQuality(qua, quality);
    }
    
}
