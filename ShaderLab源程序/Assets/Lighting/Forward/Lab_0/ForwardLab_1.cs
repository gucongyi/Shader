using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class ForwardLab_1 : MonoBehaviour {

    public GUISkin skin;
    public Rect[] rect;
    public string[] tips;
	
	// Update is called once per frame
	void Update () {
	
	}
    void OnGUI()
    {
        GUI.skin = skin;
        for (int i = 0; i < rect.Length;i++ )
        {
            GUI.Label(rect[i], tips[i]);
        }
    }
}
