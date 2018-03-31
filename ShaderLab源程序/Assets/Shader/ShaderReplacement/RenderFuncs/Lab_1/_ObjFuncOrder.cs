using UnityEngine;
using System.Collections;

public class _ObjFuncOrder : MonoBehaviour {
    public _ObjFuncOrder one;
    public int order;
	void Start () {
        one = this;
	}
	void Update () {
        order++;
        order = 0;
        Debug.Log("obj. Execute Order: " + order + "  :'Update()'");
	}
    void OnBecameVisible()
    {
        order++;
        Debug.Log("obj. Execute Order: " + order + "  :'OnBecameVisible()'");
    }
    void OnBecameInvisible()
    {
        order++;
        Debug.Log("obj. Execute Order: " + order + "  :'OnBecameInvisible()'");
    }
    void OnRenderObject()
    { 
        order++;
        Debug.Log("obj. Execute Order: " + order + "  :'OnRenderObject()'");
    }
    void OnWillRenderObject()
    {
        order++;
        Debug.Log("obj. Execute Order: " + order + "  :'OnWillRenderObject()'");
    }
}
