Shader "Tut/Unity_wiki/ShadowVolume/Extrusion_2.3" {
Properties {
	_Extrusion ("Extrusion", Range(0,30)) = 5.0
}

CGINCLUDE
#pragma exclude_renderers gles
#pragma vertex vert
#include "UnityCG.cginc"

float _Extrusion;

// camera space light position
float4 _LightPosition;

float4 vert( appdata_base v ) : POSITION {
	
	// point to light vector
	float4 objLightPos = mul( _LightPosition, UNITY_MATRIX_IT_MV );
	
	float3 toLight = normalize(objLightPos.xyz - v.vertex.xyz * objLightPos.w);
	
	float backFactor = dot( toLight, v.normal );
	
	float extrude = (backFactor < 0.0) ? 1.0 : 0.0;
	v.vertex.xyz -= toLight * (extrude * _Extrusion);
	return mul( UNITY_MATRIX_MVP, v.vertex );
}

ENDCG


SubShader {
	Tags { "Queue" = "Transparent+10" }
	
	ZWrite Off
	ColorMask R
	Offset 1,1
	
	Pass {
		Cull Back
		Blend DstColor one
		
		CGPROGRAM
// Upgrade NOTE: excluded shader from OpenGL ES 2.0 because it does not contain a surface program or both vertex and fragment programs.
#pragma exclude_renderers gles
		#pragma fragment frag
		float4 frag(float4 pos:POSITION):COLOR
		{
			return float4(1,1,1,1);
		}
		ENDCG
	
		//SetTexture[_MainTex] { constantColor(1,1,1,1) combine constant }		
	}
	
	Pass {
		Cull Front
		Blend DstColor Zero
		
		CGPROGRAM
// Upgrade NOTE: excluded shader from OpenGL ES 2.0 because it does not contain a surface program or both vertex and fragment programs.
#pragma exclude_renderers gles
		#pragma fragment frag
		float4 frag(float4 pos:POSITION):COLOR
		{
			return float4(0.5,0.5,0.5,0.5);
		}
		ENDCG
	
		//SetTexture[_MainTex] { constantColor(0.5,0.5,0.5,0.5) combine constant }
		
	}
} 

FallBack Off
}
