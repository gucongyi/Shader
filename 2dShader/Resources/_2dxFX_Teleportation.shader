// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//////////////////////////////////////////////
/// 2DxFX - 2D SPRITE FX - by VETASOFT 2015 //
/// http://unity3D.vetasoft.com/            //
//////////////////////////////////////////////

Shader "2DxFX/Standard/Teleportation"
{
Properties
{
_MainTex ("Base (RGB)", 2D) = "white" {}
_Distortion ("Distortion", Range(0,1)) = 0
_Alpha ("Alpha", Range (0,1)) = 1.0
_Color ("Tint", Color) = (1,1,1,1)
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
    return frac(sin(dot(co.xy ,float2(12.9898,78.233))) * 43758.5453 *_Time);
}




	inline float mod(float x,float modu) 
{
  return x - floor(x * (1.0 / modu)) * modu;
}   

fixed4 rainbow(float t) 
{
	t=mod(t,1.0);
	fixed tx = t * 6.0;
	
	fixed r = clamp(tx - 2.0, 0.0, 1.0) + clamp(2.0 - tx, 0.0, 1.0);
	
	return fixed4(1.0, 1.0, 1.0,r);
}

float4 plasma(float2 uv)
{
	float2 tuv = uv;
	uv *= 1.0*_Distortion*10;
	float a = 1.1 + 20 * 2.25;
	float n = sin(a + 2.0 * uv.x) + sin(a - 2.0 * uv.x) + sin(a + 2.0 * uv.y) + sin(a + 5.0 * uv.y);
	n = mod(((5.0 + n) / 5.0), 1.0);
	n += tex2D(_MainTex, tuv).r * 11.2 + tex2D(_MainTex, tuv).g * 8.4 + tex2D(_MainTex, tuv).b * 4.2;
	
	return rainbow(n);
}


inline float added(float2 sh, float d)
{
	float2 rsh = sh * 0.70710638280; 
	return 0.5 + 0.25 * cos((rsh.x + rsh.y) * d) + 0.25 * cos((rsh.x - rsh.y) * d);
}

float4 frag (v2f i) : COLOR
{

fixed threshold 		= _Distortion;
	fixed rasterPattern = added(i.texcoord.xy , 2136.2812 / _Distortion  );
	fixed4 srcPixel 	= tex2D(_MainTex, i.texcoord.xy);
        
	fixed avg 			= 0.2125 * srcPixel.r + 0.7154 * srcPixel.g + 0.0721 * srcPixel.b;
    fixed gray 			= (rasterPattern * _Distortion + avg - _Distortion) / (1.0 - _Distortion);

float4 tex=tex2D(_MainTex, i.texcoord.xy);
float4 noise=lerp(tex,rand(i.texcoord.xy),_Distortion);

float4 sortie=plasma(i.texcoord);
noise.rgb=noise.rgb+ ((1-sortie.a)*_Distortion);

noise.rb*=(1-_Distortion);
noise.a=(tex.a*(1-_Alpha)*(1-_Distortion));
return noise*i.color;



}

ENDCG
}
}
Fallback "Sprites/Default"

}