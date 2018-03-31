Shader "Tut/Unity_wiki/ShadowVolume/Extrusion_2.2" {
Properties {
	_Extrusion ("Extrusion", Range(0,30)) = 5.0
}

CGINCLUDE

	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"

	float _Extrusion;
	float4 _LightPosition;

	float4 vert( appdata_base v ) : POSITION {
	
		float4 objLightPos = mul( _LightPosition, UNITY_MATRIX_IT_MV );
	
		float3 toLight = normalize(objLightPos.xyz - v.vertex.xyz * objLightPos.w);
	
		float backFactor = dot( toLight, v.normal );
	
		float extrude = (backFactor < 0.0) ? 1.0 : 0.0;
		v.vertex.xyz -= toLight * (extrude * _Extrusion);
		return mul( UNITY_MATRIX_MVP, v.vertex );
	}
	float4 frag(float4 pos:POSITION):COLOR
	{
		return float4(1,1,1,1);
	}
ENDCG


SubShader {
	Tags { "Queue" = "Transparent+10" }
	
	ZWrite Off
	ColorMask R
	Offset 1,1

	Pass {
		Cull Front
		Blend DstColor One
		
		CGPROGRAM
		ENDCG
	
		SetTexture[_MainTex] { constantColor(1,1,1,1) combine constant }		
	}
} 

FallBack Off
}
