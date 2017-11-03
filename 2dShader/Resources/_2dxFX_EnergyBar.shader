// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//////////////////////////////////////////////
/// 2DxFX - 2D SPRITE FX - by VETASOFT 2015 //
/// http://unity3D.vetasoft.com/            //
//////////////////////////////////////////////

Shader "2DxFX/Standard/EnergyBar"
{
Properties
{
_MainTex ("Base (RGB)", 2D) = "white" {}
_Color ("_Color", Color) = (1,1,1,1)
_Value1 ("_Value1", Range(0,1)) = 1
_Value2 ("_Value2", Range(0,1)) = 1
_Value3 ("_Value3", Range(0,1)) = 1
_Value4 ("_Value4", Range(0,1)) = 1
_Value5 ("_Value5", Range(0,1)) = 1

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
float _Size;
float _Value1;
float _Value2;
float _Value3;
float _Value4;
float _Value5;

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

float2 uv=i.texcoord;
fixed4 mainColor = tex2D(_MainTex, i.texcoord)*i.color;
_Value1=_Value1;
float energy= smoothstep( _Value1-_Value2,_Value1+_Value2, uv.x);
float xx=smoothstep( 0.15-0.1,0.15+0.1, uv.x)*_Value1;

float3 C1 = float3(1,0,0);
float3 C2 = mainColor.rgb;
C1=lerp(mainColor.rgb,C1,_Value4);
C1=lerp(C1,mainColor.rgb,xx);
_Value1=_Value1;
float3 CR = lerp(C1,C2,_Value1);


float4 CRA= float4(CR,mainColor.a);
mainColor= lerp(CRA,mainColor-float4(_Value3,_Value3,_Value3,1-_Value5),energy);
mainColor.a = mainColor.a-_Alpha;

return mainColor;
}
ENDCG
}
}
Fallback "Sprites/Default"
}