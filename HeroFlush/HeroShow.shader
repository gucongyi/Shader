// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:Mobile/Diffuse,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:36758,y:31594,varname:node_3138,prsc:2|normal-3535-RGB,emission-7826-OUT,custl-1622-OUT,clip-1668-A;n:type:ShaderForge.SFN_Tex2d,id:1668,x:36285,y:32220,ptovrint:False,ptlb:Diffuse Map,ptin:_DiffuseMap,varname:node_1668,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_NormalVector,id:4300,x:32407,y:32579,prsc:2,pt:True;n:type:ShaderForge.SFN_LightVector,id:4343,x:32401,y:32227,varname:node_4343,prsc:2;n:type:ShaderForge.SFN_Dot,id:163,x:32669,y:32531,varname:node_163,prsc:2,dt:1|A-4343-OUT,B-4300-OUT;n:type:ShaderForge.SFN_Multiply,id:8658,x:33333,y:32744,varname:node_8658,prsc:2|A-6951-OUT,B-1668-RGB;n:type:ShaderForge.SFN_LightColor,id:1956,x:34156,y:32538,varname:node_1956,prsc:2;n:type:ShaderForge.SFN_Multiply,id:7496,x:33818,y:32466,varname:node_7496,prsc:2|A-7946-RGB,B-8658-OUT;n:type:ShaderForge.SFN_LightAttenuation,id:363,x:32669,y:32679,varname:node_363,prsc:2;n:type:ShaderForge.SFN_Multiply,id:6951,x:32924,y:32551,varname:node_6951,prsc:2|A-163-OUT,B-363-OUT;n:type:ShaderForge.SFN_ViewReflectionVector,id:450,x:32817,y:31958,varname:node_450,prsc:2;n:type:ShaderForge.SFN_Dot,id:2245,x:33097,y:32100,varname:node_2245,prsc:2,dt:1|A-450-OUT,B-4343-OUT;n:type:ShaderForge.SFN_Power,id:9502,x:33302,y:32100,varname:node_9502,prsc:2|VAL-2245-OUT,EXP-6450-OUT;n:type:ShaderForge.SFN_Exp,id:6450,x:33097,y:32274,varname:node_6450,prsc:2,et:0|IN-9618-OUT;n:type:ShaderForge.SFN_Slider,id:9618,x:32687,y:32274,ptovrint:False,ptlb:Specular Range,ptin:_SpecularRange,varname:node_9618,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Slider,id:564,x:33391,y:32000,ptovrint:False,ptlb:Specular Intensity,ptin:_SpecularIntensity,varname:node_564,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:5;n:type:ShaderForge.SFN_Multiply,id:2744,x:33818,y:32291,varname:node_2744,prsc:2|A-564-OUT,B-9502-OUT,C-8176-B,D-2536-RGB,E-6728-RGB;n:type:ShaderForge.SFN_Tex2d,id:8176,x:33582,y:32849,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:node_8176,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Add,id:2277,x:34156,y:32393,varname:node_2277,prsc:2|A-2744-OUT,B-7496-OUT,C-9845-OUT,D-5702-OUT;n:type:ShaderForge.SFN_Color,id:2536,x:33302,y:32274,ptovrint:False,ptlb:Specular Color,ptin:_SpecularColor,varname:node_2536,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Color,id:7946,x:33302,y:32454,ptovrint:False,ptlb:Diffuse Color,ptin:_DiffuseColor,varname:node_7946,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:9845,x:33787,y:33242,varname:node_9845,prsc:2|A-2560-RGB,B-6148-OUT,C-1668-RGB;n:type:ShaderForge.SFN_Slider,id:6148,x:33202,y:33216,ptovrint:False,ptlb:Env Intensity,ptin:_EnvIntensity,varname:node_6148,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Color,id:2560,x:33325,y:33019,ptovrint:False,ptlb:Env Color,ptin:_EnvColor,varname:node_2560,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:7154,x:34557,y:32380,varname:node_7154,prsc:2|A-2277-OUT,B-1956-RGB;n:type:ShaderForge.SFN_Multiply,id:5702,x:33813,y:33766,varname:node_5702,prsc:2|A-8176-R,B-1668-RGB,C-6873-OUT,D-2738-RGB;n:type:ShaderForge.SFN_Slider,id:6873,x:33179,y:33897,ptovrint:False,ptlb:Add Intensity,ptin:_AddIntensity,varname:node_6873,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:5;n:type:ShaderForge.SFN_Tex2d,id:3535,x:36384,y:31437,ptovrint:False,ptlb:Normal Map,ptin:_NormalMap,varname:node_3535,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:3,isnm:True;n:type:ShaderForge.SFN_Color,id:7176,x:34079,y:31083,ptovrint:False,ptlb:Glow Color,ptin:_GlowColor,varname:node_7241,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5019608,c2:0.5019608,c3:0.5019608,c4:1;n:type:ShaderForge.SFN_Tex2d,id:2287,x:34079,y:31278,ptovrint:False,ptlb:Glow Texture,ptin:_GlowTexture,varname:node_5819,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-4004-OUT;n:type:ShaderForge.SFN_Multiply,id:7826,x:36383,y:31715,varname:node_7826,prsc:2|A-7176-RGB,B-2287-RGB,C-8176-G,D-6728-RGB,E-4259-OUT;n:type:ShaderForge.SFN_TexCoord,id:9744,x:33112,y:31353,varname:node_9744,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Time,id:2500,x:32629,y:31398,varname:node_2500,prsc:2;n:type:ShaderForge.SFN_Slider,id:7109,x:32610,y:31246,ptovrint:False,ptlb:Speed U,ptin:_SpeedU,varname:node_4090,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-5,cur:0,max:5;n:type:ShaderForge.SFN_Slider,id:2450,x:32709,y:31624,ptovrint:False,ptlb:Speed V,ptin:_SpeedV,varname:_SpeedU_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-5,cur:0,max:5;n:type:ShaderForge.SFN_Multiply,id:9686,x:33112,y:31228,varname:node_9686,prsc:2|A-7109-OUT,B-2500-T;n:type:ShaderForge.SFN_Multiply,id:8677,x:33112,y:31493,varname:node_8677,prsc:2|A-2500-T,B-2450-OUT;n:type:ShaderForge.SFN_Add,id:3127,x:33312,y:31228,varname:node_3127,prsc:2|A-9686-OUT,B-9744-U;n:type:ShaderForge.SFN_Add,id:4098,x:33312,y:31363,varname:node_4098,prsc:2|A-9744-V,B-8677-OUT;n:type:ShaderForge.SFN_Append,id:956,x:33680,y:31278,varname:node_956,prsc:2|A-3127-OUT,B-4098-OUT;n:type:ShaderForge.SFN_Frac,id:4004,x:33894,y:31278,varname:node_4004,prsc:2|IN-956-OUT;n:type:ShaderForge.SFN_Color,id:2738,x:33258,y:34026,ptovrint:False,ptlb:Add Color,ptin:_AddColor,varname:node_2738,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Vector3,id:2475,x:33896,y:31919,varname:node_2475,prsc:2,v1:0,v2:1,v3:0;n:type:ShaderForge.SFN_Dot,id:9257,x:34071,y:31938,varname:node_9257,prsc:2,dt:1|A-2475-OUT,B-4300-OUT;n:type:ShaderForge.SFN_Fresnel,id:9438,x:34136,y:31772,varname:node_9438,prsc:2|EXP-40-OUT;n:type:ShaderForge.SFN_Multiply,id:4917,x:35473,y:31991,varname:node_4917,prsc:2|A-9438-OUT,B-9257-OUT,C-9613-OUT,D-8815-RGB;n:type:ShaderForge.SFN_Slider,id:5966,x:33596,y:31794,ptovrint:False,ptlb:Rim Range,ptin:_RimRange,varname:node_5966,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Exp,id:40,x:33913,y:31774,varname:node_40,prsc:2,et:0|IN-5966-OUT;n:type:ShaderForge.SFN_Slider,id:9613,x:34216,y:32000,ptovrint:False,ptlb:Top Intensity,ptin:_TopIntensity,varname:node_9613,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_Color,id:8815,x:34216,y:32128,ptovrint:False,ptlb:Top Color,ptin:_TopColor,varname:node_8815,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Add,id:1622,x:36383,y:31927,varname:node_1622,prsc:2|A-8284-OUT,B-7154-OUT,C-327-OUT;n:type:ShaderForge.SFN_Color,id:8807,x:34799,y:32448,ptovrint:False,ptlb:Fog Color,ptin:_FogColor,varname:node_8807,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Slider,id:655,x:34628,y:32709,ptovrint:False,ptlb:Fog Intensity,ptin:_FogIntensity,varname:node_655,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:0.5;n:type:ShaderForge.SFN_Multiply,id:327,x:35043,y:32496,varname:node_327,prsc:2|A-8807-RGB,B-655-OUT;n:type:ShaderForge.SFN_Cubemap,id:6728,x:32810,y:32981,ptovrint:False,ptlb:Cubemap,ptin:_Cubemap,varname:node_6728,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,pvfc:0|DIR-4300-OUT;n:type:ShaderForge.SFN_Slider,id:4259,x:34832,y:32069,ptovrint:False,ptlb:Glow Intensity,ptin:_GlowIntensity,varname:node_4259,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:5;n:type:ShaderForge.SFN_Vector3,id:7067,x:34641,y:31041,varname:node_7067,prsc:2,v1:1,v2:0,v3:0;n:type:ShaderForge.SFN_Dot,id:8031,x:35017,y:31303,varname:node_8031,prsc:2,dt:1|A-7067-OUT,B-4300-OUT;n:type:ShaderForge.SFN_Multiply,id:368,x:35852,y:31273,varname:node_368,prsc:2|A-8031-OUT,B-9438-OUT,C-690-RGB,D-5385-OUT;n:type:ShaderForge.SFN_Color,id:690,x:34840,y:31475,ptovrint:False,ptlb:Left Color,ptin:_LeftColor,varname:node_690,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Slider,id:5385,x:35034,y:31566,ptovrint:False,ptlb:Left Intensity,ptin:_LeftIntensity,varname:node_5385,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Add,id:8284,x:35819,y:32045,varname:node_8284,prsc:2|A-4917-OUT,B-368-OUT;proporder:2560-6148-7946-1668-2536-564-9618-8176-2738-6873-3535-7176-4259-2287-7109-2450-8815-9613-5966-8807-655-6728-690-5385;pass:END;sub:END;*/

Shader "Muon/HeroShow" {
    Properties {
        _EnvColor ("Env Color", Color) = (0.5,0.5,0.5,1)
        _EnvIntensity ("Env Intensity", Range(0, 1)) = 0
        _DiffuseColor ("Diffuse Color", Color) = (0.5,0.5,0.5,1)
        _DiffuseMap ("Diffuse Map", 2D) = "white" {}
        _SpecularColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
        _SpecularIntensity ("Specular Intensity", Range(0, 5)) = 1
        _SpecularRange ("Specular Range", Range(0, 10)) = 0
        _Mask ("Mask", 2D) = "white" {}
        _AddColor ("Add Color", Color) = (0.5,0.5,0.5,1)
        _AddIntensity ("Add Intensity", Range(0, 5)) = 0
        _NormalMap ("Normal Map", 2D) = "bump" {}
        _GlowColor ("Glow Color", Color) = (0.5019608,0.5019608,0.5019608,1)
        _GlowIntensity ("Glow Intensity", Range(0, 5)) = 0
        _GlowTexture ("Glow Texture", 2D) = "white" {}
        _SpeedU ("Speed U", Range(-5, 5)) = 0
        _SpeedV ("Speed V", Range(-5, 5)) = 0
        _TopColor ("Top Color", Color) = (0.5,0.5,0.5,1)
        _TopIntensity ("Top Intensity", Range(0, 10)) = 0
        _RimRange ("Rim Range", Range(0, 10)) = 0
        _FogColor ("Fog Color", Color) = (0.5,0.5,0.5,1)
        _FogIntensity ("Fog Intensity", Range(0, 0.5)) = 0
        _Cubemap ("Cubemap", Cube) = "_Skybox" {}
        _LeftColor ("Left Color", Color) = (0.5,0.5,0.5,1)
        _LeftIntensity ("Left Intensity", Range(0, 1)) = 0
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
            #pragma target 3.0
            uniform sampler2D _DiffuseMap; uniform float4 _DiffuseMap_ST;
            uniform float _SpecularRange;
            uniform float _SpecularIntensity;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform float4 _SpecularColor;
            uniform float4 _DiffuseColor;
            uniform float _EnvIntensity;
            uniform float4 _EnvColor;
            uniform float _AddIntensity;
            uniform sampler2D _NormalMap; uniform float4 _NormalMap_ST;
            uniform float4 _GlowColor;
            uniform sampler2D _GlowTexture; uniform float4 _GlowTexture_ST;
            uniform float _SpeedU;
            uniform float _SpeedV;
            uniform float4 _AddColor;
            uniform float _RimRange;
            uniform float _TopIntensity;
            uniform float4 _TopColor;
            uniform float4 _FogColor;
            uniform float _FogIntensity;
            uniform samplerCUBE _Cubemap;
            uniform float _GlowIntensity;
            uniform float4 _LeftColor;
            uniform float _LeftIntensity;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _NormalMap_var = UnpackNormal(tex2D(_NormalMap,TRANSFORM_TEX(i.uv0, _NormalMap)));
                float3 normalLocal = _NormalMap_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float4 _DiffuseMap_var = tex2D(_DiffuseMap,TRANSFORM_TEX(i.uv0, _DiffuseMap));
                clip(_DiffuseMap_var.a - 0.5);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
////// Emissive:
                float4 node_2500 = _Time;
                float2 node_4004 = frac(float2(((_SpeedU*node_2500.g)+i.uv0.r),(i.uv0.g+(node_2500.g*_SpeedV))));
                float4 _GlowTexture_var = tex2D(_GlowTexture,TRANSFORM_TEX(node_4004, _GlowTexture));
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                float4 _Cubemap_var = texCUBE(_Cubemap,normalDirection);
                float3 emissive = (_GlowColor.rgb*_GlowTexture_var.rgb*_Mask_var.g*_Cubemap_var.rgb*_GlowIntensity);
                float node_9438 = pow(1.0-max(0,dot(normalDirection, viewDirection)),exp(_RimRange));
                float3 finalColor = emissive + (((node_9438*max(0,dot(float3(0,1,0),normalDirection))*_TopIntensity*_TopColor.rgb)+(max(0,dot(float3(1,0,0),normalDirection))*node_9438*_LeftColor.rgb*_LeftIntensity))+(((_SpecularIntensity*pow(max(0,dot(viewReflectDirection,lightDirection)),exp(_SpecularRange))*_Mask_var.b*_SpecularColor.rgb*_Cubemap_var.rgb)+(_DiffuseColor.rgb*((max(0,dot(lightDirection,normalDirection))*attenuation)*_DiffuseMap_var.rgb))+(_EnvColor.rgb*_EnvIntensity*_DiffuseMap_var.rgb)+(_Mask_var.r*_DiffuseMap_var.rgb*_AddIntensity*_AddColor.rgb))*_LightColor0.rgb)+(_FogColor.rgb*_FogIntensity));
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
            #pragma target 3.0
            uniform sampler2D _DiffuseMap; uniform float4 _DiffuseMap_ST;
            uniform float _SpecularRange;
            uniform float _SpecularIntensity;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform float4 _SpecularColor;
            uniform float4 _DiffuseColor;
            uniform float _EnvIntensity;
            uniform float4 _EnvColor;
            uniform float _AddIntensity;
            uniform sampler2D _NormalMap; uniform float4 _NormalMap_ST;
            uniform float4 _GlowColor;
            uniform sampler2D _GlowTexture; uniform float4 _GlowTexture_ST;
            uniform float _SpeedU;
            uniform float _SpeedV;
            uniform float4 _AddColor;
            uniform float _RimRange;
            uniform float _TopIntensity;
            uniform float4 _TopColor;
            uniform float4 _FogColor;
            uniform float _FogIntensity;
            uniform samplerCUBE _Cubemap;
            uniform float _GlowIntensity;
            uniform float4 _LeftColor;
            uniform float _LeftIntensity;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _NormalMap_var = UnpackNormal(tex2D(_NormalMap,TRANSFORM_TEX(i.uv0, _NormalMap)));
                float3 normalLocal = _NormalMap_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float4 _DiffuseMap_var = tex2D(_DiffuseMap,TRANSFORM_TEX(i.uv0, _DiffuseMap));
                clip(_DiffuseMap_var.a - 0.5);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float node_9438 = pow(1.0-max(0,dot(normalDirection, viewDirection)),exp(_RimRange));
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                float4 _Cubemap_var = texCUBE(_Cubemap,normalDirection);
                float3 finalColor = (((node_9438*max(0,dot(float3(0,1,0),normalDirection))*_TopIntensity*_TopColor.rgb)+(max(0,dot(float3(1,0,0),normalDirection))*node_9438*_LeftColor.rgb*_LeftIntensity))+(((_SpecularIntensity*pow(max(0,dot(viewReflectDirection,lightDirection)),exp(_SpecularRange))*_Mask_var.b*_SpecularColor.rgb*_Cubemap_var.rgb)+(_DiffuseColor.rgb*((max(0,dot(lightDirection,normalDirection))*attenuation)*_DiffuseMap_var.rgb))+(_EnvColor.rgb*_EnvIntensity*_DiffuseMap_var.rgb)+(_Mask_var.r*_DiffuseMap_var.rgb*_AddIntensity*_AddColor.rgb))*_LightColor0.rgb)+(_FogColor.rgb*_FogIntensity));
                return fixed4(finalColor * 1,0);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
            #pragma target 3.0
            uniform sampler2D _DiffuseMap; uniform float4 _DiffuseMap_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float4 _DiffuseMap_var = tex2D(_DiffuseMap,TRANSFORM_TEX(i.uv0, _DiffuseMap));
                clip(_DiffuseMap_var.a - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Mobile/Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
