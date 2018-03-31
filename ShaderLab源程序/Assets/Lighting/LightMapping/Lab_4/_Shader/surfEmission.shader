Shader "Self-Illumin/Lighting/LightMapping/Lab_4/surfEmission" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Base Color", Color) =(1,1,1,1)
		_EmissionLM("Emission(Lightmapper)",float)=1.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		float _EmissionLM;
		float4 _Color;
		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			o.Emission=_Color.rgb*_EmissionLM;
		}
		ENDCG
	} 
	FallBack Off
}
