Shader "Tut/Terrain/MyLeaves_2" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Main Texture", 2D) = "white" {  }
		_Cutoff ("Alpha cutoff", Range(0.25,0.9)) = 0.5
		_AO ("Amb. Occlusion", Range(0, 10)) = 2.4
		_Occlusion ("Dir Occlusion", Range(0, 20)) = 7.5
		
		// These are here only to provide default values
		_Scale ("Scale", Vector) = (1,1,1,1)
		_SquashAmount ("Squash", Float) = 1
	}
	
	SubShader {
		Tags {
			"Queue" = "Transparent-99"
			"IgnoreProjector"="True"
			"RenderType" = "TreeTransparentCutout"
		}
		Cull Off
		ColorMask RGB
		
		Pass {
			Lighting On
		
			CGPROGRAM
			#pragma vertex leaves
			#pragma fragment frag 
			#pragma glsl_no_auto_normalization
			#include "UnityCG.cginc"
			#include "TerrainEngine.cginc"
			
			float _Occlusion, _AO;
			fixed4 _Color;
			float3 _TerrainTreeLightDirections[4];
			float4 _TerrainTreeLightColors[4];
			struct v2f {
				float4 pos : POSITION;
				float4 uv : TEXCOORD0;
				fixed4 color : COLOR0;
			};
			float4x4 _CameraToWorld;
			float _HalfOverCutoff;
			sampler2D _MainTex;
			fixed _Cutoff;
			
			v2f leaves(appdata_tree v)
			{
				v2f o;
				TerrainAnimateTree(v.vertex, v.color.w);
				float3 viewpos = mul(UNITY_MATRIX_MV, v.vertex);
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.texcoord;
	
				float4 lightDir = 0;
				float4 lightColor = 0;
				lightDir.w = _AO;

				float4 light = UNITY_LIGHTMODEL_AMBIENT;

				for (int i = 0; i < 4; i++) {
					float atten = 1.0;
					#ifdef USE_CUSTOM_LIGHT_DIR
						lightDir.xyz = _TerrainTreeLightDirections[i];
						lightColor = _TerrainTreeLightColors[i];
					#else
							float3 toLight = unity_LightPosition[i].xyz - viewpos.xyz * unity_LightPosition[i].w;
							toLight.z *= -1.0;
							lightDir.xyz = mul( (float3x3)_CameraToWorld, normalize(toLight) );
							float lengthSq = dot(toLight, toLight);
							atten = 1.0 / (1.0 + lengthSq * unity_LightAtten[i].z);
				
							lightColor.rgb = unity_LightColor[i].rgb;
					#endif

					lightDir.xyz *= _Occlusion;
					//float occ =  dot (v.tangent, lightDir);
					float occ =  dot (v.tangent.xyz, lightDir.xyz);//Dir OC
					occ=occ+v.tangent.w*_AO;
					occ = max(0, occ);
					light += lightColor * (occ * atten);
				}

				o.color = light * _Color;
				o.color.a = 0.5 * _HalfOverCutoff;
	
				return o; 
			}
			fixed4 frag(v2f input) : COLOR
			{
				fixed4 c = tex2D( _MainTex, input.uv.xy);
				c.rgb *= 2.0f * input.color.rgb;
				
				clip (c.a - _Cutoff);
				
				return c;
			}
			ENDCG
		}
		
		Pass {
			Name "ShadowCaster"
			Tags { "LightMode" = "ShadowCaster" }
			
			Fog {Mode Off}
			ZWrite On ZTest LEqual Cull Off
			Offset 1, 1
	
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma glsl_no_auto_normalization
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"
			#include "TerrainEngine.cginc"
			
			struct v2f { 
				V2F_SHADOW_CASTER;
				float2 uv : TEXCOORD1;
			};
			
			struct appdata {
			    float4 vertex : POSITION;
			    fixed4 color : COLOR;
			    float4 texcoord : TEXCOORD0;
			};
			v2f vert( appdata v )
			{
				v2f o;
				TerrainAnimateTree(v.vertex, v.color.w);
				TRANSFER_SHADOW_CASTER(o)
				o.uv = v.texcoord;
				return o;
			}
			
			sampler2D _MainTex;
			fixed _Cutoff;
					
			float4 frag( v2f i ) : COLOR
			{
				fixed4 texcol = tex2D( _MainTex, i.uv );
				clip( texcol.a - _Cutoff );
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG	
		}
	}
	Dependency "BillboardShader" = "Hidden/Nature/Tree Soft Occlusion Leaves Rendertex"
	Fallback Off
}
