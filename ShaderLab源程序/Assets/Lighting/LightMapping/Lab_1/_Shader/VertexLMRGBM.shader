Shader "Tut/Lighting/LightMapping/Lab_1/VertexLMRGBM" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Base Color", Color) =(1,1,1,1)
    }
SubShader {
		pass{
		Tags{ "LightMode"="Vertex"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		uniform float4 _Color;

		struct vertOut{
			float4 pos:SV_POSITION;
			float4 color:COLOR;
		};
		vertOut vert(appdata_base v)
		{
			
			float3 c=ShadeVertexLights(v.vertex,v.normal);
			vertOut o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			o.color=_Color*float4(c,1);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			return i.color;
		}
		ENDCG
		}//end pass
    Pass {
        Tags{"LightMode"="VertexLMRGBM"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
        
        sampler2D _MainTex;
        float4 _MainTex_ST;
        
        sampler2D unity_Lightmap;
        float4 unity_LightmapST;

        struct appdata {
            float4 vertex   : POSITION;
            float2 texcoord : TEXCOORD0;
            float2 texcoord1: TEXCOORD1; 
        };
        
        struct v2f {
            float4 pos  : SV_POSITION;
            float2 txuv : TEXCOORD0;
            float2 lmuv : TEXCOORD1;
        };
	        
	        v2f vert (appdata v) {
	            v2f o;
	            o.pos   = mul( UNITY_MATRIX_MVP, v.vertex );
	            o.txuv  = TRANSFORM_TEX(v.texcoord.xy,_MainTex);
	            o.lmuv  = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
	            return o;
	        }
        
        half4 frag( v2f i ) : COLOR {
           half4 col   = tex2D(_MainTex, i.txuv.xy);
            half4 lm    = tex2D(unity_Lightmap, i.lmuv.xy);
            col.rgb     = col.rgb * DecodeLightmap(lm); 
            return col;
       }
        ENDCG
        }
    }
}