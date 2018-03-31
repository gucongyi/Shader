Shader "Tut/Effects/Lab_5/DecalLinearFog" {
	Properties {
		_Decal("Decal" ,2d)="white"{}
		_Color ("Base Color", color) =(1,1,1,1)
		_Density("Density",Range(0,10))=1
	}
	SubShader {
		
		pass{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "LightMode"="ForwardBase"}
		Blend One OneMinusSrcColor
		ColorMask RGB
		Cull Off Lighting Off ZWrite Off Fog { Mode off }
		//Blend OneMinusDstColor One
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile_fwdbase
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		sampler2D _Decal;
		float4 _Color;
		float _Density;

		struct vertOut{
			float4 pos:SV_POSITION;
			float2 uv : TEXCOORD0;
			float4 posV:TEXCOORD2;
			//float n:TEXCOORD3;
		};
		vertOut vert(appdata_base v)
		{
			vertOut o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.uv=v.texcoord;
			o.posV=mul(UNITY_MATRIX_MV,v.vertex);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
				//float dist=distance(i.ori.xy,i.posV.xy);
			    float4 c=_Density*_Color*tex2D(_Decal,i.uv).a*(-i.posV.z*_ProjectionParams.w);
			    return c;
		}
		ENDCG
		}//end pass
	}
}

