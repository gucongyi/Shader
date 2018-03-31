using UnityEngine;
using System.Collections;
public class _SetReplacementShader : MonoBehaviour {
    public GUISkin skin;
    public Rect r3;
    public Shader replaceShader;
    string btnStr = "SetReplacementShader";
    bool setRS = true;
    void OnGUI()
    {
        GUI.skin = skin;
        if (GUI.Button(r3, btnStr))
        {
            if (setRS)
            {
                camera.SetReplacementShader(replaceShader, "myTag");
                setRS = false;
                btnStr = "ResetReplacementShader";
            }
            else
            {
                camera.ResetReplacementShader();
                setRS = true;
                btnStr = "SetReplacementShader";
            }
        }
    }
}
