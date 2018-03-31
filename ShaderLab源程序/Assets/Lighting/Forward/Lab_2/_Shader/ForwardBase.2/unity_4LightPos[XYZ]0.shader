Shader "Tut/Lighting/Forward/Lab_2/Base.2/unity_4LightPos[XYZ]0" {

	SubShader {
		pass{
		Tags{ "LightMode"="ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile_fwdbase
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		struct vertOut{
			float4 pos:SV_POSITION;
			float4 color:COLOR;
		};
		vertOut vert(appdata_base v)
		{
			vertOut o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);

			float4 posW=mul(_Object2World,v.vertex);
			float3 normalW=mul(_Object2World,float4(v.normal,0)).xyz;
			int i=0;
			float3 lightDir=float3(unity_4LightPosX0[i],unity_4LightPosY0[i],unity_4LightPosZ0[i]);
			lightDir=lightDir-(posW).xyz;
			float dist=length(lightDir);
			float diff=max(0,dot(lightDir/dist,normalW));

			
			o.color=unity_LightColor[i]*diff;//*(1/(1+dist));
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			return i.color;
		}
		ENDCG
		}//end pass
		pass{
		Tags{ "LightMode"="ForwardAdd"}
		Blend Zero One
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		struct vertOut{
			float4 pos:SV_POSITION;
			float4 color:COLOR;
		};
		vertOut vert(appdata_base v)
		{
			vertOut o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.color=float4(1,1,1,1);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			return i.color;
		}
		ENDCG
		}//end pass
	}
}
