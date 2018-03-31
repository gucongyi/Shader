// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
//需要图片是无缝贴图，否则有问题，可以上下左右左上各种方向滚动。
Shader "Custom/UVAnimationMask" 
{
    Properties 
    {
        _Color ("Color", Color) = (0.5,0.5,0.5,1)
        _MaskTex ("Mask Texture", 2D) = "white" {}
        _MainTex ("Main Texture", 2D) = "white" {}
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
			Blend DstColor One        //DstColor*SrcColor+One*DstColor  所以目标颜色更亮一些
			//Blend One OneMinusSrcAlpha             //premultiplied alpha blending
			//Blend One One                          //additive
			//Blend SrcAlpha One                     //additive blending
			//Blend OneMinusDstColor One             //soft additive
			//Blend DstColor    Zero                 //multiplicative
			//Blend DstColor SrcColor                //2x multiplicative
			//Blend Zero SrcAlpha   

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
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv0 = v.texcoord0;
                return o;
            }

            float4 frag(VertexOutput i) : COLOR 
            {
                float4 detlaTime = _Time;
				float4 varMaskTex = tex2D(_MaskTex, i.uv0);
				i.uv0 += float2(_SpeedU * _Time.y, _SpeedV * _Time.y);
				i.uv0=frac(i.uv0);
                float4 varMainTex = tex2D(_MainTex, i.uv0);
                float3 finalColor = (varMainTex.rgb*varMaskTex.a);
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Mobile/Diffuse"
}
