Shader "MineselfShader/Basic/Instance/Mirror/Mirror_Object"
{
    Properties
    {
        [IntRange]_ID("ID", Range(0, 255)) = 1
        _Color("Color", COLOR) = (1,1,1,1)
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            //排除其他特殊物体，是最后一类渲染的物体，在遮罩(队列2001)后渲染
            "Queue" = "Geometry+2"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //渲染状态
            Stencil
            {
                //为了与普通物体区分，Ref值不是0，可以是1-255中任意一个值
                //但是一定要和Mirror_Mask中的Ref值一致
                Ref[_ID]
                //这里设置的比较方式为等于，那么遮罩和镜中物体的Ref值是一致的(如果设置正确)，
                //最终从摄像机出发，在遮罩后的镜中物体就能看到，而在其余区域后就看不到镜中物体
                Comp Equal
            }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令

			
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
                //这里的输出取决于想要的效果
                //如果想要Phong光照模型，那么就输出即可
                //这里选择最简单的输出单色
                return _Color;
            }
            ENDCG
        }
    }
    Fallback Off
}