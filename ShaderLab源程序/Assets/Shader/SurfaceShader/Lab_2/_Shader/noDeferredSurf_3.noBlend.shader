Shader "Tut/SurfaceShader/Lab_2/noDeferredSurf_3.noBlend" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		CGPROGRAM
		#pragma surface surf MyForwardLit exclude_path:prepass
		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};
		half4 LightingMyForwardLit (SurfaceOutput s, half3 lightDir, half atten) {
          half NdotL = dot (s.Normal, lightDir);
          half4 c;
          c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten * 2);
          c.a = s.Alpha;
          return c;
      }
	  half4 LightingMyForwardLit_PrePass (SurfaceOutput s, half4 light) {
			 half4 c;
            c.rgb = s.Albedo;
            c.a = s.Alpha;
            return c;
		}
		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack Off
}
