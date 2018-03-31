Shader "Tut/SurfaceShader/Deferred/Lab_5/Surf_decalBlend" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_CutOff("Cut Off",Range(0,1))=0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert exclude_path:forward decal:add
		#pragma only_renderers d3d9
		#pragma debug

		sampler2D _MainTex;
		struct Input {
			float2 uv_MainTex;
		};
		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
