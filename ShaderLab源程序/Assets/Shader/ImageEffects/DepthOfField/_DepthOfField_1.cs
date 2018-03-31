using UnityEngine;
using System.Collections;
public class _DepthOfField_1 : MonoBehaviour {
	public Shader blurShader  ;
	private Material blurMat  = null;	
    public float widthOverHeight  = 1.25f;
    public float oneOverBaseSize  = 1.0f / 512.0f;	
	void Start () {
        blurMat = new Material(blurShader);
	}
    void OnRenderImage (RenderTexture source ,RenderTexture destination ) {

        blurMat.SetVector("offsets", new Vector4(0.0f, 2f * oneOverBaseSize, 0.0f, 0.0f));
        Graphics.Blit(source, source, blurMat);
        blurMat.SetVector("offsets", new Vector4(2f / widthOverHeight * oneOverBaseSize, 0.0f, 0.0f, 0.0f));
        Graphics.Blit(source, destination, blurMat);
	}
}
