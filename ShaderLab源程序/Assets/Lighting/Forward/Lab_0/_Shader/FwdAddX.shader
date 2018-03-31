Shader "Tut/Lighting/Forward/Lab_0/FwdAddX" {

	SubShader {
		pass{
		Tags{ "LightMode"="ForwardAdd"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		//#pragma multi_compile_fwdadd
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		struct vertOut{
			float4 pos:SV_POSITION;
			float4 color:COLOR;
		};
		vertOut vert(appdata_base v)
		{
			vertOut o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.color=float4(1,0,0,1);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			return i.color;
		}
		ENDCG
		}//end pass
	}
}
