// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Muon/UVAnimationMask" 
{
    Properties 
    {
        _Color ("Color", Color) = (0.5,0.5,0.5,1)
        _MainTex ("Main Texture", 2D) = "white" {}
        _MaskTex ("Mask Texture", 2D) = "white" {}
        _SpeedU ("Speed U", Range(-5, 5)) = 0
        _SpeedV ("Speed V", Range(-5, 5)) = 0
    }
    SubShader 
    {
        Tags 
        {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass 
        {
            Tags 
            {
                "LightMode"="ForwardBase"
            }

            Blend One One

            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"

            #pragma multi_compile_fwdbase
            #pragma exclude_renderers d3d11_9x xbox360 xboxone ps3 ps4 psp2 

            float4 _Color;

            sampler2D _MainTex; 
            float4 _MainTex_ST;

            sampler2D _MaskTex; 
            float4 _MaskTex_ST;

            float _SpeedU;
            float _SpeedV;

            struct VertexInput 
            {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };

            struct VertexOutput 
            {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }

            float4 frag(VertexOutput i) : COLOR 
            {
                float4 detlaTime = _Time;
                float2 newUV = frac(float2((i.uv0.x + (_SpeedU * detlaTime.g)), (i.uv0.y + (_SpeedV * detlaTime.g))));
                float4 varMainTex = tex2D(_MainTex, TRANSFORM_TEX(newUV, _MainTex));
                float4 varMaskTex = tex2D(_MaskTex, TRANSFORM_TEX(i.uv0, _MaskTex));
                float3 finalColor = (_Color.rgb * varMainTex.rgb * varMaskTex.a);
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Mobile/Diffuse"
}
