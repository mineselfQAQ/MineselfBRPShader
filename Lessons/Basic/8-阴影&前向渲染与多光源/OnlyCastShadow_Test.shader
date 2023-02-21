Shader "MineselfShader/Basic/8_Shadow/OnlyCastShadow_Test"
{
    Properties
    {
        
    }
    SubShader
    {
        //SubShader Tags
		Tags{}
        //Pass1---正常Pass
        Pass
        {
            //Pass Tags
            Tags{}
            //渲染状态
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令

			
            //变量申明
            
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float3 finalRGB = float3(1,1,1);
                return float4(finalRGB, 1);
            }
            ENDCG
        }
        //Pass2---ShadowCaster
        Pass
        {
            Tags{"LightMode"="ShadowCaster"}
            //渲染状态
    
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_shadowcaster
        
            //顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
    
            //顶点输出
            struct v2f
            {
                V2F_SHADOW_CASTER;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    //如果想要产生投射阴影的效果的话:
    //要么添加上面的ShadowCasterPass
    //要么添加下面的Fallback语句，只要Fallback语句中包括ShadowCasterPass就能正常显示
    Fallback "Diffuse"
}