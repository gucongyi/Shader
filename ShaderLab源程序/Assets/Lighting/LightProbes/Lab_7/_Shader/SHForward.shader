Shader "Tut/Lighting/LightProbes/Lab_7/SHForward" {
	Properties {
		_Color ("Base Color", Color) =(1,1,1,1)
	}
	SubShader {
		pass{
		Tags{ "LightMode"="ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		uniform float4 _Color;

		struct vertOut{
			float4 pos:SV_POSITION;
			float4 color:COLOR;
		};
		vertOut vert(appdata_base v)
		{
			float3 worldN=mul(_Object2World,float4(v.normal,0)).xyz;
			vertOut o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.color.rgb=ShadeSH9(half4(worldN,1.0));
			o.color.a=1.0;
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			return i.color;
		}
		ENDCG
		}//end pass
	}
}
