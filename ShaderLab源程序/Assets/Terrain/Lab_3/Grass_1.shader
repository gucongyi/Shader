Shader "Hidden/TerrainEngine/Details/WavingDoublePass" {
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

	sampler2D _MainTex;
	fixed _Cutoff;
	uniform float4 _WaveAndDistance;
	struct Input {
		float2 uv_MainTex;
		fixed4 color : COLOR;
	};
	void MyVert (inout appdata_full v)
	{
		float waveAmount = pow(v.color.a*0.4,3) * _WaveAndDistance.z;
		v.vertex.x=v.vertex.x+_SinTime.w*(_WaveAndDistance.x+1)*waveAmount;
		v.vertex.y-=0.6;
	}
	void surf (Input IN, inout SurfaceOutput o) {
		fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * IN.color;
		//c+=float4(0.3,0,0,0);
		o.Albedo = c.rgb;
		o.Alpha = c.a;
		clip (o.Alpha - _Cutoff);
		o.Alpha *= IN.color.a;
	}
	ENDCG
	}
Fallback Off
}
