Shader "Tut/Shader/Common/TexGen_1.vf" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		pass{
		Tags{"LightMode"="Vertex"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		sampler2D _MainTex;

		struct v2f {
			float4 pos:SV_POSITION;
			float4 uv:TEXCOORD0;
			float3 vc:TEXCOORD1;
		};
		v2f vert (appdata_full v) {
			v2f o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.uv=v.vertex;
			o.uv.w/=2;
			o.vc=ShadeVertexLights(v.vertex,v.normal);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=tex2Dproj(_MainTex,i.uv);
			c.xyz*=i.vc;
			return c*2;
		}
		ENDCG
		}//end Forward Base
	} 

}
