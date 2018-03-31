Shader "Tut/Lighting/Surface/Specular/Peak_A_LitDir" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	Slope("Slope of A Peak",range(0,1))=0
	Spec01("Content of Spec",range(0,1))=1
	Diff01("Content of Diff",range(0,1))=1
	Sigma("Distribution of Guassian Spec",range(0,1))=0.5
}
SubShader {
	//����������沼������A�ַ壬ͨ��ƫ��Normal���������Ŀ�����Ȼ��ȡƽ��ֵ�������۾����ܵ��Ĺ���
	//�����Եƹⷽ��������Normal
	Tags{ "RenderType"="Opaque" "Queue"="Geometry+100"}
	pass {
	Tags{"LightMode"="ForwardBase"}
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#pragma target 3.0
	#include "UnityCG.cginc"
	struct v2f { 
		float4 pos	: POSITION;
		float2 uv	: TEXCOORD0;
		float3 wN:TEXCOORD1;
		float4 wP:TEXCOORD2;
		float3 LDir:TEXCOORD3;
		float3 VDir:TEXCOORD4;
	}; 

	sampler2D _MainTex;
	sampler2D _CameraDepthTexture;

	v2f vert (appdata_full v)
	{
		v2f o;
		o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		//����ռ��ڵĵƹⷽ�������
		o.LDir=WorldSpaceLightDir(v.vertex);
		o.VDir=WorldSpaceViewDir(v.vertex);
		//����ռ��ڵĶ���ͷ���
		o.wP=mul(_Object2World,v.vertex);
		o.wN=mul(_Object2World,float4(v.normal,0)).xyz;
		//
		return o;
	}
	float4 _LightColor0;
	float Slope;
	float Spec01,Diff01;

	float Sigma;
	//float4 _WorldSpaceLightPos0;
	float4 frag (v2f i) : COLOR
	{
		float3 N=normalize(i.wN);
		float3 V=normalize(i.VDir);
		float3 LDir=i.LDir;//ָ��ƹ��ʸ��
		float3 L=normalize(LDir);//��λ���ĵƹ�ʸ��
		float3 H=(V+L)/2;//���ڼ���߹�İ������
		//����������
		float3 N1=normalize(N+L*Slope);
		float3 N2=normalize(N-L*Slope);
		float diff1=max(0,dot(N1,normalize(L)));//������
		float diff2=max(0,dot(N2,normalize(L)));//������
		float diff=max(diff1,diff2);//ȡ������������һ�����ֵ

		//float diff=max(0,dot(N,normalize(i.LDir)));//������
		//��������Ը�˹��̬�ֱ�ĸ߹�
		float angle1=acos(dot(H,N1));
		angle1=angle1/Sigma;
		angle1=-angle1*angle1;
		float spec1=exp(angle1);

		float angle2=acos(dot(H,N2));
		angle2=angle2/Sigma;
		angle2=-angle2*angle2;
		float spec2=exp(angle2);

		float spec=max(spec1,spec2);//ȡ�߹�ֵ������һ�����ֵ
		//spec=spec2;
		float3 base=_LightColor0.rgb;
		//ʹ��Diff01��Spec01����������͸߹�ı�������Ϊ�˱��ڼ���
		base=(diff*Diff01+spec*Spec01)*base;
		float4 c=0;
		c.rgb=base;
		return c;
	}
	ENDCG
	}
	//Pass 2
	pass {
	Tags{"LightMode"="ForwardAdd"}
	Blend One One
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#pragma target 3.0
	#include "UnityCG.cginc"
	struct v2f { 
		float4 pos	: POSITION;
		float2 uv	: TEXCOORD0;
		float3 wN:TEXCOORD1;
		float4 wP:TEXCOORD2;
		float3 LDir:TEXCOORD3;
		float3 VDir:TEXCOORD4;
	}; 

	sampler2D _MainTex;
	sampler2D _CameraDepthTexture;

	v2f vert (appdata_full v)
	{
		v2f o;
		o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		//����ռ��ڵĵƹⷽ�������
		o.LDir=WorldSpaceLightDir(v.vertex);
		o.VDir=WorldSpaceViewDir(v.vertex);
		//����ռ��ڵĶ���ͷ���
		o.wP=mul(_Object2World,v.vertex);
		o.wN=mul(_Object2World,float4(v.normal,0)).xyz;
		//
		return o;
	}
	float4 _LightColor0;
	float Slope;
	float Spec01,Diff01;

	float Sigma;
	//������Դ��˥��
	float GetAtten(float3 litDir)
	{
		float att=1;
		float dist=length(litDir);
		att=1/(dist*dist+1);
		return att;
	}
	float4 frag (v2f i) : COLOR
	{
		float3 N=normalize(i.wN);
		float3 V=normalize(i.VDir);
		float3 LDir=i.LDir;//ָ��ƹ��ʸ��
		float3 L=normalize(LDir);//��λ���ĵƹ�ʸ��
		float3 H=(V+L)/2;//���ڼ���߹�İ������
		//����������
		float3 N1=normalize(N+L*Slope);
		float3 N2=normalize(N-L*Slope);
		float diff1=max(0,dot(N1,normalize(L)));//������
		float diff2=max(0,dot(N2,normalize(L)));//������
		float diff=max(diff1,diff2);

		//����˥��
		float atten=GetAtten(LDir);

		//��������Ը�˹��̬�ֱ�ĸ߹�,dot(H,N)һ������0
		float angle1=acos(dot(H,N1));
		angle1=angle1/Sigma;
		angle1=-angle1*angle1;
		float spec1=exp(angle1);

		float angle2=acos(dot(H,N2));
		angle2=angle2/Sigma;
		angle2=-angle2*angle2;
		float spec2=exp(angle2);

		float spec=max(spec1,spec2);//ȡ�߹�ֵ������һ�����ֵ

		float3 base=_LightColor0.rgb;
		//ʹ��Diff01��Spec01����������͸߹�ı�������Ϊ�˱��ڼ���
		base=(diff*Diff01+spec*Spec01)*atten*base;

		float4 c=0;
		//c=dot(N3,N);
		c.rgb=base;
		return c;
	}
	ENDCG
	}
}
Fallback "Diffuse"
}
