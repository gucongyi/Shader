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
		float4 _MainTex_ST;//SamplerTexture表示ST
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
			//o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;//xy表示tiling,zw表示offset
			
			o.lightDir=ObjSpaceLightDir(v.vertex);//仅可用于前向渲染中。输入一个模型空间中的顶点位置，返回模型空间中从该点到光源的光照方向。没有被归一化.
			o.normal=v.normal;
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			i.lightDir=normalize(i.lightDir);
			i.normal=normalize(i.normal);

			float4 c=tex2D(_MainTex,i.uv);

			float diff=max(0,dot(i.normal,i.lightDir));//cosAngle入射光与法线夹角，角度越小月亮

			c=c*_LightColor0*(diff);
			return c*2;
		}
		ENDCG
		}
	} 
	FallBack "Diffuse"
}
