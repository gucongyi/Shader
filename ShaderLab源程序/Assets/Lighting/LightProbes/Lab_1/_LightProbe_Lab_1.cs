using UnityEngine;
using System.Collections;
using System;
//[ExecuteInEditMode]
public class _LightProbe_Lab_1 : MonoBehaviour {
    public Transform actor;
    public float posx;
    public float factor;
    public Rect[] rects;
    public string[] labels;
    public Rect[] rectL;
    public GUISkin skin;
    //
    public float[] m_BaseCoefficients;
    public float[] m_Coefficients;
	// Use this for initialization
	void Start () {
        m_BaseCoefficients = new float[LightmapSettings.lightProbes.coefficients.Length];
        Array.Copy(LightmapSettings.lightProbes.coefficients, m_BaseCoefficients, LightmapSettings.lightProbes.coefficients.Length);

        m_Coefficients = new float[LightmapSettings.lightProbes.coefficients.Length];
	}
	
	// Update is called once per frame
	void Update () {
        actor.position = new Vector3(posx, actor.position.y, actor.position.z);
        for (int i=0;i<m_BaseCoefficients.Length;i++)
        {
            m_Coefficients[i] = m_BaseCoefficients[i] *factor;
        }
        LightmapSettings.lightProbes.coefficients = m_Coefficients;
	}
    void OnGUI()
    {
        GUI.skin = skin;
        for (int i = 0; i < rectL.Length; i++)
        {
            GUI.Label(rectL[i], labels[i]);
        }
        posx = GUI.HorizontalSlider(rects[0], posx, -4.2f, 4.2f);
        factor = GUI.HorizontalSlider(rects[1], factor, 0f, 2f);
    }
}
