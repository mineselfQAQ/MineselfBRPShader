Shader "MineselfShader/Basic/8_Shadow/ShadowWithForwardAdd"
{
    Properties
    {

    }
    SubShader
    {
        //SubShader Tags
		Tags{}

        //Pass1---ForwardBase
        Pass
        {
            Tags
            {
                //Pass1一定得是ForwardBase，其中需要对太阳光与逐顶点/SH光源进行处理
                "LightMode"="ForwardBase"
            }
            //渲染状态
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"//用于_LightColor0
            #include "AutoLight.cginc"//这些宏的关键
            //添加关键字，用于ForwardBase，与下方的宏也有关
            #pragma multi_compile_fwdbase
			
            //变量申明
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 wPos : TEXCOORD0;
                float3 wNormal : TEXCOORD1;

                //声明_ShadowCoord，使用TEXCOORDx语义，所以不能重复
                SHADOW_COORDS(2)//注意:没有分号
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                //空间转换
                TRANSFER_SHADOW(o);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = normalize(reflect(-lDir, nDir));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
                
                float3 ambient = unity_AmbientSky;
                float3 diffuse = _LightColor0 * saturate(dot(lDir, nDir));
                float3 specular = _LightColor0 * pow(saturate(dot(rlDir, vDir)), 30);

                //计算阴影值
                float shadow = SHADOW_ATTENUATION(i);

                float3 finalRGB = ambient + (diffuse + specular) * shadow;

                return float4(finalRGB, 1);
            }
            ENDCG
        }

        //Pass2---ForwardAdd
        Pass
        {
            Tags
            {
                //Pass2一定得是ForwardAdd，其中需要对除了太阳光的其他逐像素光源进行处理
                "LightMode"="ForwardAdd"
            }
            //渲染状态
            //注意需要与Pass1进行混合，所以有Blend命令
            Blend One One
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //同Pass1
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            //对于ForwardAdd来说，如果想要获得全部的阴影效果的话
            //需要使用fwdadd_fullshadows而不是fwdadd
            #pragma multi_compile_fwdadd_fullshadows
			
            //变量申明
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 wPos : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = normalize(reflect(-lDir, nDir));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
                
                float3 ambient = unity_AmbientSky;
                float3 diffuse = _LightColor0 * saturate(dot(lDir, nDir));
                float3 specular = _LightColor0 * pow(saturate(dot(rlDir, vDir)), 30);

                //计算光线衰减
                #ifdef USING_DIRECTIONAL_LIGHT
					fixed atten = 1.0;
				#else
					#if defined (POINT)
				        float3 lightCoord = mul(unity_WorldToLight, i.wPos).xyz;
				        fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
				    #elif defined (SPOT)
				        float4 lightCoord = mul(unity_WorldToLight, i.wPos);
				        fixed atten = (lightCoord.z > 0) *
                        tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * 
                        tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
				    #else
				        fixed atten = 1.0;
				    #endif
				#endif

                //注意！！！不能添加ambient
                float3 finalRGB = (diffuse + specular) * atten;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    //产生投射阴影的方式
    Fallback "Diffuse"
}