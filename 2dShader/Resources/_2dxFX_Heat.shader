// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//////////////////////////////////////////////
/// 2DxFX - 2D SPRITE FX - by VETASOFT 2015 //
/// http://unity3D.vetasoft.com/            //
//////////////////////////////////////////////

Shader "2DxFX/Standard/Heat"
{
Properties
{
_MainTex ("Base (RGB)", 2D) = "white" {}
_Color ("_Color", Color) = (1,1,1,1)
_Distortion ("Distortion", Range(0,1)) = 0
_Alpha ("Alpha", Range (0,1)) = 1.0
_Speed ("Speed", Range (0,1)) = 1.0
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
float _Speed;
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
	
float2 uv = i.texcoord;
float time=_Time*8*_Speed;
	
uv.x += (sin(uv.y + (time * 0.7) *25) * 0.009*_Distortion) + (sin(uv.y + time) * 0.005);
uv.y += (cos(uv.y + (time * 0.7) *25) * 0.009*_Distortion) + (cos(uv.x + time) * 0.005);
		
float4 rcol=tex2D(_MainTex, uv)*i.color;
rcol.a = rcol.a*1-_Alpha;
return rcol;

}

ENDCG
}
}
Fallback "Sprites/Default"

}