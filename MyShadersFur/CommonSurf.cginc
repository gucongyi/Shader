		sampler2D _MainTex;
		sampler2D _AlphaTex;
		sampler2D _NoiseTex;
		fixed4 _Color;
		fixed _MaxHairLength;
		float _HairPadding;
		

		struct Input {
			float2 uv_MainTex;
			float2 uv_AlphaTex;
			float2 uv_NoiseTex;
			float2 uv_BumpMap;
		};

		

		void vert (inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input,o);
			float4 m=tex2D(_AlphaTex,float4(v.texcoord.xy,0,0));
			v.vertex.xyz += (normalize(v.normal) * _MaxHairLength*CURRENTLAYER*_HairPadding*m.r*5);
		}	

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex)* _Color;
			fixed4 s = tex2D (_AlphaTex, IN.uv_AlphaTex);
			fixed4 n = tex2D (_NoiseTex, IN.uv_NoiseTex);
			o.Albedo = c.rgb;	
			o.Alpha = sign(s.r)*n.r;
		}


		void vertSkin (inout appdata_full v, out Input o) {
			UNITY_INITIALIZE_OUTPUT(Input,o);
		}
		void surfSkin (Input IN, inout SurfaceOutputStandardSpecular o) {
				fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
				o.Albedo = c.rgb;
				o.Alpha =c.a;
		}
