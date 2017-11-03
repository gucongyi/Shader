// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//////////////////////////////////////////////
/// 2DxFX - 2D SPRITE FX - by VETASOFT 2015 //
/// http://unity3D.vetasoft.com/            //
//////////////////////////////////////////////

Shader "2DxFX/Standard/4Gradients" 
{
Properties
{
_MainTex ("Base (RGB)", 2D) = "white" {}
_Color ("_Color", Color) = (1,1,1,1)
_Color1 ("_Color1", Color) = (1,1,1,1)
_Color2 ("_Color2", Color) = (1,1,1,1)
_Color3 ("_Color3", Color) = (1,1,1,1)
_Color4 ("_Color4", Color) = (1,1,1,1)
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
fixed4 _Color;
fixed4 _Color1;
fixed4 _Color2;
fixed4 _Color3;
fixed4 _Color4;
fixed _Alpha;

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
fixed4 c = tex2D(_MainTex,i.texcoord)*i.color;
fixed alpha = c.a;
float2 uv=i.texcoord.xy;
float4 colorA = lerp(_Color3,_Color4,uv.x*1.3);
float4 colorB = lerp(_Color1,_Color2,uv.x*1.3);
float4 colorC = lerp(colorA,colorB,uv.y*1.3);
c = lerp(c,colorC,colorC.a);
c.a= (alpha)-_Alpha;
return c;
}

ENDCG
}
}
Fallback "Sprites/Default"
}