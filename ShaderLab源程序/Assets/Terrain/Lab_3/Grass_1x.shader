Shader "Hidden/TerrainEngine/Details/WavingDoublePass_X" {
Properties {
	_WavingTint ("Fade Color", Color) = (.7,.6,.5, 0)
	_MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
	_WaveAndDistance ("Wave and distance", Vector) = (12, 3.6, 1, 1)
	_Cutoff ("Cutoff", float) = 0.5
}
SubShader {
	Tags {
		"Queue" = "Geometry+200"
		"IgnoreProjector"="True"
		"RenderType"="Grass"
	}
	Cull Off
	LOD 200
	ColorMask RGB
	CGPROGRAM
	#pragma surface surf Lambert vertex:MyVert addshadow
	#pragma exclude_renderers flash
	#include "TerrainEngine.cginc"

	sampler2D _MainTex;
	fixed _Cutoff;

	struct Input {
		float2 uv_MainTex;
		fixed4 color : COLOR;
	};
	void MyVert (inout appdata_full v)
	{
		float waveAmount = v.color.a * _WaveAndDistance.z;
		//
		float4 _waveXSize = float4(0.012, 0.02, 0.06, 0.024) * _WaveAndDistance.y;
		float4 _waveZSize = float4 (0.006, .02, 0.02, 0.05) * _WaveAndDistance.y;
		float4 waveSpeed = float4 (0.3, .5, .4, 1.2) * 4;

		float4 _waveXmove = float4(0.012, 0.02, -0.06, 0.048) * 2;
		float4 _waveZmove = float4 (0.006, .02, -0.02, 0.1);

		float4 waves;
		waves = v.vertex.x * _waveXSize;
		waves += v.vertex.z * _waveZSize;
		// Add in time to model them over time
		waves += _WaveAndDistance.x * waveSpeed;

		float4 s, c;
		waves = frac (waves);
		FastSinCos (waves, s,c);
		//sincos(waves,s,c);
		s = s * s;
		s = s * s;

		float lighting = dot (s, normalize (float4 (1,1,.4,.2))) * .7;

		s = s * waveAmount;

		float3 waveMove = float3 (0,0,0);
		waveMove.x = dot (s, _waveXmove);
		waveMove.z = dot (s, _waveZmove);

		v.vertex.xz -= waveMove.xz * _WaveAndDistance.z;
	
		// apply color animation
		fixed3 waveColor = lerp (fixed3(0.5,0.5,0.5), _WavingTint.rgb, lighting);
	
		// Fade the grass out before detail distance.
		float3 offset = v.vertex.xyz - _CameraPosition.xyz;
		v.color.a = saturate (2 * (_WaveAndDistance.w - dot (offset, offset)) * _CameraPosition.w);
		v.color=fixed4(2 * waveColor * v.color.rgb, v.color.a);
	}
	void surf (Input IN, inout SurfaceOutput o) {
		fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * IN.color;
		c+=float4(1,0,0,0);
		o.Albedo = c.rgb;
		o.Alpha = c.a;
		clip (o.Alpha - _Cutoff);
		o.Alpha *= IN.color.a;
	}
	ENDCG
	}
Fallback Off
}
