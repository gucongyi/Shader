Shader "Tut/Project/Projector_4" {
  Properties {
     _MainTex ("Cookie", 2D) = "" { TexGen ObjectLinear }
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
		float4x4 _ProjectorClip;
		struct v2f {
			float4 pos:SV_POSITION;
			float4 texc:TEXCOORD0;
		};
		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.texc=mul(_ProjectorClip,v.vertex);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=tex2Dproj(_MainTex,i.texc);
			return c;
		}
		ENDCG
	}//endpass
  }
}
