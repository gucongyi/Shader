Shader "Tut/Lighting/LightMapping/Lab_1/VertexLMRGBM_1" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Base Color", Color) =(1,1,1,1)
    }
SubShader {
	
    Pass {
        Tags{"LightMode"="VertexLMRGBM"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
        
		uniform float4 _Color;
        sampler2D _MainTex;
        float4 _MainTex_ST;
        
        sampler2D unity_Lightmap;
        float4 unity_LightmapST;
 
        struct v2f {
            float4 pos  : SV_POSITION;
            float2 txuv : TEXCOORD0;
            float2 lmuv : TEXCOORD1;
			float4 color:COLOR;
        };
	        
	    v2f vert (appdata_full v) {
			float3 c=ShadeVertexLights(v.vertex,v.normal);
	        v2f o;
	        o.pos   = mul( UNITY_MATRIX_MVP, v.vertex );
	        o.txuv  = TRANSFORM_TEX(v.texcoord.xy,_MainTex);
	        o.lmuv  = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
			o.color=_Color*float4(c,1);
	        return o;
	    }
        
        half4 frag( v2f i ) : COLOR {
           half4 col   = tex2D(_MainTex, i.txuv.xy);
            half4 lm    = tex2D(unity_Lightmap, i.lmuv.xy);
            col.rgb     = col.rgb * DecodeLightmap(lm); 
            return col+i.color;
       }
        ENDCG
        }
    }
}