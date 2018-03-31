Shader "Tut/SurfaceShader/Deferred/PrepassFinal.2" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_LightAmt("Light Factor",range(0,1))=0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
	Pass {
	Name "PREPASS"
	Tags { "LightMode" = "PrePassBase" }
	Fog {Mode Off}
	CGPROGRAM
	#pragma vertex vert_surf
	#pragma fragment frag_surf
	#pragma fragmentoption ARB_precision_hint_fastest
	#include "HLSLSupport.cginc"
	#include "UnityShaderVariables.cginc"
	#define UNITY_PASS_PREPASSBASE
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
		  o.normal = mul(_Object2World,float4( SCALED_NORMAL,0)).xyz;
		  return o;
	}
	fixed4 frag_surf (v2f_surf IN) : COLOR {
	  Input surfIN;
	  #ifdef UNITY_COMPILER_HLSL
		  SurfaceOutput o = (SurfaceOutput)0;
		  #else
		  SurfaceOutput o;
		  #endif
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
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassFinal" }
		ZWrite Off
		CGPROGRAM
		#pragma vertex vert_surf
		#pragma fragment frag_surf
		#pragma fragmentoption ARB_precision_hint_fastest
		#pragma multi_compile_prepassfinal nolightmap
		#include "HLSLSupport.cginc"
		#include "UnityShaderVariables.cginc"
		#define UNITY_PASS_PREPASSFINAL
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
		  float2 pack0 : TEXCOORD0;
		  float4 screen : TEXCOORD1;
		  float3 vlight : TEXCOORD2;
		};
		float4 _MainTex_ST;
		v2f_surf vert_surf (appdata_full v) {
		  v2f_surf o;
		  o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
		  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
		  o.screen = ComputeScreenPos (o.pos);
		  o.vlight=0;
		  return o;
		}
		sampler2D _LightBuffer;
		float _LightAmt;
		fixed4 frag_surf (v2f_surf IN) : COLOR {
			  Input surfIN;
			  surfIN.uv_MainTex = IN.pack0.xy;
			 #ifdef UNITY_COMPILER_HLSL
		  SurfaceOutput o = (SurfaceOutput)0;
		  #else
		  SurfaceOutput o;
		  #endif
			  o.Albedo = 0.0;
			  o.Emission = 0.0;
			  o.Specular = 0.0;
			  o.Alpha = 0.0;
			  o.Gloss = 0.0;
			  surf (surfIN, o);
			  half4 light = tex2Dproj (_LightBuffer, UNITY_PROJ_COORD(IN.screen));
			#ifndef HDR_LIGHT_PREPASS_ON
			  light = -log2(light);
			#endif
			  half4 c = LightingLambert_PrePass (o,lerp(float4(1,1,1,1),light,_LightAmt));
			  return c;
			}
		ENDCG
		}//end prepass final
	} 
	FallBack "Diffuse"
}
