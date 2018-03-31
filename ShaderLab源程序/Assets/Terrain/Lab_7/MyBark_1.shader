Shader "Tut/Terrain/MyBark_1" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,0)
	_MainTex ("Main Texture", 2D) = "white" {}
	_Scale ("Scale", Vector) = (1,1,1,1)
}
SubShader {
	Tags {	"IgnoreProjector"="True"	
	"RenderType" = "TreeOpaque"
		}
	Pass {
	Lighting On
	CGPROGRAM
	#pragma vertex bark
	#pragma fragment frag 
	#include "UnityCG.cginc"
	
	struct v2f {
		float4 pos : POSITION;
		float4 uv : TEXCOORD0;
		fixed4 color : COLOR0;
	};
	fixed4 _Color;
	float4 _Scale;
	sampler2D _MainTex;
	uniform float3 _TerrainTreeLightDirections[4];
	uniform float4 _TerrainTreeLightColors[4];
	v2f bark(appdata_base v)
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
		o.color.a=0;
		return o; 
	}
	fixed4 frag(v2f input) : COLOR
	{
		fixed4 col = input.color;
		col.rgb =col.rgb* tex2D( _MainTex, input.uv.xy).rgb*2;
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
Dependency "BillboardShader" = "Tut/Terrain/MyBarkMainTex"
Fallback Off
}
