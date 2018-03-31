Shader "Tut/Project/Projector_3" {
  Properties {
     _MainTex ("Cookie", 2D) = "" { }
  }
  Subshader {
     pass {
        ZWrite off
       // Blend DstColor One
		Offset -1, -1
       CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		float4x4 _Projector;
		struct vertOut {
			float4 pos:SV_POSITION;
			float4 texc:TEXCOORD0;
		};
		vertOut vert(appdata_base v)
		{
			vertOut o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.texc=mul(_Projector,v.vertex);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			float4 c=tex2Dproj(_MainTex,i.texc);
			return c*step(0,i.texc.w);
		}
		ENDCG
	}//endpass
  }
}
