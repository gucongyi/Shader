// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//////////////////////////////////////////////
/// 2DxFX - 2D SPRITE FX - by VETASOFT 2015 //
/// http://unity3D.vetasoft.com/            //
//////////////////////////////////////////////

Shader "2DxFX/Standard/PlasmaRainbow"
{
Properties
{
_MainTex ("Base (RGB)", 2D) = "white" {}
_Colors ("Colors", Range(4,128)) = 4
_Color ("Color", Color) = (1,1,1,1)
_Offset ("Offset", Range(4,128)) = 1
_Alpha ("Alpha", Range (0,1)) = 1.0
_TimeX ("TimeX", Range(0,1)) = 0

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
float _Offset;
fixed _Alpha;
float _Colors;
fixed _TimeX;


v2f vert(appdata_t IN)
{
v2f OUT;
OUT.vertex = UnityObjectToClipPos(IN.vertex);
OUT.texcoord = IN.texcoord;
OUT.color = IN.color;
return OUT;
}

inline float mod(float x,float modu) 
{
  return x - floor(x * (1.0 / modu)) * modu;
}   

float3 rainbow(float t) {
	t=mod(t,1.0);
	float tx = t * _Colors;
	
	float r = clamp(tx - 4.0, 0.0, 1.0) + clamp(2.0 - tx, 0.0, 1.0);
	float g = tx < 2.0 ? clamp(tx, 0.0, 1.0) : clamp(4.0 - tx, 0.0, 1.0);
	float b = tx < 4.0 ? clamp(tx - 2.0, 0.0, 1.0) : clamp(6.0 - tx, 0.0, 1.0);
	return float3(r, g, b);
}

float3 plasma(float2 uv)
{
	
	
	float a = 1.1 + _TimeX * 2.25+_Offset;
	float b = 0.5 + _TimeX * 1.77+_Offset;
	float c = 8.4 + _TimeX * 1.58+_Offset;
	float d = 610 + _TimeX * 2.03+_Offset;
	float x1=2.0*uv.x;
	float n = sin(a + x1) + sin(b - x1) + sin(c + 2.0 * uv.y) + sin(d + 5.0 * uv.y);
	n = mod(((5.0 + n) / 5.0), 1.0);
	float4 nx=tex2D(_MainTex,uv);
	n += nx.r * 0.2 + nx.g * 0.4 + nx.b * 0.2;
	
	return rainbow(n);
}




float4 frag (v2f i) : COLOR
{
	float alpha = tex2D(_MainTex, i.texcoord).a;
	return float4(plasma(i.texcoord), alpha-_Alpha)*i.color;	

}
ENDCG
}
}
Fallback "Sprites/Default"

}