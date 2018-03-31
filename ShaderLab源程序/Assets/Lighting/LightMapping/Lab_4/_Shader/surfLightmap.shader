Shader "Tut/Lighting/LightMapping/Lab_4/surfLightmap" {
   Properties {
       _MainTex ("Base (RGB)", 2D) = "white" {}
       _Dummy ("Dummy", 2D) = "white" {}
       _BumpMap ("Normalmap", 2D) = "bump" {}
       
   }
   
   SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf Lambert nolightmap
 
        sampler2D _MainTex;
        sampler2D unity_Lightmap;
        float4 unity_LightmapST;
        sampler2D _Dummy;
        sampler2D _BumpMap;     
        
        struct Input {
            float2 uv_MainTex;
            float2 uv2_Dummy;
            float2 uv_BumpMap;
        };
 
        void surf (Input IN, inout SurfaceOutput o) {
        
            fixed4 tex  = tex2D (_MainTex, IN.uv_MainTex);
            float2 lmuv = IN.uv2_Dummy.xy * unity_LightmapST.xy + unity_LightmapST.zw;
            o.Albedo    = tex.rgb * DecodeLightmap( tex2D (unity_Lightmap, lmuv) );
            o.Alpha     = tex.a;
            o.Normal    = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));     
        }
        ENDCG
    } 
    FallBack "Diffuse"
}
