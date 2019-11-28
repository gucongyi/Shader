/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */


Shader "Live2D Cubism/UnlitBlur"
{
	Properties
	{
		// Texture and model opacity settings.
		[PerRendererData] _MainTex("Main Texture", 2D) = "white" {}
		[PerRendererData] cubism_ModelOpacity("Model Opacity", Float) = 1

		_Ambient ("Ambient", float) = 0.001 //这里定义模糊的程度  
		// Blend settings.
		_SrcColor("Source Color", Int)		= 0
		_DstColor("Destination Color", Int)	= 0
		_SrcAlpha("Source Alpha", Int)		= 0
		_DstAlpha("Destination Alpha", Int) = 0


		// Mask settings.
		[Toggle(CUBISM_MASK_ON)] cubism_MaskOn("Mask?", Int) = 0
		[Toggle(CUBISM_INVERT_ON)] cubism_InvertOn("Inverted?", Int) = 0
		[PerRendererData] cubism_MaskTexture("cubism_Internal", 2D) = "white" {}
		[PerRendererData] cubism_MaskTile("cubism_Internal", Vector) = (0, 0, 0, 0)
		[PerRendererData] cubism_MaskTransform("cubism_Internal", Vector) = (0, 0, 0, 0)
	}
	SubShader
	{
		Tags
		{
			"Queue"				= "Transparent"
			"IgnoreProjector"	= "True"
			"RenderType"		= "Transparent"
			"PreviewType"		= "Plane"
			"CanUseSpriteAtlas" = "True"
		}

		Cull     Off
		Lighting Off
		ZWrite   Off
		Blend    [_SrcColor][_DstColor], [_SrcAlpha][_DstAlpha]

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile CUBISM_MASK_ON CUBISM_MASK_OFF CUBISM_INVERT_ON


			#include "UnityCG.cginc"
			#include "CubismCG.cginc"


			struct appdata
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};


			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_OUTPUT_STEREO

				// Add Cubism specific vertex output data.
				CUBISM_VERTEX_OUTPUT
			};


			sampler2D _MainTex;
			float   _Ambient;

			// Include Cubism specific shader variables.
			CUBISM_SHADER_VARIABLES


			v2f vert (appdata IN)
			{
				v2f OUT;


				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);


				OUT.vertex	 = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color	 = IN.color;


				// Initialize Cubism specific vertex output data.
				CUBISM_INITIALIZE_VERTEX_OUTPUT(IN, OUT);


				return OUT;
			}


			fixed4 frag (v2f IN) : SV_Target
			{
				float2 tmpUV =  IN.texcoord ;
				fixed4 col2 = tex2D(_MainTex, tmpUV+float2(-_Ambient,_Ambient))*14;
				fixed4 col3 = tex2D(_MainTex, tmpUV+float2(0,_Ambient))*15;
				fixed4 col4 = tex2D(_MainTex, tmpUV+float2(-_Ambient,_Ambient))*16;
				fixed4 col5 = tex2D(_MainTex, tmpUV+float2(-_Ambient,0))*24;
				fixed4 OUT = tex2D(_MainTex, tmpUV)*25 ;
				fixed4 col6 = tex2D(_MainTex, tmpUV+float2(_Ambient,0))*26;
				fixed4 col7 = tex2D(_MainTex, tmpUV+float2(-_Ambient,-_Ambient))*34;
				fixed4 col8 = tex2D(_MainTex, tmpUV+float2(0,-_Ambient))*35;
				fixed4 col9 = tex2D(_MainTex, tmpUV+float2(_Ambient,-_Ambient))*36;
				OUT  =  (OUT + col2 +col3+col4+col5+ col6 +col7+col8+col9) /9/25 ;//每个点的值是它上下左右四个点的平均值
				OUT=OUT*IN.color;
				// Apply Cubism alpha to color.
				CUBISM_APPLY_ALPHA(IN, OUT);


				return OUT;
			}
			ENDCG
		}
	}
}
