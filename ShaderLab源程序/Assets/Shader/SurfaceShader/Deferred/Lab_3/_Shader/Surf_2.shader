Shader "Tut/SurfaceShader/Deferred/Lab_3/Surf_2" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_ColorTint ("Tint", Color) = (1.0, 0.6, 0.6, 1.0)
		_ExtrudeAmt("Extrude amount",Range(0,1))=0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert exclude_path:forward vertex:vert finalcolor:mycolor addshadow 
		#pragma only_renderers d3d9
		#pragma debug

		sampler2D _MainTex;
		fixed4 _ColorTint;
		float _ExtrudeAmt;

		struct Input {
			float2 uv_MainTex;
		};
		void vert (inout appdata_full v, out Input o)//Vertex
		{
			v.vertex.xyz=v.vertex.xyz+v.normal*_ExtrudeAmt;
        }
		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		void mycolor (Input IN, SurfaceOutput o, inout fixed4 color)//final color modifier
		{
			color *= _ColorTint;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
