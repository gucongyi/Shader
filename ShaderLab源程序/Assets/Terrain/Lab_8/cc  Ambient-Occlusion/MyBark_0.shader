Shader "Tut/Terrain/MyBark_0" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,0)
		_MainTex ("Main Texture", 2D) = "white" {}
		_BaseLight ("Base Light", Range(0, 1)) = 0.35
		_AO ("Amb. Occlusion", Range(0, 10)) = 2.4
		
		// These are here only to provide default values
		_Scale ("Scale", Vector) = (1,1,1,1)
		_SquashAmount ("Squash", Float) = 1
	}
	
	SubShader {
		Tags {
			"IgnoreProjector"="True"
			"RenderType" = "TreeOpaque"
		}

		Pass {
			//Lighting On
		
			CGPROGRAM
			#pragma vertex bark
			#pragma fragment frag 
			#pragma glsl_no_auto_normalization
			#include "UnityCG.cginc"
			#include "TerrainEngine.cginc"
			
			struct v2f {
				float4 pos : POSITION;
				float4 uv : TEXCOORD0;
				fixed4 color : COLOR0;
			};
			float _Occlusion, _AO, _BaseLight;
			fixed4 _Color;
			sampler2D _MainTex;
			float4x4 _CameraToWorld;
			float3 _TerrainTreeLightDirections[4];
			float4 _TerrainTreeLightColors[4];
			v2f bark(appdata_tree v)
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
		

					float diffuse = dot (v.normal, lightDir.xyz);
					diffuse = max(0, diffuse);
					diffuse *= _AO * v.tangent.w + _BaseLight;
					light += lightColor * (diffuse * atten);
				}

				light.a = 1;
				o.color = light * _Color;
	
				#ifdef WRITE_ALPHA_1
				o.color.a = 1;
				#endif
	
				return o; 
			}
			fixed4 frag(v2f input) : COLOR
			{
				fixed4 col = input.color;
				col.rgb =(col.rgb+ 2.0f * tex2D( _MainTex, input.uv.xy).rgb)/2;
				return col;
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
			};
			
			struct appdata {
			    float4 vertex : POSITION;
			    fixed4 color : COLOR;
			};
			v2f vert( appdata v )
			{
				v2f o;
				TerrainAnimateTree(v.vertex, v.color.w);
				TRANSFER_SHADOW_CASTER(o)
				return o;
			}
			
			float4 frag( v2f i ) : COLOR
			{
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG	
		}
	}
	
	Dependency "BillboardShader" = "Hidden/Nature/Tree Soft Occlusion Bark Rendertex"
	Fallback Off
}
