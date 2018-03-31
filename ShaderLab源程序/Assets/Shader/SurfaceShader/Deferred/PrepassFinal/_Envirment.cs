using UnityEngine;
using System.Collections;

public class _Envirment : MonoBehaviour {
    public Material mat;
    public Texture tex;
	// Use this for initialization
	void Start () {
        mat.SetTexture("_Envir",tex);
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
