using UnityEngine;
using System;
using System.Collections;

[ExecuteInEditMode]
public class _LightProbeLab_3 : MonoBehaviour {

    public GUISkin skin;
    public LightProbes lp1;
    public LightProbes lp2;
    public LightProbes lp3;
    public Rect[]  rect;
    //
    public Transform actor;
    public float posx;
    public float factor1;
    public float factor2;
    public float factor3;
    public Rect[] rectS;
    public string[] labels;
    public Rect[] rectL;
    //
    private float[] m_BaseCoefficients;
    public float[] m_Coefficients;
	// Use this for initialization
	void Start () {
        factor1 = factor2 = factor3 = 1.0f;
        LightmapSettings.lightProbes = Instantiate(lp1) as LightProbes;
        UpdateBaseCoefficients();
	}
	
	// Update is called once per frame
	void Update () {
        actor.position = new Vector3(posx, actor.position.y, actor.position.z);
	}
    void OnGUI()
    {
        GUI.skin = skin;
        if (GUI.Button(rect[0], "Switch to LightProbes Set 1"))
        {
            LightProbes xc = Instantiate(lp1) as LightProbes;
            LightmapSettings.lightProbes = xc;
            UpdateBaseCoefficients();
        }
        if (GUI.Button(rect[1], "Switch to LightProbes Set 2"))
        {
            LightProbes xc = Instantiate(lp2) as LightProbes;
            LightmapSettings.lightProbes = xc;
            UpdateBaseCoefficients();
        }
        if (GUI.Button(rect[2], "Switch to LightProbes Set 3"))
        {
            LightProbes xc = Instantiate(lp3) as LightProbes;
            LightmapSettings.lightProbes = xc;
            UpdateBaseCoefficients();
        }
        GUI.Label(rect[3],"Current Light Probe Count:"+LightmapSettings.lightProbes.count);
        GUI.Label(rect[4], "Current Light Probe cellCount:" + LightmapSettings.lightProbes.cellCount);
        //
        for (int i = 0; i < rectL.Length; i++)
        {
            GUI.Label(rectL[i], labels[i]);
        }
        posx = GUI.HorizontalSlider(rectS[0], posx, -4.2f, 4.2f);
        factor1 = GUI.HorizontalSlider(rectS[1], factor1, 0f, 2f);
        factor2 = GUI.HorizontalSlider(rectS[2], factor2, 0f, 2f);
        factor3 = GUI.HorizontalSlider(rectS[3], factor3, 0f, 2f);
        UpdateCoeffients();
    }
    void UpdateBaseCoefficients()
    {
        int len=LightmapSettings.lightProbes.coefficients.Length;
        m_BaseCoefficients = new float[len];
        Array.Copy(LightmapSettings.lightProbes.coefficients, m_BaseCoefficients,len);
        m_Coefficients = new float[len];
    }
    void UpdateCoeffients()
    {
        for (int i = 0; i < m_BaseCoefficients.Length/3; i++)
        {
            m_Coefficients[i*3] = m_BaseCoefficients[i*3] * factor1;
            m_Coefficients[i*3+1] = m_BaseCoefficients[i*3+1] * factor2;
            m_Coefficients[i*3 + 2] = m_BaseCoefficients[i*3 + 2] * factor3;
        }
        LightmapSettings.lightProbes.coefficients = m_Coefficients;
    }
}
