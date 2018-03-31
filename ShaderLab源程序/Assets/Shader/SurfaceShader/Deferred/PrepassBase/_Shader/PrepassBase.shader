Shader "Tut/SurfaceShader/Deferred/PrepassBase" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
	Pass {
	Name "PREPASS"
	Tags { "LightMode" = "Always" }
	Fog {Mode Off}
	CGPROGRAM
	#pragma vertex vert_surf
	#pragma fragment frag_surf
	#pragma fragmentoption ARB_precision_hint_fastest
	#include "UnityCG.cginc"
	#include "Lighting.cginc"

	#define INTERNAL_DATA
	#define WorldReflectionVector(data,normal) data.worldRefl
	#define WorldNormalVector(data,normal) normal
	sampler2D _MainTex;
	struct Input {
		float2 uv_MainTex;
	};
	void surf (Input IN, inout SurfaceOutput o) {
		half4 c = tex2D (_MainTex, IN.uv_MainTex);
		o.Albedo = c.rgb;
		o.Alpha = c.a;
	}
	struct v2f_surf {
		float4 pos : SV_POSITION;
		fixed3 normal : TEXCOORD0;
	};
	v2f_surf vert_surf (appdata_full v) {
		  v2f_surf o;
		  o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
		  o.normal = mul((float3x3)_Object2World, SCALED_NORMAL);
		  return o;
	}
	fixed4 frag_surf (v2f_surf IN) : COLOR {
	  Input surfIN;
	  SurfaceOutput o;
	  o.Albedo = 0.0;
	  o.Emission = 0.0;
	  o.Specular = 0.0;
	  o.Alpha = 0.0;
	  o.Gloss = 0.0;
	  o.Normal = IN.normal;
	  surf (surfIN, o);
	  fixed4 res;
	  res.rgb = o.Normal * 0.5 + 0.5;
	  res.a = o.Specular;
	  return res;
	}
	ENDCG
	}//end prepass base
	}
	FallBack Off
}
