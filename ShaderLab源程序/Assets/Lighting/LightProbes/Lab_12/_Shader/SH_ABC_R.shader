Shader "Tut/Lighting/LightProbes/Lab_12/SHABCR" {
		Properties {
			_SHAr ("First Order Harmonic", Vector) = (0.0,0.0,0.0,0.0) 
			_SHBr ("Second Order Harmonic", Vector) = (0.0,0.0,0.0,0.0) 
			_SHCr ("Third Order Harmonic", Vector) = (0.0,0.0,0.0,0.0) 
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
		
		uniform float4 _SHAr;
		uniform float4 _SHBr;
		uniform float4 _SHCr;

		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
		};

		v2f vert (appdata_full v)
		{
			v2f o; 
			float3 worldN =mul(_Object2World,float4(v.normal,0)).xyz;
			// Linear + constant polynomial terms
			float r1=dot(_SHAr,float4(worldN,1.0));
			// 4 of the quadratic polynomials
			half4 vB = worldN.xyzz * worldN.yzzx;
			float r2=dot(_SHBr,vB);
			// Final quadratic polynomial
			float vC = worldN.x*worldN.x-worldN.y*worldN.y;
			half3 r3 = _SHCr.rgb*vC;

			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.color = float4(r1+r2+r3.r,0,0,1.0);
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