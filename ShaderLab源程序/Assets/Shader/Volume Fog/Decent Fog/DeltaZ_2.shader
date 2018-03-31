Shader "Tut/Shader/Volume_Fog/DeltaZ_2" {
	Properties {
		MainTex ("Main Tex", 2D) = "white" {}
		kf("Factor of Fog",float)=1
		BaseC("Base Color",color)=(1,1,1,1)
	}
	SubShader {
		
		//ͨ���趨RenderType����ʹ������_CameraDepthTexture�е�Ӱ��ΪCull Back
		//Ȼ����ͨ��Cull Front���Լ���Cull Front��Cull Back��Z����Ȳ�
		//ȱ���ǣ�ֻ��ΪCull Front
		//�ؼ���_CameraDepthTexture������ʹ�õ�Replacement Shader�ʹ�Shader�ǲ���ͬ��
		//�����ܷ�����Ӧ�ȽϺ�
		Tags { "RenderType"="Opaque" "Queue"="Transparent+100"}
	   pass {
		Blend One OneMinusSrcColor
		ZWrite Off
		Cull Front
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		struct v2f {
			float4 pos : POSITION;
			float2 uv : TEXCOORD0;
			float4 scr:TEXCOORD1;
			//float rim:TEXCOORD2;
		};
		
		v2f vert (appdata_full v) {
			v2f o;
			v.vertex.xyz=v.vertex.xyz-v.normal*0.03;//
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.scr=o.pos;
			o.uv.xy = v.texcoord.xy;
			//�����Ǽ���rim��Ե����
			//float3 viewDir=ObjSpaceViewDir(v.vertex);
			//viewDir=normalize(viewDir);
			//o.rim=max(0,dot(viewDir,v.normal));
			//o.rim=smoothstep(0,1,o.rim);
			//o.rim=1-pow(o.rim,1);
			return o;  
		}

		sampler2D _CameraDepthTexture;
		sampler2D MainTex;
		float kf;
		float4 BaseC;
		float4 frag (v2f i) : COLOR {

			float4 scr=ComputeScreenPos(i.scr);
			scr.xy/=scr.w;
			float hd=scr.z/scr.w;
			hd=Linear01Depth(hd);

			float d=tex2D(_CameraDepthTexture,scr.xy).r;
			d=Linear01Depth(d);
			float dif=d-hd;//hd-d
			dif=abs(dif);//Back���Front���Z����

			//������Z���ͼ�е�Ӱ��ΪCull Back�����ڵ�������ܻ���Ϊ0������
			//��Cull Frontʱ��Ҳ���Ǵ�Pass�У����Z����Ȳ�dif�п��ܾ���ֱ��������������������Z��Ȳ�
			//�����Ҫ��������
			
			dif= dif*kf;
			return dif*BaseC;
		} 
		  ENDCG
	  }//pass
	} 
	FallBack Off
}
