Shader "Custom/ShockWave Effect"   
{  
    Properties   
    {  
        _MainTex ("Base (RGB)", 2D) = "white" {}  
		_UVOffsAndAspectScale("UVOffsAndAspectScale",Vector) = (0,0,0,0)
    }  
  
    CGINCLUDE  
    #include "UnityCG.cginc"   
	 
    uniform sampler2D _MainTex;  
    float4 _MainTex_TexelSize; 
	
	float4		_UVOffsAndAspectScale;
	float4 finalCoord;

	uniform float4 _Wave0ParamSet0[10];
	uniform float4 _Wave0ParamSet1[10];  
	uniform float _CirclrRadius[10];
	uniform float _EachFramTimeSinceGame;
  
	float Wave(float time)
	{
		float timeAtt = 1.f / (1 + time * time);
		/*if(time>radians(180))
		{
			time=radians(180);
		}*/
		return sin(time) * timeAtt;
	}

	float Impulse(float x,float k)
	{
		float h = k * x; 
    	return h * exp(1 - h);
	}

	float2 EvalWave(float4 paramsSet0,float4 paramsSet1,float2 uv)	
	{
		//DX下点击上下反向问题  
        /*#if UNITY_UV_STARTS_AT_TOP  
            paramsSet0.y = 1 - paramsSet0.y;  
        #endif  */
		float2	diff		= (uv - paramsSet0) * _UVOffsAndAspectScale.zw;
		float	dist		= length(diff);
		float	time		= max(_EachFramTimeSinceGame - paramsSet1.z - dist/ paramsSet1.y,0);		
		float	w			= Wave(time * paramsSet0.w) * paramsSet0.z;
		float	distAtt		= saturate(dist * paramsSet1.x); //范围控制paramsSet1.x=1.0f / waveMaxRadius
		//(diff / dist)单位向量
		return w * (diff / dist) * (1 - distAtt * distAtt);
	} 
  
  struct v2f {
		float4 pos : POSITION;//必须有，否则拿不到定点位置
		float2 uv : TEXCOORD0;
	};
  v2f vert( appdata_img v ) 
	{
		v2f 	o;
		float2 uv=v.vertex.xy;
		o.pos	= float4(v.vertex.xy * 2 - float2(1,1),0,1);//-1,1 屏幕的投影范围
		
		float2 wave=float2(0,0);
		for(int count=0;count<10;count++)
		{
			wave+=EvalWave(_Wave0ParamSet0[count],_Wave0ParamSet1[count],uv); 
		}
		uv+=wave;
		o.uv.xy	= uv;
		return o;
	}
    fixed4 frag(v2f i) : SV_Target  
    {  
		return tex2D(_MainTex,i.uv);
    }  
  
    ENDCG  

    SubShader   
    {  
        Pass  
        {  
            ZTest Always  
            Cull Off  
            ZWrite Off  
            Fog { Mode off }  
  
            CGPROGRAM  
			#pragma vertex vert
            #pragma fragment frag  
            #pragma fragmentoption ARB_precision_hint_fastest   
            ENDCG  
        }  
    }  
    Fallback off  
}  