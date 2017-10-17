Shader "Unlit/GuideMask" {
	Properties{
		_MainTex ("Base (RGB)", 2D) = "white" { }
		_MainColor ("Main Color", Color) = (1,1,1,1)
		_PtX ("Pt X", float) = 0.5
		_PtY ("Pt Y", float) = 0.5
		_Rx ("Rx", float) = 0.2
		_Ry ("Ry", float) = 0.2
		_Radio ("Ry", float) = 0.2
		_RadiusGlow ("Radius glow", float) = 0
	}
	

    SubShader {
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Fog { Mode Off }
//		Offset -1, -1
		Blend SrcAlpha OneMinusSrcAlpha

      Pass{
      	CGPROGRAM
     	#pragma vertex vert
		#pragma fragment frag
     	#include "UnityCG.cginc"

     	float4 _MainColor;
     	float _PtX;
     	float _PtY;
     	float _Rx;
     	float _Ry;
		float _Radio;
     	float _RadiusGlow;

     	sampler2D _MainTex;
     	float4 _MainTex_ST;

     	struct appdata_t
		{
			float4 vertex : POSITION;
			float2 texcoord : TEXCOORD0;
		};

		struct v2f
		{
			float4 vertex : SV_POSITION;
			float2 texcoord : TEXCOORD0;
		};

		v2f vert (appdata_t v)
		{
			if(_Rx < 0)
				_Rx = 0;
			v2f o;
			o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
			o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
			return o;
		}


		fixed4 frag (v2f i) : COLOR{
			float x = i.texcoord.x;
			float y = i.texcoord.y;
			float alpha = 3;
			float4 col = _MainColor;
			float rx = clamp(_Rx, 0, 1);
			float ry = clamp(_Ry, 0, 1);
			float glow = _RadiusGlow;
			float dis = 0;

			if(glow < 0)
				glow = 0;

			if(ry == 0){
				dis = sqrt(pow(x - _PtX, 2) + pow((y - _PtY)*_Radio, 2));
				if(dis < rx)
					discard;
				if (dis < (rx + glow) && glow > 0) 
					alpha = col.a * (dis - rx) / glow;
				if(alpha < 2)
					col.a = alpha;
			} else {
				if(x >= (_PtX - rx) && x <= (_PtX + rx) && y >= (_PtY - ry) && y <= (_PtY + ry))
					discard;

				if(x <= (_PtX - rx) && x > (_PtX - rx - glow) && y <= (_PtY + ry) && y >= (_PtY - ry)){	// area left
					alpha = col.a * (_PtX - rx -x) / glow;
				} else if(x >= (_PtX + rx) && x < (_PtX + rx + glow) && y <= (_PtY + ry) && y >= (_PtY - ry)) {	// area right
					alpha = col.a * (x - _PtX - rx) / glow;
				} else if(y >= (_PtY + ry) && y < (_PtY + ry + glow) && x <= (_PtX + rx) && x >= (_PtX - rx)) {	// area top
					alpha = col.a * (y - _PtY - ry) / glow;
				} else if(y <= (_PtY - ry) && y > (_PtY - ry - glow) && x <= (_PtX + rx) && x >= (_PtX - rx)){		// area bottom
					alpha = col.a * (_PtY - ry - y) / glow;
				} else if(x < (_PtX - rx) && y > (_PtY + ry)){		//left-top
					float dis = sqrt(pow(_PtX - rx - x, 2) + pow(y - _PtY - ry, 2));
					if(dis < glow && glow > 0){
						alpha = col.a * dis / glow;
					}
				} else if(x >= (_PtX + rx) && y >= (_PtY + ry)){		//right-top
					float dis = sqrt(pow(x - _PtX - rx, 2) + pow(y - _PtY - ry, 2));
					if(dis < glow && glow > 0){
						alpha = col.a * dis / glow;
					}
				} else if(x >= (_PtX + rx) && y <= (_PtY - ry)){		//right-bottom
					float dis = sqrt(pow(x - _PtX - rx, 2) + pow(_PtY - ry - y, 2));
					if(dis < glow && glow > 0){
						alpha = col.a * dis / glow;
					}
				} else if(x <= (_PtX - rx) && y <= (_PtY - ry)){		//left-bottom
					float dis = sqrt(pow(_PtX - rx - x, 2) + pow(_PtY - ry - y, 2));
					if(dis < glow && glow > 0){
						alpha = col.a * dis / glow;
					}
				}

				if(alpha < 2)
					col.a = alpha;
			}
			return col;
		}

      	ENDCG
      }
    }
    Fallback "Diffuse"
}