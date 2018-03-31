// Upgrade NOTE: commented out 'float4 unity_ShadowFadeCenterAndType', a built-in variable

Shader "Tut/SurfaceShader/Deferred/Lab_2/VF_noAmbient" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
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
		  o.normal = mul((float3x3)_Object2World, SCALED_NORMAL);
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
		#pragma multi_compile_prepassfinal
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
		}//end surface func
		struct v2f_surf {
		  float4 pos : SV_POSITION;
		  float2 pack0 : TEXCOORD0;
		  float4 screen : TEXCOORD1;
		#ifdef LIGHTMAP_OFF
		#else
		  float2 lmap : TEXCOORD2;
		#ifdef DIRLIGHTMAP_OFF
		  float4 lmapFadePos : TEXCOORD3;
		#endif
		#endif
		};
		#ifndef LIGHTMAP_OFF
		float4 unity_LightmapST;
		#endif
		float4 _MainTex_ST;
		v2f_surf vert_surf (appdata_full v) {
			  v2f_surf o;
			  o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
			  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
			  o.screen = ComputeScreenPos (o.pos);
			#ifndef LIGHTMAP_OFF
			  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
			  #ifdef DIRLIGHTMAP_OFF
				o.lmapFadePos.xyz = (mul(_Object2World, v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w;
				o.lmapFadePos.w = (-mul(UNITY_MATRIX_MV, v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w);
			  #endif
			#else
			#endif
			  return o;
		}//end vertex func
		sampler2D _LightBuffer;
		#if defined (SHADER_API_XBOX360) && defined (HDR_LIGHT_PREPASS_ON)
		sampler2D _LightSpecBuffer;
		#endif
		#ifndef LIGHTMAP_OFF
		sampler2D unity_Lightmap;
		sampler2D unity_LightmapInd;
		float4 unity_LightmapFade;
		#endif
		fixed4 unity_Ambient;
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
		#if defined (SHADER_API_GLES)
		  light = max(light, half4(0.001));
		#endif
		#ifndef HDR_LIGHT_PREPASS_ON
		  light = -log2(light);
		#endif
		#if defined (SHADER_API_XBOX360) && defined (HDR_LIGHT_PREPASS_ON)
		  light.w = tex2Dproj (_LightSpecBuffer, UNITY_PROJ_COORD(IN.screen)).r;
		#endif
		#ifndef LIGHTMAP_OFF
		#ifdef DIRLIGHTMAP_OFF
		  half3 lmFull = DecodeLightmap (tex2D(unity_Lightmap, IN.lmap.xy));
		  half3 lmIndirect = DecodeLightmap (tex2D(unity_LightmapInd, IN.lmap.xy));
		  float lmFade = length (IN.lmapFadePos) * unity_LightmapFade.z + unity_LightmapFade.w;
		  half3 lm = lerp (lmIndirect, lmFull, saturate(lmFade));
		  light.rgb += lm;
		#else
		  fixed4 lmtex = tex2D(unity_Lightmap, IN.lmap.xy);
		  fixed4 lmIndTex = tex2D(unity_LightmapInd, IN.lmap.xy);
		  half4 lm = LightingLambert_DirLightmap(o, lmtex, lmIndTex, 0);
		  light += lm;
		#endif
		#else
		  //light.rgb += IN.vlight;
		#endif
		  half4 c = LightingLambert_PrePass (o, light);
		  return c;
		}//end fragment func
		ENDCG
		}//end prepass final
	} 
	FallBack "Diffuse"
}
