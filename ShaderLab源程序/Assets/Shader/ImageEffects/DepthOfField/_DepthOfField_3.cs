using UnityEngine;
using System.Collections;

public class _DepthOfField_3 : MonoBehaviour {

    public Shader dofShader;
    private Material dofMat = null;
	public Shader blurShader  ;
	private Material blurMat  = null;
    public float focalDist = 10f;
    private float widthOverHeight  = 1.25f;
    private float oneOverBaseSize  = 1.0f / 512.0f;     
	// Use this for initialization
	void Start () {
        blurMat = new Material(blurShader);
        dofMat = new Material(dofShader);
	}

    void OnRenderImage (RenderTexture src ,RenderTexture dst ) {
        RenderTexture blurRT = RenderTexture.GetTemporary(src.width, src.height, 16);

        blurMat.SetVector("offsets", new Vector4(0.0f, 2f * oneOverBaseSize, 0.0f, 0.0f));
        Graphics.Blit(src, blurRT, blurMat);
        blurMat.SetVector("offsets", new Vector4(2f / widthOverHeight * oneOverBaseSize, 0.0f, 0.0f, 0.0f));
        Graphics.Blit(blurRT, blurRT, blurMat);

        focalDist = Mathf.Clamp(focalDist, camera.nearClipPlane, camera.farClipPlane);
        float fd = focalDist / (camera.farClipPlane - camera.nearClipPlane);
        dofMat.SetTexture("_BlurTex", blurRT);
        dofMat.SetFloat("dist",fd);
        Graphics.Blit(src, dst, dofMat);

        RenderTexture.ReleaseTemporary(blurRT);
	}
}
