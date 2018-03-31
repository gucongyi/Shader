Shader "Tut/Shader/Common/Offset00" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" "Queue"="Geometry+300" }
		pass{
		Offset -1,-1
		Material{Diffuse(1,1,1,1)}
		Lighting On
		SetTexture[_MainTex]{
			combine texture*primary double
		}
		}
	} 
}
