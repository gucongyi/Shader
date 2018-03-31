Shader "Tut/Lighting/VertexLit/Indicator/unity_LightPosition_3" {
	Properties {
		_Color ("Base Color", Color) =(1,1,1,1)
	}
	SubShader {
		pass{
		Tags{ "LightMode"="Vertex"}
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
			//unity_LightPosition in viewSpace,ie,the camera space
			float3 viewpos = mul (UNITY_MATRIX_MV, v.vertex).xyz;
			float3 viewN = mul ((float3x3)UNITY_MATRIX_IT_MV, v.normal);
			float3 lightColor= UNITY_LIGHTMODEL_AMBIENT.xyz;

			float3 toLight = unity_LightPosition[3].xyz - viewpos.xyz * unity_LightPosition[3].w;
			float lengthSq = dot(toLight, toLight);
			float atten = 4.0 / (1.0 + lengthSq * unity_LightAtten[3].z);
			float diff = max (0, dot (viewN, normalize(toLight)));
			lightColor += unity_LightColor[3].rgb * (diff * atten);
		
			vertOut o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.color=float4(lightColor,1)*_Color;
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
