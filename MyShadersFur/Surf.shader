Shader "MyShader/Surf" {
	Properties {
		_MainTex ("_MainTex", 2D) = "white" {}

		_AlphaTex ("_AlphaTex", 2D) = "white" {}

		_NoiseTex ("_NoiseTex", 2D) = "white" {}

		_Color ("Color", Color) = (1,1,1,1)

		_MaxHairLength ("Hair Length", Range(0,1)) = 0.5

		_HairPadding ("Hair LPadding", Range(0,1)) = 0.05
	}
	SubShader {
		ZWrite On//要打开，否则皮肤层也会用透明度，会穿面。
		//Cull Off
		Tags { "QUEUE"="Transparent" "RenderType"="Opaque" "IgnoreProjector"="True"}
		Blend SrcAlpha OneMinusSrcAlpha
		LOD 200


		CGPROGRAM
		#pragma surface surfSkin StandardSpecular fullforwardshadows vertex:vertSkin
		#pragma target 3.0		
		#define CURRENTLAYER 0
 		#include"CommonSurf.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows  alpha:blend vertex:vert
		#pragma target 3.0
		#define CURRENTLAYER 0
		#include"CommonSurf.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows  alpha:blend vertex:vert
		#pragma target 3.0
		#define CURRENTLAYER 1
		#include"CommonSurf.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows  alpha:blend vertex:vert
		#pragma target 3.0
		#define CURRENTLAYER 2
		#include"CommonSurf.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows  alpha:blend vertex:vert
		#pragma target 3.0
		#define CURRENTLAYER 3
		#include"CommonSurf.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows  alpha:blend vertex:vert
		#pragma target 3.0
		#define CURRENTLAYER 4
		#include"CommonSurf.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows  alpha:blend vertex:vert
		#pragma target 3.0
		#define CURRENTLAYER 5
		#include"CommonSurf.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows  alpha:blend vertex:vert
		#pragma target 3.0
		#define CURRENTLAYER 6
		#include"CommonSurf.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows  alpha:blend vertex:vert
		#pragma target 3.0
		#define CURRENTLAYER 7
		#include"CommonSurf.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows  alpha:blend vertex:vert
		#pragma target 3.0
		#define CURRENTLAYER 8
		#include"CommonSurf.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows  alpha:blend vertex:vert
		#pragma target 3.0
		#define CURRENTLAYER 9
		#include"CommonSurf.cginc"
		ENDCG

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows  alpha:blend vertex:vert
		#pragma target 3.0
		#define CURRENTLAYER 10
		#include"CommonSurf.cginc"
		ENDCG
	}
	//FallBack "VertexLit"
}
