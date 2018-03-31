Shader "Tut/Shader/Common/TexGen_2" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {TexGen EyeLinear}
	}
	SubShader {
		pass{
			Material{ Diffuse(1,1,1,1)}
			Lighting On
			SetTexture[_MainTex]{ combine texture*primary double}
		}
	} 

}
