// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//////////////////////////////////////////////
/// 2DxFX - 2D SPRITE FX - by VETASOFT 2015 //
/// http://unity3D.vetasoft.com/            //
//////////////////////////////////////////////

Shader "2DxFX/Standard/Wave"
{
Properties
{
_MainTex ("Base (RGB)", 2D) = "white" {}
_OffsetX ("OffsetX", Range(0,128)) = 0
_OffsetY ("OffsetY", Range(0,128)) = 0
_DistanceX ("DistanceX", Range(0,1)) = 0
_DistanceY ("DistanceY", Range(0,1)) = 0
_WaveTimeX ("WaveTimeX", Range(0,360)) = 0
_WaveTimeY ("WaveTimeY", Range(0,360)) = 0
_Color ("Tint", Color) = (1,1,1,1)
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
float _OffsetX;
float _OffsetY;
fixed4 _Color;
float _DistanceX;
float _DistanceY;
float _WaveTimeX;
float _WaveTimeY;
fixed _Alpha;

v2f vert(appdata_t IN)
{
v2f OUT;
OUT.vertex = UnityObjectToClipPos(IN.vertex);
float2 p=IN.texcoord;
p.x= p.x+sin(p.y*_OffsetX+_WaveTimeX)*_DistanceX;
p.y= p.y+cos(p.x*_OffsetY+_WaveTimeY)*_DistanceY;
OUT.texcoord = p;
OUT.color = IN.color;
return OUT;
}


fixed4 frag(v2f IN) : COLOR
{

fixed4 mainColor = tex2D(_MainTex, IN.texcoord)* IN.color;
mainColor.a-=_Alpha;
return mainColor;
}
ENDCG
}
}
Fallback "Sprites/Default"

}