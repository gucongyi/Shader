// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//////////////////////////////////////////////
/// 2DxFX - 2D SPRITE FX - by VETASOFT 2015 //
/// http://unity3D.vetasoft.com/            //
//////////////////////////////////////////////

Shader "2DxFX/Standard/Lightning"
{
Properties
{
[HideInInspector] _MainTex ("Base (RGB)", 2D) = "white" {}
[HideInInspector] _MainTex2 ("Pattern (RGB)", 2D) = "white" {}
[HideInInspector] _Alpha ("Alpha", Range (0,1)) = 1.0
[HideInInspector] _Color ("Tint", Color) = (1,1,1,1)
[HideInInspector] _Value1 ("_Value1", Range (0,1)) = 0
[HideInInspector] _Value2 ("_Value2", Range (0,1)) = 0
[HideInInspector] _Value3 ("_Value3", Range (0,1)) = 0
[HideInInspector] _Value4 ("_Value4", Range (0,1)) = 0
[HideInInspector] _Value5 ("_Value5", Range (0,1)) = 0

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

v2f vert(appdata_t IN)
{
v2f OUT;
OUT.vertex = UnityObjectToClipPos(IN.vertex);
OUT.texcoord = IN.texcoord;
OUT.color = IN.color;

return OUT;
}

sampler2D _MainTex;
sampler2D _MainTex2;
fixed4 _Color;
fixed _Alpha;
float _Value1;
float _Value2;
float _Value3;
float _Value4;
float _Value5;

fixed4 frag(v2f IN) : COLOR
{

float speed=_Value1;
float2 uv=IN.texcoord;
uv+=float2(0,0);
uv/=8;
float tm=_Time;
uv.x += floor(fmod(tm*speed, 1.0)*8)/8;
uv.y += (1-floor(fmod(tm*speed/8, 1.0)*8)/8);
fixed4 t2 =  tex2D(_MainTex2, uv);

uv=IN.texcoord;
uv/=8;
tm+=0.2;
uv/=1.0;
uv.x += floor(fmod(tm*speed, 1.0)*8)/8;
uv.y += (1-floor(fmod(tm*speed/8, 1.0)*8)/8);
t2 +=  tex2D(_MainTex2, uv);

uv=IN.texcoord;
uv/=8; 
tm+=0.6+_Time;
uv.x += floor(fmod(tm*speed, 1.0)*8)/8;
uv.y += (1-floor(fmod(tm*speed/8, 1.0)*8)/8);
t2 +=  tex2D(_MainTex2, uv);

fixed4 t =  tex2D(_MainTex, IN.texcoord)*IN.color;
t2.a = t.a;


t.rgb+=t2*_Value2;


return float4(t.rgb,t.a*(1-_Alpha));
}
ENDCG
}
}
Fallback "Sprites/Default"

}