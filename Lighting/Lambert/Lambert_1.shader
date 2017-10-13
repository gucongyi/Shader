Shader "Tut/NewBie/Lambert_1" {
	Properties {
		_MainTex("MainTex",2D)="white"{}
	}
	SubShader {
		pass{
		Tags{"LightMode"="ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		float4 _LightColor0;
		sampler2D _MainTex;
		float4 _MainTex_ST;//SamplerTexture��ʾST
		struct v2f {
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
			float3 lightDir:TEXCOORD1;
			float3 normal:TEXCOORD2;
		};

		v2f vert (appdata_full v) {
			v2f o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.uv=TRANSFORM_TEX(v.texcoord,_MainTex);
			//o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;//xy��ʾtiling,zw��ʾoffset
			
			o.lightDir=ObjSpaceLightDir(v.vertex);//��������ǰ����Ⱦ�С�����һ��ģ�Ϳռ��еĶ���λ�ã�����ģ�Ϳռ��дӸõ㵽��Դ�Ĺ��շ���û�б���һ��.
			o.normal=v.normal;
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			i.lightDir=normalize(i.lightDir);
			i.normal=normalize(i.normal);

			float4 c=tex2D(_MainTex,i.uv);

			float diff=max(0,dot(i.normal,i.lightDir));//cosAngle������뷨�߼нǣ��Ƕ�ԽС����

			c=c*_LightColor0*(diff);
			return c*2;
		}
		ENDCG
		}
	} 
	FallBack "Diffuse"
}
