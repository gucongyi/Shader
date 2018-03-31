//This shader comes from here:
//http://wiki.unity3d.com/index.php?title=Shadow_Volumes_in_Alpha
Shader "Tut/Unity_wiki/ShadowVolume/Extrusion" {
Properties {
	_Extrusion ("Extrusion", Range(0,30)) = 5.0
}
SubShader {
	Tags { "Queue" = "Transparent+10" }
	
	ZWrite Off
	ColorMask A
	Offset 1,1
	
	// Draw front faces, doubling the value in alpha channel
Pass {
	Cull Back
	Blend DstColor One
		
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"
	float _Extrusion;
	// camera space light position
	float4 _LightPosition;
	float4 vert( appdata_base v ) : POSITION {
		// point to light vector
		float4 objLightPos = mul( _LightPosition, UNITY_MATRIX_IT_MV );
		// xyz = position, w = 1 for point/spot lights
		// xyz = direction, w = 0 for directional lights
		float3 toLight = normalize(objLightPos.xyz - v.vertex.xyz * objLightPos.w);
	
		// dot with normal
		float backFactor = dot( toLight, v.normal );
	
		float extrude = (backFactor < 0.0) ? 1.0 : 0.0;
		v.vertex.xyz -= toLight * (extrude * _Extrusion);
		v.vertex.xyz+=v.normal*0.001;
		return mul( UNITY_MATRIX_MVP, v.vertex );
	}
	float4 frag(float4 pos:POSITION):COLOR
	{
		return float4(1,1,1,1);
	}
		ENDCG
	}
	
	// Draw back faces, halving the value in alpha channel
Pass {
	Cull Front
	Blend DstColor Zero
		
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"

	float _Extrusion;
	// camera space light position
	float4 _LightPosition;
	float4 vert( appdata_base v ) : POSITION {
	
		// point to light vector
		float4 objLightPos = mul( _LightPosition, UNITY_MATRIX_IT_MV );
		// xyz = position, w = 1 for point/spot lights
		// xyz = direction, w = 0 for directional lights
		float3 toLight = normalize(objLightPos.xyz - v.vertex.xyz * objLightPos.w);
		// dot with normal
		float backFactor = dot( toLight, v.normal );
	
		float extrude = (backFactor < 0.0) ? 1.0 : 0.0;
		v.vertex.xyz -= toLight * (extrude * _Extrusion);
		v.vertex.xyz+=v.normal*0.001;
		return mul( UNITY_MATRIX_MVP, v.vertex );
	}
	float4 frag(float4 pos:POSITION):COLOR
	{
		return float4(0.5,0.5,0.5,0.5);
	}
ENDCG	
	}//end pass
} 

FallBack Off
}
