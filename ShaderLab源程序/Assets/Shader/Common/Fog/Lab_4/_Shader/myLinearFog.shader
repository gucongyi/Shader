Shader "Tut/Effects/Lab_4/myLinearFog" {
	Properties {
		_Color ("Base Color", color) =(1,1,1,1)
		_Density("Density",Range(0,10))=1
		_Radius("Steam Range",float)=1
	}
	SubShader {
		Tags{"Queue"="Transparent+10"}
		Fog{Mode off}
		pass{

		Tags{ "LightMode"="ForwardBase"}
		Blend SrcAlpha One
		//Blend One One
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile_fwdbase
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		float4 _Color;
		float _Density;
		float _Radius;

		struct vertOut{
			float4 pos:SV_POSITION;
			float2 depth : TEXCOORD0;
			float4 ori:TEXCOORD1;
			float4 posV:TEXCOORD2;
		};
		vertOut vert(appdata_base v)
		{
			vertOut o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.depth=o.pos.zw;
			//steam
			o.ori=mul(UNITY_MATRIX_MV,float4(0,0,0,v.vertex.w));
			o.posV=mul(UNITY_MATRIX_MV,v.vertex);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
				//float d=i.depth.x/i.depth.y;
				float dist=distance(i.ori.xy,i.posV.xy);
					//density=smoothstep(0,1,density);
			    float4 c=_Density*(1-dist/_Radius)*_Color;//(1-Linear01Depth(d))*100*_Color;
			    return c;
		}
		ENDCG
		}//end pass
	}
}

