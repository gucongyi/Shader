Shader "Tut/Project/ProjS_2" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		pass{
		Tags { "LightMode"="ForwardBase" }
		Material{Diffuse(0,0,0,1)}
		}//endpass
		pass{
		Tags { "LightMode"="ForwardAdd" }
		Blend One One
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		sampler2D _MainTex;
		//float4x4 projM1;

		struct v2f {
			float4 pos:SV_POSITION;
			float4 texc:TEXCOORD0;
			float vc:TEXCOORD1;
		};
		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.texc=ComputeScreenPos(o.pos);
			float3 litDir=ObjSpaceLightDir(v.vertex);
			o.vc=max(0,dot(v.normal,normalize(litDir)));
			return o;
		}
		float4 frag(v2f i):COLOR
		{
			float4 c=tex2Dproj(_MainTex,UNITY_PROJ_COORD(i.texc));
			return c*i.vc;
		}
		ENDCG
		}//endpass
	} 
	//FallBack "Diffuse"
}
