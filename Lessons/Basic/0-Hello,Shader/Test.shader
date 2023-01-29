Shader "MineselfShader/Basic/0-HelloShaderTest"
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
            /*
            vert/frag与顶点/片元着色器中声明的名字对应---要改一起改
            */
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"//基本上是必须的，里面有重要的API
            //额外包含文件编译指令

			
            //变量申明
            fixed4 _Color;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;//POSITION语义，将vertex声明为顶点位置
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;//SV_POSITION语义，最终将pos传出(需要在裁剪空间)
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;

                //将顶点位置使用MVP矩阵变换到裁剪空间，用pos接收，最终由其内部完成后续的操作获得"屏幕上的点"
                //所以说顶点输入中的vertex和顶点输出中的pos是必须存在的
                //其名字最好就是这样，有些宏规定了名字，不匹配就会出错
                o.pos = UnityObjectToClipPos(v.vertex);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target//SV_Target语义
            {
                //输出颜色，并且使用Properties公开
                float3 finalRGB = _Color;

                //输出反色      原理---取值范围从[0,1]映射为[1,0]
                finalRGB = 1 - finalRGB;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off//不使用回调
}