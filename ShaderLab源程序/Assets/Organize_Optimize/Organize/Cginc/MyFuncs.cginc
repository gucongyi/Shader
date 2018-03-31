		struct MyLightingInfo{
			float3 vNormal;
			float4 lightDir;
			float4 lightColor;
		};
		float4 DoLightDir_Atten(float4 lightPos,float4 worldSpaceVertex)
		{
			float4 lightDir=float4(0,0,0,0);
			if(lightPos.w==0)//Ϊƽ�й�
			{
				lightDir.xyz=lightPos;
				lightDir.w=1.0;//ƽ�й�˥��Ϊ1.0
			}else//Point/Spot//���Դ
			{
				lightDir.xyz=(lightPos-worldSpaceVertex).xyz;
				lightDir.w=1/(1+length(lightDir.xyz));//���Դ��˥�� 
				lightDir.xyz=normalize(lightDir.xyz);
			}
			return lightDir;
		}
		float4 DoMyLighting(MyLightingInfo info)
		{
			float diff=max(0,dot(info.vNormal,info.lightDir.xyz));
			float4 c=info.lightColor*diff*info.lightDir.a;
			return c;
		}
