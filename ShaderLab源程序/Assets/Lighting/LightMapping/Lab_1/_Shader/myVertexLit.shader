Shader "Tut/Lighting/LightMapping/Lab_1/myVertexLit" {
	Properties {
		_MainTex("MainTexture",2d)="white"{}
		_Color ("Base Color", Color) =(1,1,1,1)
	}
	SubShader {
		pass{
		Tags{ "LightMode"="Vertex"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		uniform float4 _Color;

		struct vertOut{
			float4 pos:SV_POSITION;
			float4 color:COLOR;
		};
		vertOut vert(appdata_base v)
		{
			
			float3 c=ShadeVertexLights(v.vertex,v.normal);
			vertOut o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.color=_Color*float4(c,1);
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
