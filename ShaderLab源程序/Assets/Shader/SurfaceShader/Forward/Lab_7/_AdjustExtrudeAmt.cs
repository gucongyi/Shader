using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class _AdjustExtrudeAmt : MonoBehaviour
{

    public GUISkin skin;
    public Rect rectL;
    public string lab;
    public float d;
    public Rect rectS;
    public Material[] mats;
    // Use this for initialization
    void Start()
    {
        d = 0;
    }

    // Update is called once per frame
    void Update()
    {
        //QualitySettings.shadowDistance = dist * d;
        foreach (Material mat in mats)
        {
            mat.SetFloat("_ExtrudeAmt",d);
        }
    }
    void OnGUI()
    {
        GUI.skin = skin;
        GUI.Label(rectL, lab);
        d = GUI.HorizontalSlider(rectS, d, 0, 1);
    }
}
