/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */


Shader "Live2D Cubism/UnlitGaussianBlur"
{
	Properties
	{
		// Texture and model opacity settings.
		[PerRendererData] _MainTex("Main Texture", 2D) = "white" {}
		[PerRendererData] cubism_ModelOpacity("Model Opacity", Float) = 1

		_BlurRadius ("BlurRadius", Range(5, 30)) = 15
		_TextureSize ("TextureSize", Float) = 256
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
			int _BlurRadius;
			float _TextureSize;

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

			//这一步其实可以用计算出来的常量来替代，不需要在循环中每一步计算
			float GetGaussWeight(float x, float y, float sigma)
			{
				float sigma2 = pow(sigma, 2.0f);
				float left = 1 / (2 * sigma2 * 3.1415926f);
				float right = exp(-(x*x+y*y)/(2*sigma2));
				return left * right;
			}
 
			fixed4 GaussBlur(float2 uv)
			{
				//因为高斯函数中3σ以外的点的权重已经很小了，因此σ取半径r/3的值
				float sigma = (float)_BlurRadius / 3.0f;
				float4 col = float4(0, 0, 0, 0);
				for (int x = - _BlurRadius; x <= _BlurRadius; ++x)
				{
					for (int y = - _BlurRadius; y <= _BlurRadius; ++y)
					{
						//获取周围像素的颜色
						//因为uv是0-1的一个值，而像素坐标是整形，我们要取材质对应位置上的颜色，需要将整形的像素坐标
						//转为uv上的坐标值
						float4 color = tex2D(_MainTex, uv + float2(x / _TextureSize, y / _TextureSize));
						//获取此像素的权重
						float weight = GetGaussWeight(x, y, sigma);
						//计算此点的最终颜色
						col += color * weight;
						
					}
				}
				return col;
			}
			fixed4 frag (v2f IN) : SV_Target
			{
				//fixed4 OUT = tex2D(_MainTex, IN.texcoord) * IN.color;
				fixed4 OUT=GaussBlur(IN.texcoord);
				OUT=OUT*IN.color;
				// Apply Cubism alpha to color.
				CUBISM_APPLY_ALPHA(IN, OUT);


				return OUT;
			}
			ENDCG
		}
	}
}
