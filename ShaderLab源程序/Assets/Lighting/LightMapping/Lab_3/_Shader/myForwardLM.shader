Shader "Tut/Lighting/LightMapping/Lab_3/myForwardLM" {
	Properties {
		_MainTex("MainTexture",2d)="white"{}
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
		 sampler2D _MainTex;
        float4 _MainTex_ST; //scale & position of _MainTex
        #ifndef LIGHTMAP_OFF
        sampler2D unity_Lightmap;//Beast lightmap
        float4 unity_LightmapST; //scale & position of Beast lightmap
		#endif
		struct vertOut{
			float4 pos:SV_POSITION;
			float4 color:COLOR;
			float3 litDir:TEXCOORD0;
			float3 worldN:TEXCOORD1;
			float2 uv:TEXCOORD2;
			#ifndef LIGHTMAP_OFF
			float2 uvLM:TEXCOORD3;
			#endif
		};
		vertOut vert(appdata_full v)
		{
			float4 worldV=mul(_Object2World,v.vertex);
			float3 worldN=mul(_Object2World,float4(SCALED_NORMAL,0)).xyz;
			float3 c=Shade4PointLights(unity_4LightPosX0,unity_4LightPosY0,unity_4LightPosZ0,unity_LightColor[0],unity_LightColor[1],unity_LightColor[2],unity_LightColor[3],unity_4LightAtten0,worldV.xyz,worldN);

			vertOut o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.litDir=WorldSpaceLightDir(v.vertex);
			o.worldN=worldN;
			o.uv=v.texcoord.xy;
			#ifndef LIGHTMAP_OFF
			o.uvLM=v.texcoord1.xy;
			#endif
			o.color=float4(c,1.0)*_Color;
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			float4 c=max(0.0,dot(i.worldN,normalize(i.litDir)))*_LightColor0*_Color;
			#ifndef LIGHTMAP_OFF
			float3 clm=tex2D(_MainTex,i.uv).rgb*DecodeLightmap(tex2D(unity_Lightmap,i.uvLM));
			c+=float4(clm,1.0);
			#endif
			return (c+i.color);
		}
		ENDCG
		}//end pass
		pass{
		Tags{ "LightMode"="ForwardAdd"}
		Blend One One
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		uniform float4 _Color;

		struct vertOut{
			float4 pos:SV_POSITION;
			float3 litDir:TEXCOORD0;
			float3 worldN:TEXCOORD1;
			float atten:TEXCOORD2;
		};
		vertOut vert(appdata_base v)
		{
			float3 worldN=mul(_Object2World,float4(SCALED_NORMAL,0)).xyz;
			vertOut o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.litDir=WorldSpaceLightDir(v.vertex);
			float dist=length(o.litDir);
			o.atten=1/(1+dist*dist*_WorldSpaceLightPos0.w);
			o.worldN=worldN;
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			float4 c=_LightColor0*_Color*max(0.0,dot(i.worldN,normalize(i.litDir)))*i.atten;
			return c;
		}
		ENDCG
		}//end pass
	}
}
