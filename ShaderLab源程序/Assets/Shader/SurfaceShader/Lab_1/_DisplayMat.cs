using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class _DisplayMat : MonoBehaviour {
    public string[] labels;
    public Rect[] rects;
    public GUISkin skin;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
    void OnGUI()
    {
        GUI.skin = skin;
        for (int i = 0; i < labels.Length; i++)
        {
            GUI.Label(rects[i], labels[i]);
        }
    }
}
