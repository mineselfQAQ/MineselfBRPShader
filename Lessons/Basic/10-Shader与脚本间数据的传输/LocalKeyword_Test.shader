Shader "MineselfShader/Basic/10-Shader&MaterialClass/Keyword_Test"
{
    Properties
    {
        _Color("Color", COLOR) = (1,1,1,1)
    }
    SubShader
    {
        //SubShader Tags
		Tags{}
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

            //双下划线__代表着另一个被隐藏的关键字，这里指_INVERT_OFF
            //为了在运行使能进行开关，需要使用multi_compile而不能使用shader_feature
            //如果使用Material类进行开关关键字，应该使用multi_compile_local
            //如果使用Shader类进行开关关键字，应该使用multi_compile
            //因为:
            //Material类下的是局部关键字，而Shader类下的是全局关键字
            //一个用于当前material，一个用于所有有该关键字且具有全局作用域的内容
            //***具体看文档***
            #pragma multi_compile __ _INVERT_ON

            //变量申明
            fixed4 _Color;
                
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
                float3 finalRGB = _Color;

                #if _INVERT_ON
                    finalRGB = 1 - finalRGB;
                #endif

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}