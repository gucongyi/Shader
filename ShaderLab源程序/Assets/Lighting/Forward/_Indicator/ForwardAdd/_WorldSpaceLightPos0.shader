Shader "Tut/Lighting/ForwardAdd/Indicator/_WorldSpaceLighPos0" {
	Properties {
		_Color ("Base Color", Color) =(1,1,1,1)
	}
	SubShader {
		pass{
		Tags{ "LightMode"="ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile_fwdbase
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		uniform float4 _Color;

		struct vertOut{
			float4 pos:SV_POSITION;
			float4 color:COLOR;
		};
		vertOut vert(appdata_base v)
		{
			vertOut o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.color=float4(0,0.5,0.5,1);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			return i.color;
		}
		ENDCG
		}//end pass
		pass{
		Tags{ "LightMode"="ForwardAdd"}
		Blend One Zero
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
			float3 n=(mul(float4(v.normal,0.0),_World2Object)).xyz;
			n=normalize(n);

			float4 lightDir;
			float dist;
			float4 diffColor=float4(0,0,0,0);
			float diff=0;
			float atten=1;

			float4 worldSpaceVertex=mul(_Object2World,v.vertex);

			//first light
			float4 lightPos=_WorldSpaceLightPos0;
			if(lightPos.w==0)//direction
			{
				lightDir=lightPos;
				atten=1.0;
			}else//Point/Spot
			{
				lightDir=lightPos-worldSpaceVertex;
				atten=1/(1+length(lightDir));
				lightDir=normalize(lightDir);
			}
			
			diff=max(0.0,dot(n,lightDir.xyz));
			diffColor=_LightColor0*_Color*diff*atten;

			vertOut o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.color=diffColor;
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
