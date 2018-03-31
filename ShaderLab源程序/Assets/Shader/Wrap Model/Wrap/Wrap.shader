Shader "Tut/Shader/Surface/Wrap" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	down("Down boundary",float)=0
}
SubShader {
	//����������沼������A�ַ壬ͨ��ƫ��Normal�����첻ͬ���ʸ�
	//�����Եƹⷽ��������Normal
	//Ȼ���������V�͵������N��dot(V,N)������������
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
	float down;
	float4 frag (v2f i) : COLOR
	{
		float3 N=normalize(i.wN);
		float3 V=normalize(i.VDir);
		float3 LDir=i.LDir;//ָ��ƹ��ʸ��
		float3 L=normalize(LDir);//��λ���ĵƹ�ʸ��
		float3 H=(V+L)/2;//���ڼ���߹�İ������
		//����������
		float diff=dot(N,normalize(L));//������
		float spec=max(0,dot(H,N));
		diff=(diff-down)/(1-down);//���������(-down,1)ӳ�䵽(0,1)
		diff=max(0,diff);
		spec=pow(spec,24);
		float3 base=_LightColor0.rgb;
		//base=(diff+spec)*base;
		float4 c=0;
		c.rgb=base*diff;
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
	float down;
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
		float diff=dot(N,normalize(L));//������
		float spec=max(0,dot(H,N));
		diff=(diff-down)/(1-down);//���������(-down,1)ӳ�䵽(0,1)
		diff=max(0,diff);
		spec=pow(spec,24);
		float3 base=_LightColor0.rgb;
		//base=(diff+spec)*base;
		//����˥��
		float atten=GetAtten(LDir);
		//ʹ��Diff01��Spec01����������͸߹�ı�������Ϊ�˱��ڼ���
		float4 c=0;
		c.rgb=base*diff*atten;
		return c;
	}
	ENDCG
	}
}
Fallback "Diffuse"
}
