Shader "Tut/ImageEffects/Tap_1" {
Properties {
	_MainTex ("", 2D) = "white" {}
}
Subshader { 
	Pass {
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"
	struct v2f {
		float4 pos : POSITION;
		float4 uv[4] : TEXCOORD0;
	};
	float4 _MainTex_TexelSize;
	v2f vert (appdata_img v)
	{
		v2f o;
		o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
		float4 uv;
		uv.xy = MultiplyUV (UNITY_MATRIX_TEXTURE0, v.texcoord);
		uv.zw = 0;
		float offX = _MainTex_TexelSize.x;
		float offY = _MainTex_TexelSize.y;

		o.uv[0] = uv + float4(-offX,-offY,0,1);
		o.uv[1] = uv + float4( offX,-offY,0,1);
		o.uv[2] = uv + float4( offX, offY,0,1);
		o.uv[3] = uv + float4(-offX, offY,0,1);
		return o;
	}
	sampler2D _MainTex;
	fixed4 frag( v2f i ) : COLOR
	{
		fixed4 c;
		c  = tex2D( _MainTex, i.uv[0].xy );
		c += tex2D( _MainTex, i.uv[1].xy );
		c += tex2D( _MainTex, i.uv[2].xy );
		c += tex2D( _MainTex, i.uv[3].xy );
		c /= 4;
		return c;
	}
	ENDCG
	}
	}
Fallback off
}
