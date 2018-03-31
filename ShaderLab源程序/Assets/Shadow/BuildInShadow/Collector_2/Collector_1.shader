Shader "Tut/Shadow/BuildInShadow/Collector_1" {
Properties {
    _MainTex ("Base (RGB)", 2D) = "white" {}
}

SubShader {
	//pass to render object
		pass{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile_fwdbase fwdadd
		#include "UnityCG.cginc"
		#include "AutoLight.cginc"
		sampler2D _MainTex;
		
		struct vertOut {
			float4 pos:SV_POSITION;
			LIGHTING_COORDS(1,2)
		};
		vertOut vert(appdata_full v)
		{
			vertOut o;
			o.pos=mul(UNITY_MATRIX_MVP,v.vertex);
			TRANSFER_VERTEX_TO_FRAGMENT(o);
			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			
			fixed atten=LIGHT_ATTENUATION(i);
			float4 c=float4(1,1,1,1);
			c=c*atten;
			return c;
		}
		ENDCG
		}//endpass
   

    // Pass to render object as a shadow collector
    Pass {
       Name "ShadowCollector"
       Tags { "LightMode" = "ShadowCollector" }

       Fog {Mode Off}
       ZWrite On ZTest Less

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest
		
		#define SHADOW_COLLECTOR_PASS
		#include "UnityCG.cginc"
		
		struct v2f {
		    V2F_SHADOW_COLLECTOR;
		};
		
		v2f vert (appdata_base v)
		{
		    v2f o;
		    TRANSFER_SHADOW_COLLECTOR(o)
		    return o;
		}
		
		half4 frag (v2f i) : COLOR
		{
		    SHADOW_COLLECTOR_FRAGMENT(i)
		}
		ENDCG
    }//endpass
	}
}

