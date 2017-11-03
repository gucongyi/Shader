// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//////////////////////////////////////////////
/// 2DxFX - 2D SPRITE FX - by VETASOFT 2015 //
/// http://unity3D.vetasoft.com/            //
//////////////////////////////////////////////

Shader "2DxFX/Standard/SandFX"
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
	
	
inline float rand(float2 co){
    return frac(sin(dot(co.xy,float2(12.9898,78.233))) * 43758.5453);
}
float4 frag (v2f i) : COLOR
{

float4 Alpha = tex2D(_MainTex, i.texcoord+float2(sin(i.texcoord.y*125.82*_Distortion/3)/140,sin(i.texcoord.y*31.4*_Distortion/3)/40))*i.color;
float4 res;
float lum=dot(Alpha.rgb, float3(.222, .707, .071));
float noise=lerp(lum,rand(i.texcoord.xy),_Distortion/3);
if (noise>0.6) noise=0.6;
if (noise<0.3) noise=0.3;
res.rgb = noise;
res.r+=0.5;
res.g+=0.3;
res.b-=0.3;
res.rgb=lerp(Alpha.rgb,res.rgb,_Distortion);   
return float4(res.rgb, Alpha.a*(1.0-_Alpha));	
	
}

ENDCG
}
}
Fallback "Sprites/Default"

}