Shader "Tut/Shader/Bumpy/Bump_2" {
	Properties {
		_BumpMap("BumpMap",2D)="white"{}
	}
	SubShader {
		pass{
		Tags{"LightMode"="ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		float4 _LightColor0;
		sampler2D _BumpMap;

		struct v2f {
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
			float3 lightDir:TEXCOORD1;
			float3 tangent:TEXCOORD2;
			float3 binormal:TEXCOORD3;
			float3 normal:TEXCOORD4;
		};

		v2f vert (appdata_full v) {
			v2f o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.uv=v.texcoord.xy;
			o.tangent=v.tangent.xyz;
			o.binormal=cross(v.normal,v.tangent)*v.tangent.w;
			o.normal=v.normal;
			o.lightDir= mul(_World2Object, _WorldSpaceLightPos0).xyz;//Direction Light
			//o.lightDir=mul(rotation,o.lightDir);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=1;
			float3x3 rotation=float3x3(i.tangent.xyz,i.binormal,i.normal);
			float4 packedN=tex2D(_BumpMap,i.uv);
			float3 N=float3(2.0*packedN.wy-1,1.0);
			N.z=sqrt(1-N.x*N.x-N.y*N.y);
			N=normalize(mul(N,rotation));
			float diff=max(0,dot(N,i.lightDir));
			c=_LightColor0*diff;
			return c*2;
		}
		ENDCG
		}
	} 
	FallBack "Diffuse"
}
