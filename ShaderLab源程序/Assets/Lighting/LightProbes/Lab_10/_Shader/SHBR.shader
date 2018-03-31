Shader "Tut/Lighting/LightProbes/Lab_10/SHBR" {
		Properties {
			_SHBr ("Second Order Harmonic", Vector) = (0.0,0.0,0.0,0.0) 
		}

 SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" } 
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off 
		Lighting Off 
		ZWrite On
 
	Pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma exclude_renderers
		#pragma target 2.0
 
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
 
		uniform float4 _SHBr;

		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
		};

		v2f vert (appdata_full v)
		{
			v2f o; 
			float3 worldN =mul(_Object2World,float4(v.normal,0)).xyz;
			// 4 of the quadratic polynomials
			half4 vB = worldN.xyzz * worldN.yzzx;
			float r = dot(_SHBr,vB);
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.color = float4(r,0,0,1.0);
			return o;
		}

		fixed4 frag (v2f i) : COLOR
		{
			return i.color;
		}
	ENDCG 
	}//endpass 
	}
} 