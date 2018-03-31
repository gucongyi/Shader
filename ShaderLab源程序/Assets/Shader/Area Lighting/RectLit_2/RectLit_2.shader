Shader "Tut/Shader/Area Lighting/RectLit_2" {
	Properties{
		lh("Height of Line light",range(0,4))=1
		lw("Width of Line light",range(0,4))=1
		li("Intensity of Light",range(0,20))=1
	}
	SubShader {
		pass{
		//Tags{ "LightMode"="ForwardBase"}
		ZWrite Off 
		ZTest LEqual
		//Offset 0,-1����ʹBlend One One�����ɹ����
		//��Ϊ�˶������ļ��㣬ʵ�������ڳ��������ͬһ��λ�ô������¼����
		Offset 0,-1
		Blend One One
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		//#pragma multi_compile_fwdbase
		#pragma target 3.0
		#include "UnityCG.cginc"

		struct v2f{
			float4 pos:SV_POSITION;
			float3 wN:TEXCOORD0;
			//float3 litDir:TEXCOORD1;
			float4 wP:TEXCOORD1;
		};
		float4 litP;//pos of area obj
		float4 litN;
		float4 litT;
		float4 litR;
		float lh;
		float lw;
		float li;
		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.wN=mul(_Object2World,float4(SCALED_NORMAL,0)).xyz;
			o.wP=mul(_Object2World,v.vertex);
			//float4 wP=mul(_Object2World,v.vertex);
			//o.litDir=litP.xyz-wP.xyz/wP.w;
			return o;
		}
		float3 GetNearest(float d1,float d2,float d3,float d4,float3 dr1,float3 dr2,float3 dr3,float3 dr4)
		{
			float3 dr=0;
			if(d1<d2)
			{
				if(d1<d4)
					{dr=dr1;
					//dr=float3(0,0,1);
					}
				else
					{dr=dr4;
					//dr=float3(0,1,1);
					}
			}
			else
			{
				if(d2<d3)
					{dr=dr2;
					//dr=float3(1,1,0);
					}
				else
					{dr=dr3;
					//dr=float3(0.5,0.5,0.5);
					}
			}
			return dr;
		}
		float4 frag(v2f i):COLOR
		{
			float3 litDir=litP.xyz-i.wP.xyz/i.wP.w;//

			float3 litDir1=litDir-litT.xyz*lh-litR.xyz*lw;//1
			float3 litDir2=litDir-litT.xyz*lh+litR.xyz*lw;//2
			float3 litDir3=litDir+litT.xyz*lh+litR.xyz*lw;//3
			float3 litDir4=litDir+litT.xyz*lh-litR.xyz*lw;//4

			float diff=0;
			float att=1;
			float3 dr=0;
			float diffN=0;

			float len1=length(litDir1);
			float len2=length(litDir2);
			float len3=length(litDir3);
			float len4=length(litDir4);

			float lenw=abs(len1*len1-len2*len2)-4*lw*lw;//�����ж� �Ƿ��� ��Դ��ˮƽ �ڲ�
			float lenh=abs(len2*len2-len3*len3)-4*lh*lh;//�����ж� �Ƿ��� ��Դ�Ĵ�ֱ �ڲ�
			if(lenw<0&&lenh<0)//���������Դ��������
			{
				//float dist=abs(dot(litDir,litN));
				float dist=dot(litDir,litN);
				dr=dist*litN;
			}else if(lenw<0)//���������Դ��ˮƽ������
			{
				if(len2<len3)
					dr=litDir2;
				else
					dr=litDir3;
				float dt=abs(dot(normalize(dr),litR.xyz));
				float3 hor=dt*length(dr)*litR.xyz;
				float3 Rdir=dr-hor;//��ֱ����
				dr=Rdir;
			}else if(lenh<0)//���������Դ�Ĵ�ֱ������
			{
				if(len3<len4)
					dr=litDir3;
				else
					dr=litDir4;
				float dt=abs(dot(normalize(dr),litT.xyz));
				float3 hor=dt*length(dr)*litT.xyz;
				float3 Tdir=dr-hor;//��ֱ����
				dr=Tdir;
			}else //���������Դ�Ľ�����
			{
				dr=GetNearest(len1,len2,len3,len4,litDir1,litDir2,litDir3,litDir4);//�жϵƹ⴦���ĸ�����
			}
				diffN=abs(dot(litN,normalize(dr)));
				//diff=max(0,dot(normalize(i.wN),normalize(dr))); // diffuse version 1
				diff=dot(normalize(i.wN),normalize(dr));// diffuse version 2
				diff=(diff+0.7)/1.7;
				diff=diff*diffN;

				att=1/(1+length(dr));
				att=att*att;
			float c= li*diff*att;
			//
			return c;
		}
		ENDCG
		}//end pass
	}
}
