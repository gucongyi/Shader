Shader "Tut/Shadow/BuildInShadow/Collector_1.2" {
    Properties {
      _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader {
      Tags { "RenderType" = "Opaque" }
      
	CGPROGRAM
	#pragma surface surf Collector_2
	half4 LightingCollector_2 (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
	
			 half4 c=half4(0,0,0,0);
			c.rgb =float3(atten,atten, atten);
			c.a = atten;
			return c;
      }
      
      half4 LightingCollector_2_PrePass (SurfaceOutput s, half4 light) {
            half4 c=half4(0,0,0,0);
            c.rgb = s.Albedo * light.a;

            c.b=(1-light.a)+c.b;
            c.a = s.Alpha;
            return c;
      }

      struct Input {
          float2 uv_MainTex;
      };
      sampler2D _MainTex;
      void surf (Input IN, inout SurfaceOutput o) {
          o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
      }
      ENDCG
    }
    Fallback Off
  }
