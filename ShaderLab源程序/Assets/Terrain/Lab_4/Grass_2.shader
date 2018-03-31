Shader "Hidden/TerrainEngine/Details/BillboardWavingDoublePass" {
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
			"RenderType"="GrassBillboard"
		}
		Cull Off
		LOD 200
		ColorMask RGB
				
	CGPROGRAM
	#pragma surface surf Lambert vertex:MyVert addshadow
	#pragma exclude_renderers flash
			
	sampler2D _MainTex;
	fixed _Cutoff;

	struct Input {
		float2 uv_MainTex;
		fixed4 color : COLOR;
	};
	uniform fixed4 _WavingTint;
	uniform float4 _WaveAndDistance;
	uniform float4 _CameraPosition;	
	uniform float3 _CameraRight, _CameraUp;

	void TerrainBillboardGrass( inout float4 pos, float2 offset )
	{
		float3 grasspos = pos.xyz - _CameraPosition.xyz;
		if (dot(grasspos, grasspos) > _WaveAndDistance.w)
			offset = 0.0;
		pos.xyz += offset.x * _CameraRight.xyz;
		pos.xyz += offset.y * _CameraUp.xyz;
	}
	void MyVert (inout appdata_full v)
	{
		TerrainBillboardGrass (v.vertex, v.tangent.xy);
		// wave amount defined by the grass height
		float waveAmount = pow(v.color.a*0.4,3) * _WaveAndDistance.z;
		v.vertex.x=v.vertex.x+_SinTime.w*(_WaveAndDistance.x+1)*waveAmount;
		v.vertex.y-=0.6;
	}
	void surf (Input IN, inout SurfaceOutput o) {
		fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * IN.color;
		o.Albedo = c.rgb;
		o.Alpha = c.a;
		clip (o.Alpha - _Cutoff);
		o.Alpha *= IN.color.a;
	}
	ENDCG			
	}
	Fallback Off
}
