Shader "Tut/Organize/Use_MyFuncs" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		pass{
		Tags{ "LightMode"="ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "MyFuncs.cginc"
		uniform float4 _Color;
		float4 _LightColor0;
		struct vertOut{
			float4 pos:SV_POSITION;
			float4 color:COLOR;
		};
		vertOut vert(appdata_base v)
		{
			float3 n=(mul(float4(v.normal,0.0),_World2Object)).xyz;
			n=normalize(n);

			float4 lightDir;
			float4 diffColor=float4(0,0,0,0);

			float4 worldSpaceVertex=mul(_Object2World,v.vertex);
			float4 myLightPos=_WorldSpaceLightPos0;
			//ʹ���������Զ����MyFuncs.cginc�����������Դ�����Լ��ƹ��˥��
			myLightPos=DoLightDir_Atten(myLightPos,worldSpaceVertex);
			//ʹ��������MyFuncs.cginc�ж���Ľṹ������ʼ��֮
			MyLightingInfo info;
			info.vNormal=n;
			info.lightDir=myLightPos;
			info.lightColor=_LightColor0;
			//ʹ����MyFuncs.cginc�ж���ļ�����յĺ���
			diffColor=DoMyLighting(info);
			
			//
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
	FallBack "Diffuse"
}
