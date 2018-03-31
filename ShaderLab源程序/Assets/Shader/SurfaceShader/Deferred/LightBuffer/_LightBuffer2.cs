using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class _LightBuffer2 : MonoBehaviour {
    public GUISkin skin;
    public Material fwdMat;
    public Material defMat;
    public GameObject sp1;
    public GameObject sp2;
    public GameObject sp3;
    public Rect[] spR1;
    public Rect[] spR2;
    public Rect[] spR3;

	// Update is called once per frame
	void Update () {
	
	}
    void OnGUI()
    {
        GUI.skin = skin;
        if (GUI.Button(spR1[0], "Sphere Left"))
        {
            ChangefwdMat(sp1);
        }
        if (GUI.Button(spR2[0], "Sphere Middle"))
        {
            ChangefwdMat(sp2);
        }
        if (GUI.Button(spR3[0], "Sphere Right"))
        {
            ChangefwdMat(sp3);
        }
        if (GUI.Button(spR1[1], "Sphere Left"))
        {
            ChangedefMat(sp1);
        }
        if (GUI.Button(spR2[1], "Sphere Middle"))
        {
            ChangedefMat(sp2);
        }
        if (GUI.Button(spR3[1], "Sphere Right"))
        {
            ChangedefMat(sp3);
        }
    }
    void ChangefwdMat(GameObject obj)
    {
        obj.renderer.material = fwdMat;
    }
    void ChangedefMat(GameObject obj)
    {
        obj.renderer.material = defMat;
    }
}
