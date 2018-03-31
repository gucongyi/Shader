using UnityEngine;
public class _MotionBlur_1 : MonoBehaviour
{
	public float blurAmount = 0.8f;
    public Shader shader;
    private Material mat;
	public RenderTexture accumTexture;
	 void Start()
	{
        mat = new Material(shader);
        mat.hideFlags = HideFlags.HideAndDontSave;
	}
	void OnRenderImage (RenderTexture src, RenderTexture dst)
	{
		if (accumTexture == null)
		{
			accumTexture = new RenderTexture(src.width, src.height, 0);
			accumTexture.hideFlags = HideFlags.HideAndDontSave;
			Graphics.Blit( src, accumTexture );
		}
		blurAmount = Mathf.Clamp( blurAmount, 0.0f, 1f );
        mat.SetTexture("_AccumTex", accumTexture);
		mat.SetFloat("_AccumAmt", blurAmount);
		
		Graphics.Blit (src, accumTexture, mat);
        Graphics.Blit(accumTexture, dst);
	}
}
