Shader "Tut/Shader/Bumpy/Parallax_3" {
	Properties {
		_MainTex("MainTex",2D)="white"{}
		_BumpMap("BumpMap",2D)="white"{}
		_ParallaxMap("Displacement Map(A)",2D)="white"{}
		_Parallax("Displacement Amount",range(0.005,1))=0.05
	}
	SubShader {
		pass{
		Tags{"LightMode"="ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma only_renderers d3d9
		#include "UnityCG.cginc"
		float4 vert(appdata_base v):SV_POSITION
		{
			return mul(UNITY_MATRIX_MVP,v.vertex);
		}
		float4 frag(float pos):COLOR
		{
			return 0;
		}
		ENDCG
		}
		pass{
		Tags{"LightMode"="ForwardAdd"}
		Blend One One
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma only_renderers d3d9
		#include "UnityCG.cginc"

		float4 _LightColor0;
		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _ParallaxMap;
		float4 _MainTex_ST;
		float _Parallax;
		struct v2f {
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
			float3 lightDir:TEXCOORD1;
			float3 viewDir:TEXCOORD2;
			float4 posW:TEXCOORD3;
		};

		v2f vert (appdata_full v) {
			v2f o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.uv=TRANSFORM_TEX(v.texcoord,_MainTex);

			TANGENT_SPACE_ROTATION;
			o.lightDir=ObjSpaceLightDir(v.vertex);
			o.viewDir=ObjSpaceViewDir(v.vertex);
			o.lightDir=mul(rotation,o.lightDir);
			o.viewDir=mul(rotation,o.viewDir);
			o.posW=mul(_Object2World,v.vertex);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			//
			float p=tex2D(_ParallaxMap,i.uv).a;
			float2 offset = ParallaxOffset (p, _Parallax, i.viewDir);
			i.uv+=offset;
			float4 c=tex2D(_MainTex,i.uv);
			float3 N=UnpackNormal(tex2D(_BumpMap,i.uv));
			float diff=max(0,dot(N,i.lightDir));
			float atten=length(_WorldSpaceLightPos0-i.posW);
			atten=1/(1+atten*atten);
			c=c*_LightColor0*diff*atten;
			return c*2;
		}
		ENDCG
		}
	} 
	FallBack "Diffuse"
}
