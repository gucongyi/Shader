Shader "Tut/Shader/Volume_Fog/Cen" {
	Properties {
		MainTex ("Main Tex", 2D) = "white" {}
		kc("Factor to center",range(0,10))=1
		kf("Factor of Fog",range(0,10))=1
	}
	SubShader {
	//Tags { "RenderType"="Opaque" "Queue"="Geometry"}
		Tags {  "Queue"="Geometry+600"}
	   pass {
	   Tags{"LightMode"="ForwardBase"}
	   Blend One OneMinusSrcColor
		// Cull Front    
		ZWrite Off
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		struct v2f {
			float4 pos : POSITION;
			float2 uv : TEXCOORD0;
			float4 scr:TEXCOORD1;
			float4 cen:TEXCOORD2;//��������
			float4 vp:TEXCOORD3;//�ӿռ�Ķ���
		};

		sampler2D MainTex;
		float kf;
		float kc;
		v2f vert (appdata_full v) {
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.scr=o.pos;
			o.uv.xy = v.texcoord.xy;
			//������������ĺ��ӿռ�Ķ���
			float4 cen= mul(UNITY_MATRIX_MVP, float4(0,0,0,1));//
			float4 vp=mul(UNITY_MATRIX_MVP, v.vertex);
			o.cen=cen;
			o.vp=vp;
			return o;  
		}

		sampler2D _CameraDepthTexture;


		float4 frag (v2f i) : COLOR {

			float3 cen=i.cen.xyz/i.cen.w;
			float3 vp=i.vp.xyz/i.vp.w;
			cen=vp-cen;
			float dc=1-length(cen);
			dc=pow(dc,6);
			dc=dc*kc;
			//return dc*kf;
			float4 scr=ComputeScreenPos(i.scr);
			scr.xy/=scr.w;
			float hd=scr.z/scr.w;
			hd=Linear01Depth(hd);
			//return hd;
			

			float d=tex2D(_CameraDepthTexture,scr.xy).r;
			d=Linear01Depth(d);
			float dif=d-hd;
			dif=dif*kf;
			dc=dc/(1+dc);
			dif=dif*dc;
			float4 c=1;
			c=lerp(0,0.5,dif);
			return c;
		} 
		  ENDCG
	  }//pass
	} 
	FallBack Off
}
