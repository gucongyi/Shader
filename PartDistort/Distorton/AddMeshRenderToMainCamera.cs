using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AddMeshRenderToMainCamera : MonoBehaviour
{
    public MeshRenderer _MeshRender;

    void Awake()
    {
        if (_MeshRender!=null)
        {
            GetRender DistortionCtl = GameWorld.Instance.Camera.GetComponent<GetRender>();
            DistortionCtl.meshRenderers.Add(_MeshRender);
        }
    }

    void OnDestroy()
    {
        if (_MeshRender != null)
        {
            GetRender DistortionCtl = GameWorld.Instance.Camera.GetComponent<GetRender>();
            DistortionCtl.meshRenderers.Remove(_MeshRender);
        }
    }

}
