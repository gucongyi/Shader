Shader "Tut/Shader/Common/TexGen_3" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {TexGen SphereMap}
	}
	SubShader {
		pass{
			Material{ Diffuse(1,1,1,1)}
			Lighting On
			SetTexture[_MainTex]{ combine texture*primary double}
		}
	} 

}
