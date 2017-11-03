// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//////////////////////////////////////////////
/// 2DxFX - 2D SPRITE FX - by VETASOFT 2015 //
/// http://unity3D.vetasoft.com/            //
//////////////////////////////////////////////

Shader "2DxFX/Standard/Liquid"
{
Properties
{
_MainTex ("Base (RGB)", 2D) = "white" {}
_Color ("_Color", Color) = (1,1,1,1)
_Distortion ("Distortion", Range(0,1)) = 0
_Alpha ("Alpha", Range (0,1)) = 1.0
_Speed ("Speed", Range (0,1)) = 1.0
EValue ("EValue", Range (0,1)) = 1.0
Light ("Light", Range (0,1)) = 1.0
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
float EValue;
fixed4 _Color;
float Light;

v2f vert(appdata_t IN)
{
v2f OUT;
OUT.vertex = UnityObjectToClipPos(IN.vertex);
OUT.texcoord = IN.texcoord;
OUT.color = IN.color;

return OUT;
}
	
float col(float2 coord)
{
float time = _Time*10;
float delta_theta = 0.897597901025655210989326680937;
float col = 0.0;
float theta = 0.0;
for (int i = 0; i < 8; i++)
{
float _Value=_Speed;
float _Value2=_Distortion;
float _Value3=_Distortion;
float _Value4=_Distortion;

float2 adjc = coord;
theta = delta_theta*float(i);
adjc.x += cos(theta)*time*_Value + time * _Value2;
adjc.y -= sin(theta)*time*_Value - time * _Value3;
col = col + cos( (adjc.x*cos(theta) - adjc.y*sin(theta))*6.0);
}
return cos(col);
}

float4 frag (v2f i) : COLOR
{
float2 p = i.texcoord.xy, c1 = p, c2 = p;
float cc1 = col(c1);
c2.x += 8.53;
float dx =  0.50*(cc1-col(c2))/60;
c2.x = p.x;
c2.y += 8.53;
float dy =  0.50*(cc1-col(c2))/60;
c1.x += dx*2.;
c1.y = (c1.y+dy*2.);
float alpha = 1.+dot(dx,dy)*700*Light;
float ddx = dx - 0.012;
float ddy = dy - 0.012;
if (ddx > 0. && ddy > 0.) alpha = pow(alpha, ddx*ddy*200000);
c1=lerp(p,c1,EValue);
float4 col = tex2D(_MainTex,c1)*(alpha)*i.color;
return float4(col.rgb,col.a*(1-_Alpha));
}

ENDCG
}
}
Fallback "Sprites/Default"

}