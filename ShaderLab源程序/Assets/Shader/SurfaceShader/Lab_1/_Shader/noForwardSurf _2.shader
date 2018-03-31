Shader "Tut/SurfaceShader/Lab_1/noForwardSurf_2" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf MyDeferred 
		half4 LightingMyDeferred_PrePass (SurfaceOutput s, half4 light) {
			 half4 c;
            c.rgb = s.Albedo*light.rgb;
            c.a = s.Alpha;
            return c;
		}

		struct Input {
			float2 uv_MainTex;
		};
		sampler2D _MainTex;
		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack Off
}
