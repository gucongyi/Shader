Shader "Tut/SurfaceShader/Deferred/LitTexPoint" {
   SubShader {
      Pass {    
         Tags { "LightMode" = "ForwardBase" }
         CGPROGRAM
         #pragma vertex vert  
         #pragma fragment frag 
		 #include "UnityCG.cginc"
         struct v2f {
            float4 pos : SV_POSITION;
         };
          v2f vert(appdata_base v) 
         {
            v2f o;
            o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
            return o;
         }
         float4 frag(v2f input) : COLOR
         {
           return 1;
         }
          ENDCG
      }
	  Pass {    
         Tags { "LightMode" = "ForwardAdd" } 
         Blend One Zero
          CGPROGRAM
		 #pragma vertex vert  
         #pragma fragment frag 
		 #include "UnityCG.cginc"
		 #include "Lighting.cginc"
		 #include "Autolight.cginc"
		  float4x4 _LightMatrix0;
		  samplerCUBE _LightTexture0;
         struct v2f {
            float4 pos : SV_POSITION;
            float3 objN : TEXCOORD0;
         };
         v2f vert(appdata_base v) 
         {
            v2f o;
            o.objN =v.normal;
            o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
            return o;
         }
          float4 frag(v2f input) : COLOR
         {
		 float4 c=1;
			c = texCUBE(_LightTexture0,input.objN);
            return c;
         }
 
         ENDCG
      }
	  }
	FallBack Off
}
