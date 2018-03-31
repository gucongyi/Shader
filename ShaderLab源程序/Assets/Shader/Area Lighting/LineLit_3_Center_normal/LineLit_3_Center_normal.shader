Shader "Tut/Lighting/AreaLit/LineLit_3_Center_normal" {
	Properties{
		lh("Height of Line light",range(0,4))=1
		li("Intensity of Light",range(0,20))=1
	}
	SubShader {
		pass{
		Tags{ "LightMode"="ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile_fwdbase
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
		float lh;
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
		float4 frag(v2f i):COLOR
		{
			float3 litDir=litP.xyz-i.wP.xyz/i.wP.w;//

			float3 litDir1=litP.xyz+litT.xyz*lh-i.wP.xyz/i.wP.w;//
			float3 litDir2=litP.xyz-litT.xyz*lh-i.wP.xyz/i.wP.w;//
			float len1=length(litDir1);
			float len2=length(litDir2);
			float len=abs(len1*len1-len2*len2)-4*lh*lh;//(2*lw)*(2*lw)
			//
			float diff=0;
			float att=1;
			float3 dr=0;
			//
			if(len<0)//�ж� �Ƿ��� �߶ι�Դ�� �ڲ�
			{
				//������㴹�߶� ����
				float dt=abs(dot(normalize(litDir1),litT.xyz));
				float3 horT=dt*length(litDir1)*litT.xyz;//LitDir��ͶӰ
				float hdensity=1-abs(length(horT)/lh-1);//���������ֱ�λ��
				hdensity=smoothstep(0,1,hdensity);
				li=li*(1+hdensity);
				float3 Ldir=litDir1-horT;//��ֱ����
				
				dr=Ldir;
				float diffN=abs(dot(litN,normalize(dr)));
				diff=dot(normalize(i.wN),normalize(dr)); // diffuse version 1
				diff=(diff+0.7)/1.7;// diffuse version 2
				diff=diff*diffN;

				att=1/(1+length(dr));
				att=att*att;
			}
			else//��Ȼ��ʹ��� �߶ι�Դ�� ���
				//ȡ��Դ�߶�������ĵ�
			{
				if(len1<len2)
					dr=litDir1;
				else
					dr=litDir2;

				//
				
				float diffN=abs(dot(litN,normalize(dr)));
				//diff=max(0,dot(normalize(i.wN),normalize(dr))); // diffuse version 1
				diff=dot(normalize(i.wN),normalize(dr));// diffuse version 2
				diff=(diff+0.7)/1.7;
				diff=diff*diffN;

				att=1/(1+length(dr));
				att=att*att;
			}
			float c= li*diff*att;
			//
			return c;
		}
		ENDCG
		}//end pass
	}
}
