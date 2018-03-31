Shader "Tut/Shader/Common/_DisplayZ_ztest" {
	SubShader {
		pass{
		Zwrite Off
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		sampler2D _CameraDepthTexture;

		struct v2f {
			float4 pos:SV_POSITION;
			float2 uv:TEXCOORD0;
		};
		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.uv=v.texcoord;
			return o;
		}
		half4 frag(v2f i):COLOR
		{
			float d=tex2D(_CameraDepthTexture,i.uv).r;
			d=Linear01Depth(d);
			return d;
		}
		ENDCG
		}
	} 
	FallBack Off
}
