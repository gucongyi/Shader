Shader "Tut/Project/Projector_5" {
  Properties {
     _MainTex ("Cookie", 2D) = "" { TexGen ObjectLinear }
	 _FalloffTex("Falloff Tex",2D)="white"{TexGen ObjectLinear }
  }
  Subshader {
     pass {
        ZWrite off
		//Cull front
        //Blend DstColor One
		Offset -1, -1
       CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		sampler2D _FalloffTex;
		float4x4 _Projector;
		float4x4 _ProjectorClip;
		struct v2f {
			float4 pos:SV_POSITION;
			float4 texc:TEXCOORD0;
			float4 texc2:TEXCOORD1;
		};
		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.texc=mul(_Projector,v.vertex);
			o.texc2=mul(_ProjectorClip,v.vertex);
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=tex2Dproj(_MainTex,i.texc);
			float c2=tex2Dproj(_FalloffTex,i.texc2).a;
			return c*c2;
		}
		ENDCG
	}//endpass
  }
}
