Shader "Custom/Mask" {
	Properties {
		_MainTex ("Main Texture", 2D) = "white" {}
		_Mask ("Mask Texture", 2D) = "white" {}
	}
	SubShader {
	
		Tags { "Queue" = "Transparent" }
		Lighting On
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			SetTexture [_Mask] {combine texture}//第一次设置纹理，目的为了拿到遮罩的透明度
			SetTexture [_MainTex] {combine texture , previous}//覆盖纹理，用前一次的纹理的透明度做透明度
		}
	} 
}
