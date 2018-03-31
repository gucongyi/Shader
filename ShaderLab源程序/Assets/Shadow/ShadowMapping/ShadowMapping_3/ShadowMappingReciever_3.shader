Shader "Tut/Shadow/ShadowMapping/ShadowMappingReciever_3" {

	SubShader {
		Tags { "RenderType"="Opaque" }
		pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		sampler2D _myShadow;
		float4x4 _myShadowProj;

		struct vertOut {
			float4 pos:SV_POSITION;
			float4 texc:TEXCOORD0;
		};
		vertOut vert(appdata_base v)
		{
			float4x4 proj;
			proj=mul(_myShadowProj,_Object2World);
			vertOut o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.texc=mul(proj,v.vertex);
			//o.pos=mul(projM,v.vertex);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			float4 c=tex2Dproj(_myShadow,i.texc);
			return c;
		}
		ENDCG
		}//endpass
	} 
	FallBack Off
}
