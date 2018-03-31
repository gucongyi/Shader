Shader "Tut/Shadow/BuildIn/Werid/SurfCaster_3" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_v("Alter Value",range(0,40))=1
}

// 2/3 texture stage GPUs
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 100
	
	CGPROGRAM
	#pragma surface surf SurfCaster_3 
	half4 LightingSurfCaster_3 (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
	
			half4 c;
			c.rgb =float3(atten,atten, atten);
			c.a = atten;
			return c;
      }
      
      half4 LightingSurfCaster_3_PrePass (SurfaceOutput s, half4 light) {
            half4 c;
            c.rgb = s.Albedo * light.a;

            //c.b=(1-light.a)+c.b;
            c.a = s.Alpha;
            return c;
      }

      struct Input {
          float2 uv_MainTex;
      };
      sampler2D _MainTex;
      void surf (Input IN, inout SurfaceOutput o) {
          o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
      }
      ENDCG
		//
		pass{
		//Tags { "LightMode" = "PrePassBase" }
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile_fwdbase
		#include "UnityCG.cginc"
		#include "AutoLight.cginc"
		sampler2D _MainTex;
		
		struct vertOut {
			float4 pos:SV_POSITION;
			LIGHTING_COORDS(0,1)
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
			return atten;
		}
		ENDCG
		}//endpass

		pass{
		//Tags { "LightMode" = "PrePassFinal" }
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
		Name "ShadowCaster"
		Tags { "LightMode" = "ShadowCaster" }
		
		Fog {Mode Off}
		ZWrite On ZTest LEqual Cull Off
		Offset 1, 1

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile_shadowcaster
		#pragma fragmentoption ARB_precision_hint_fastest
		#include "UnityCG.cginc"
		
		float _v;
		struct v2f { 
		    //V2F_SHADOW_CASTER;
		    float4 pos : SV_POSITION; 
		    float4 hpos : TEXCOORD1;
		    float3 vec : TEXCOORD0;
		};
		
		v2f vert( appdata_base v )
		{
		    v2f o;
		    //TRANSFER_SHADOW_CASTER(o)
		    float4 vPos=v.vertex;
		    o.vec = mul( _Object2World, vPos).xyz- (_LightPositionRange.xyz);
		    o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		    //
		    o.pos.z += unity_LightShadowBias.x; 
		    //float clamped = max(o.pos.z, 0.0);
		    float clamped = max(o.pos.z, -o.pos.w);
		    o.pos.z = lerp(o.pos.z, clamped, unity_LightShadowBias.y); 
		    o.hpos = o.pos;
		    return o;
		}
		
		float4 frag( v2f i ) : COLOR
		{
		    //SHADOW_CASTER_FRAGMENT(i)
		    float3 s=i.vec;
		    s.x*=_v;
		    //s.z*=_v;
		    return EncodeFloatRGBA(length(s)*(_LightPositionRange.w));//.........................
		}
		ENDCG

	}
	
	// Pass to render object as a shadow collector
	Pass {
		Name "ShadowCollector"
		Tags { "LightMode" = "ShadowCollector" }
		//Tags { "LightMode" = "PrePassBase" }
		Fog {Mode Off}
		ZWrite On ZTest Always

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest
		#pragma multi_compile_shadowcollector
		
		#define SHADOW_COLLECTOR_PASS
		#include "UnityCG.cginc"
		#include "AutoLight.cginc"
		struct appdata {
			float4 vertex : POSITION;
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
		
		fixed4 frag (v2f i) : COLOR
		{
			//return 0.5;
			SHADOW_COLLECTOR_FRAGMENT(i)
		}
		ENDCG

	}
}
	//Fallback "Diffuse"
}
