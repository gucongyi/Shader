Shader "Tut/Lab_Zero/ProJ_MVP1" {
		Properties {
		_vert("In Vertex",range(0,1))=0
		_frag("In Fragment",range(0,1))=0
		_Scal("scale",range(1,2))=1
	}
	SubShader {
		pass{
	//Tags{"LightMode"="Vertex"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		float _vert,_frag,_P,_Scal;
		uniform float3 viewPos;
		struct v2f {
			float4 pos:SV_POSITION;
			//float4 pjPos:TEXCOORD0;
			float3 c:TEXCOORD1;
		};
		v2f vert (appdata_full v) {
			v2f o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			//o.pjPos=mul(UNITY_MATRIX_P,float4(viewPos,0));
			o.c=float3(0,0,0);
			o.c.x=o.pos.y;
			o.c.y=o.pos.y/o.pos.w;
			//o.c.z=o.pos.y;
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			return i.c.x*_vert+i.c.y*_frag;
		}
		ENDCG
		}//end Forward Base
	} 
}
