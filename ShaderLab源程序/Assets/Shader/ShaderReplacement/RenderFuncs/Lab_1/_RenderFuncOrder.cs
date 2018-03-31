using UnityEngine;
using System.Collections;

public class _RenderFuncOrder : MonoBehaviour {
    public _RenderFuncOrder one;
    public int order;
    public string hat = "";
	void Start () {
        one = this;
	}
	void Update () {
        order++;
        Debug.Log(hat+"camera. Execute Order: "+order+"  :'Update()'");
	}
    void OnPreCull()
    {
        order=0;
        Debug.Log(hat + "camera. Execute Order: " + order + "  :'OnPreCull()'");
    }
    void OnPreRender()
    {
        order++;
        Debug.Log(hat + "camera. Execute Order: " + order + "  :'OnPreRender()'");
    }
    void OnPostRender()
    {
        order++;
        Debug.Log(hat + "camera. Execute Order: " + order + "  :'OnPostRender()'");
    }
    void OnRenderImage(RenderTexture src,RenderTexture dst)
    {
        order++;
        Debug.Log(hat + "camera. Execute Order: " + order + "  :'OnRenderImage( , )'");
    }
    void OnRenderObject()
    { 
        order++;
        Debug.Log(hat + "camera. Execute Order: " + order + "  :'OnRenderObject()'");
    }
    void OnWillRenderObject()
    {
        order++;
        Debug.Log(hat + "camera. Execute Order: " + order + "  :'OnWillRenderObject()'");
    }
}
