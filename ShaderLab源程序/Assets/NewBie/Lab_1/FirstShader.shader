Shader "Tut/NewBie/FirstShader" {
	Properties {
		_MyTexture ("Texture (RGB)", 2D) = "white" {}
		_MyColor("Color of Object",Color)=(1,1,1,1)
		_MyCube("Environment map",Cube)="white"{}
		_MyVector("Vector",vector)=(1,1,1,1)
		_MyFloat("Float Value",float)=1.0
		_MyRange("Another type of float",range(-13,14))=1.0
	}
	SubShader {
	Tags{"Queue"="Geometry" "RenderType"="Opaque" "IgnoreProjector"="True"}
	pass{
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"

	sampler2D _MyTexture;
	float4 _MyColor;
	samplerCUBE _MyCube;
	float4 _MyVector;
	float _MyFloat;
	float _MyRange;

	uniform float4x4 myMatrix;
	float4 vert(float4 v:POSITION):SV_POSITION
	{
		float pos=mul(UNITY_MATRIX_MVP,v);
		return pos;
	}
	float4 frag(void):COLOR
	{
		return 1;
	}
	ENDCG
		}
	} 
	FallBack "Diffuse"
}
