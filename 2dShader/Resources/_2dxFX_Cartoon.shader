// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//////////////////////////////////////////////
/// 2DxFX - 2D SPRITE FX - by VETASOFT 2015 //
/// http://unity3D.vetasoft.com/            //
//////////////////////////////////////////////

Shader "2DxFX/Standard/Cartoon" 
{
Properties
{
_MainTex ("Base (RGB)", 2D) = "white" {}
_Color ("_Color", Color) = (1,1,1,1)
_ColorLevel ("ColorLevel", Range(0,1)) = 0
_EdgeSize ("EdgeSize", Range(0,1)) = 0
_ColorB ("ColorB", Range(0,1)) = 0
_Size ("Size", Range(0,1)) = 0
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
#pragma glsl

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
float _ColorLevel;
float _EdgeSize;
float _ColorB;
fixed _Alpha;

v2f vert(appdata_t IN)
{
v2f OUT;
OUT.vertex = UnityObjectToClipPos(IN.vertex);
OUT.texcoord = IN.texcoord;
OUT.color = IN.color;

return OUT;
}
	#define tex2D(sampler,uvs)  tex2Dlod( sampler , float4( ( uvs ) , 0.0f , 0.0f) )
			
			
inline float4 edgeFilter(in int px, in int py, v2f i) 
{

	fixed4 color = 0.0;
	float2 kUV = i.texcoord*256.0f;
	color += tex2D(_MainTex, (kUV + float2(px + 1, py + 1)) * 0.00390625f);
	color += tex2D(_MainTex, (kUV + float2(px    , py + 1)) * 0.00390625f);
	color += tex2D(_MainTex, (kUV + float2(px - 1, py + 1)) * 0.00390625f);
	color += tex2D(_MainTex, (kUV + float2(px + 1, py )) * 0.00390625f);
	color += tex2D(_MainTex, (kUV + float2(px    , py )) * 0.00390625f);
	color += tex2D(_MainTex, (kUV + float2(px - 1, py )) * 0.00390625f);
	color += tex2D(_MainTex, (kUV + float2(px + 1, py - 1)) * 0.00390625f);
	color += tex2D(_MainTex, (kUV + float2(px    , py - 1)) * 0.00390625f);
	color += tex2D(_MainTex, (kUV + float2(px - 1, py - 1)) * 0.00390625f);


	return color / 9.0;

}


float4 frag (v2f i) : COLOR
{
	float2 uv 		=  i.texcoord;
  	float4 tex = tex2D(_MainTex, uv);
	   
  				fixed4 color = 0;
				float2 kUV = uv*256.0f;
				color += tex2D(_MainTex, (kUV + float2( 1 ,  1)) * 0.00390625f);
				color += tex2D(_MainTex, (kUV + float2( 0 ,  1)) * 0.00390625f);
				color += tex2D(_MainTex, (kUV + float2(-1 ,  1)) * 0.00390625f);
				color += tex2D(_MainTex, (kUV + float2( 1 ,  0)) * 0.00390625f);
				color += tex2D(_MainTex, (kUV ) * 0.00390625f);
				color += tex2D(_MainTex, (kUV + float2(-1 ,  0)) * 0.00390625f);
				color += tex2D(_MainTex, (kUV + float2( 1 , -1)) * 0.00390625f);
				color += tex2D(_MainTex, (kUV + float2( 0 , -1)) * 0.00390625f);
				color += tex2D(_MainTex, (kUV + float2(-1 , -1)) * 0.00390625f);
				
				color /= 9.0;
				
				color *=i.color;
				for(int a = 0 ; a < 3 ; a++ ) {
					color[a] = floor(7.0 * color[a]) / _ColorLevel;
				}

				fixed4 sum = abs(edgeFilter(0, 1, i) - edgeFilter(0, -1, i));
				sum += abs(edgeFilter(1, 0, i) - edgeFilter(-1, 0, i));
				sum /= 2.0;

				float edgsum = _EdgeSize + 0.05;
				if(length(sum) > edgsum) {
					color.rgb = 0.0;
				}

		
			
	return float4(color.rgb,tex.a*1-_Alpha);
	


}

ENDCG
}
}
Fallback "Sprites/Default"

}