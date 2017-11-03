// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//////////////////////////////////////////////
/// 2DxFX - 2D SPRITE FX - by VETASOFT 2015 //
/// http://unity3D.vetasoft.com/            //
//////////////////////////////////////////////

Shader "2DxFX/Standard/GoldenFX"
{
Properties
{
_MainTex ("Base (RGB)", 2D) = "white" {}
_Color ("_Color", Color) = (1,1,1,1)
_Distortion ("Distortion", Range(0,1)) = 0
_Alpha ("Alpha", Range (0,1)) = 1.0
}

SubShader
{

Tags {"Queue"="Transparent" "IgnoreProjector"="true" "RenderType"="Transparent"}
ZWrite Off Blend SrcAlpha OneMinusSrcAlpha Cull Off


Pass
{

CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma fragmentoption ARB_precision_hint_fastest
#pragma target 3.0
#include "UnityCG.cginc"

struct appdata_t
{
float4 vertex   : POSITION;
float4 color    : COLOR;
float2 texcoord : TEXCOORD0;
};

struct v2f
{
half2 texcoord  : TEXCOORD0;
float4 vertex   : SV_POSITION;
fixed4 color    : COLOR;
};


sampler2D _MainTex;
float _Distortion;
fixed _Alpha;
fixed4 _Color;

v2f vert(appdata_t IN)
{
v2f OUT;
OUT.vertex = UnityObjectToClipPos(IN.vertex);
OUT.texcoord = IN.texcoord;
OUT.color = IN.color;

return OUT;
}
	
	
float4 frag (v2f i) : COLOR
{
  	
	
	float2 uv = i.texcoord.xy;

	float2 step = 0.004;
				
	float4 tex = tex2D( _MainTex, uv); 
	float calc= 1.5 *_Distortion;
	float3 texA = tex2D( _MainTex, uv + float2(-step.x, -step.y) * calc).rgb;
	float3 texB = tex2D( _MainTex, uv + float2( step.x, -step.y) * calc).rgb;
	float3 texC = tex2D( _MainTex, uv + float2(-step.x,  step.y) * calc).rgb;
	float3 texD = tex2D( _MainTex, uv + float2( step.x,  step.y) * calc).rgb;
	float shadeA = dot(texA, 0.333333);
	float shadeB = dot(texB, 0.333333);
	float shadeC = dot(texC, 0.333333);
	float shadeD = dot(texD, 0.333333);
	float shade = 15.0 * pow(max(abs(shadeA - shadeD), abs(shadeB - shadeC)), 0.5);
				
	float3 col = lerp(float3(0.1, 0.18, 0.3), float3(0.4, 0.3, 0.2), shade);
					
	tex.a = tex.a*1-_Alpha;
	float4 r=float4(col,tex.a);
	r*=i.color;
	return r;

}

ENDCG
}
}
Fallback "Sprites/Default"

}