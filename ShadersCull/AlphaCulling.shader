Shader "MyShader/AlphaCulling" {
    Properties {
        __Color ("_Color", Color) = (1,1,1,1)
        __MainTexture ("_MainTexture", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }

            Blend SrcAlpha OneMinusSrcAlpha
			Lighting Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma target 3.0
            uniform float4 __Color;
            uniform sampler2D __MainTexture; 
			uniform float4 __MainTexture_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
////// Emissive:
                float4 __MainTexture_var = tex2D(__MainTexture,TRANSFORM_TEX(i.uv0, __MainTexture));
                float3 emissive = (__Color.rgb*__MainTexture_var.rgb);
                float3 finalColor = emissive;
                return fixed4(finalColor,__MainTexture_var.a);
            }
            ENDCG
        }
    }
    FallBack "Unlit/Transparent"
}
