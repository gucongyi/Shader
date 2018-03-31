Shader "Tut/Terrain/MyLeaves_1" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Main Texture", 2D) = "white" {  }
	_Cutoff ("Alpha cutoff", Range(0.25,0.9)) = 0.5
	_Scale ("Scale", Vector) = (1,1,1,1)
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
			
	fixed4 _Color;
	float4 _Scale;
	sampler2D _MainTex;
	fixed _Cutoff;
	float3 _TerrainTreeLightDirections[4];
	float4 _TerrainTreeLightColors[4];
	struct v2f {
		float4 pos : POSITION;
		float4 uv : TEXCOORD0;
		fixed4 color : COLOR0;
	};
	float4x4 _CameraToWorld;
	float _HalfOverCutoff;
	v2f leaves(appdata_base v)
	{
		v2f o;
		v.vertex.xyz*=_Scale.xyz;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord;
		float4 light = UNITY_LIGHTMODEL_AMBIENT;

		for (int i = 0; i < 4; i++) {
			float diffuse =max(0, dot (v.normal,  _TerrainTreeLightDirections[i]));
			light += _TerrainTreeLightColors[i] *diffuse;
		}
		o.color.rgb = light.rgb+ShadeVertexLights(v.vertex,v.normal);
		o.color*=_Color;
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
	Dependency "BillboardShader" = "Tut/Terrain/MyLeavesMainTex"
	Fallback Off
}
