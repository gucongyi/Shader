Shader "Tut/Shader/Common/ZRenderType_2" {
Properties {
    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
}
SubShader {
	Tags { "RenderType"="Opaque" }
	pass{
		ZTest LEqual
		Material{Diffuse(1,1,0,1)}
		Lighting On
		SetTexture[_MainTex]{combine texture*primary double}
	}
	}
}

