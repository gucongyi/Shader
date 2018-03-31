Shader "Tut/Shadow/BuildInShadow/Collector_0" {
Properties {
    _MainTex ("Base (RGB)", 2D) = "white" {}
    //_Color("Color",color)=(1,1,1,1)
}
SubShader {
	//pass to render object
	pass{
		Tags { "LightMode" = "PrePassBase" }
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile_fwdbase
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

		pass{
		Tags { "LightMode" = "PrePassFinal" }
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile_fwdadd
		#include "UnityCG.cginc"
		#include "AutoLight.cginc"
		sampler2D _MainTex;
		
		struct vertOut {
			  float4 pos : SV_POSITION;
			  LIGHTING_COORDS(3,4)
		};
		vertOut vert(appdata_full v)
		{
			vertOut o;
		  	o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
  			TRANSFER_VERTEX_TO_FRAGMENT(o);
  			return o;
		}
		float4 frag(vertOut i):COLOR
		{
			
			fixed atten=LIGHT_ATTENUATION(i);
			float4 c=float4(0.7,0.7,0.7,0.7);
			//c=tex2D(_MainTex,i.uv);
			c=c*atten;
			return c;
		}
		ENDCG
	}
	
// Pass to render object as a shadow caster
	Pass {
		Name "Caster"
		Tags { "LightMode" = "ShadowCaster" }
		Offset 1, 1
		
		Fog {Mode Off}
		ZWrite On ZTest Less Cull Off

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile_shadowcaster
		#pragma fragmentoption ARB_precision_hint_fastest
		#include "UnityCG.cginc"
		
		struct v2f { 
			V2F_SHADOW_CASTER;
			float2  uv : TEXCOORD1;
		};
		
		
		v2f vert( appdata_base v )
		{
			v2f o;
			o.uv=v.texcoord.xy;
			TRANSFER_SHADOW_CASTER(o)
			return o;
		}
		
		float4 frag( v2f i ) : COLOR
		{
			SHADOW_CASTER_FRAGMENT(i)
		}
		ENDCG
	}
    // Pass to render object as a shadow collector
    Pass {
       Name "ShadowCollector"
       Tags { "LightMode" = "ShadowCollector" }

       Fog {Mode Off}
       ZWrite On ZTest LEqual

		CGPROGRAM
		// Upgrade NOTE: excluded shader from Xbox360; has structs without semantics (struct appdata members vertex)
		#pragma exclude_renderers xbox360
		#pragma vertex vert
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest
		#pragma multi_compile_shadowcollector
		#define SHADOW_COLLECTOR_PASS
		#include "UnityCG.cginc"
		
		struct appdata {
		    float4 vertex:POSITION;
		};
		
		struct v2f {
		    V2F_SHADOW_COLLECTOR;
		};
		
		v2f vert (appdata v)
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
	Fallback "Diffuse"
}

