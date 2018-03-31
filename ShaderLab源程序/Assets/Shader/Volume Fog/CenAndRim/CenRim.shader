Shader "Tut/Shader/Volume_Fog/CenRim" {
	Properties {
		kc("Factor to center",range(0,30))=1
		kf("Factor of Fog",range(0,30))=1
	}
	SubShader {
		Tags {  "Queue"="Geometry+600"}
	   pass {
	   Tags{"LightMode"="ForwardBase"}
	   Blend One OneMinusSrcColor
		ZWrite Off
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		struct v2f {
			float4 pos : POSITION;
			float4 scr:TEXCOORD1;
			float4 cen:TEXCOORD2;
			float4 vp:TEXCOORD3;
			float rim:TEXCOORD4;
		};

		sampler2D MainTex;
		float kf;
		float kc;
		v2f vert (appdata_full v) {
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.scr=o.pos;
			float4 cen= mul(UNITY_MATRIX_MVP, float4(0,0,0,1));//
			float4 vp=mul(UNITY_MATRIX_MVP, v.vertex);
			o.cen=cen;
			o.vp=vp;
			//�����Ǽ���rim��Ե����
			float3 viewDir=ObjSpaceViewDir(v.vertex);
			viewDir=normalize(viewDir);
			o.rim=max(0,dot(viewDir,v.normal));
			return o;  
		}

		sampler2D _CameraDepthTexture;
		float4 frag (v2f i) : COLOR {

			//�����Ǽ��㵽�������ĵ�˥��
			float3 cen=i.cen.xyz/i.cen.w;
			float3 vp=i.vp.xyz/i.vp.w;
			cen=vp-cen;
			float dc=1-length(cen);
			dc=pow(dc,6);
			dc=dc*kc;

			float4 scr=ComputeScreenPos(i.scr);
			scr.xy/=scr.w;
			float hd=scr.z/scr.w;
			hd=Linear01Depth(hd);

			float d=tex2D(_CameraDepthTexture,scr.xy).r;// ȡ����Ļ�ϵ����ص��Z���
			d=Linear01Depth(d);
			float dif=d-hd;//����Z��Ȳ�
			dif=dif*kf;//����FogŨ��
			dc=dc/(1+dc);//��֤dcС��1
			dif=dif*dc;//dc Ӧ�õ�Fog�������ĵ�˥��
			dif=dif*i.rim;//rim Ӧ�ñ�Ե˥����������Ե
			float4 c=1;
			c=lerp(0,0.5,dif);
			return c;
		} 
		  ENDCG
	  }//pass
	} 
	FallBack Off
}
