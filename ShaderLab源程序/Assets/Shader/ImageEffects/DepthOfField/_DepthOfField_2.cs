using UnityEngine;
using System.Collections;

public class _DepthOfField_2 : MonoBehaviour {

    public Shader dofShader;
    private Material dofMat = null;
	public Shader blurShader  ;
	private Material blurMat  = null;	
    
    private float widthOverHeight  = 1.25f;
    private float oneOverBaseSize  = 1.0f / 512.0f;	
        
	// Use this for initialization
	void Start () {
        blurMat = new Material(blurShader);
        dofMat = new Material(dofShader);
	}

    void OnRenderImage (RenderTexture src ,RenderTexture dst ) {
        RenderTexture blurRT = RenderTexture.GetTemporary(src.width, src.height, 16);

        blurMat.SetVector("offsets", new Vector4(2f / widthOverHeight * oneOverBaseSize, 2f * oneOverBaseSize, 0.0f, 0.0f));
        Graphics.Blit(src, blurRT, blurMat);
        blurMat.SetVector("offsets", new Vector4(2f / widthOverHeight * oneOverBaseSize, 0.0f, 0.0f, 0.0f));
        Graphics.Blit(blurRT, blurRT, blurMat);
        dofMat.SetTexture("_BlurTex", blurRT);
        Graphics.Blit(src, dst, dofMat);

        RenderTexture.ReleaseTemporary(blurRT);
	}
}
