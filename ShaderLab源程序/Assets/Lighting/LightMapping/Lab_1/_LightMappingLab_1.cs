using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class _LightMappingLab_1 : MonoBehaviour {
    public GUISkin skin;
    public string[] labels;
    public Rect[] rects;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
    void OnGUI()
    {
        GUI.skin = skin;
        for (int i = 0; i < rects.Length; i++)
        {
            GUI.Label(rects[i],labels[i]);
        }
    }
}
