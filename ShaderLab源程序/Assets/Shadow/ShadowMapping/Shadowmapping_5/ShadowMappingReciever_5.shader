Shader "Tut/Shadow/ShadowMapping/ShadowMappingReciever_5" {
	SubShader {
		Tags { "RenderType"="Opaque" }
		pass{
		//Zwrite off
		//ZTest Always
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		
		sampler2D _myShadow;
		float4x4 _litMVP;
		
		struct vertOut {
			float4 pos:SV_POSITION;
			float4 litPos:TEXCOORD0;
		};
		vertOut vert(appdata_base v)
		{
			vertOut o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			float4 wVertex=mul(_Object2World ,v.vertex);
			o.litPos=mul(_litMVP,wVertex);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			float2 shadowTexc=0.5*i.litPos.xy/i.litPos.w+float2(0.5,0.5);
			//shadowTexc.y=1.0-shadowTexc.y;
			float litZ=i.litPos.z/i.litPos.w;
			float t=tex2D(_myShadow,shadowTexc).r;
			//return t;
			//float lZ= Linear01Depth(litZ);
			if(litZ<=t)
			return 0.6;
			else
			return 0.3;
		}
		ENDCG
		}//endpass
	} 
	//FallBack "Diffuse"
}
