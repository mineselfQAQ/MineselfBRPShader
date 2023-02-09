Shader "MineselfShader/Basic/Instance/Mirror/Mirror_Mask"
{
    Properties
    {
        [IntRange]_ID("ID", Range(0, 255)) = 1
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            //排除其他特殊物体，正常来说会是在正常物体(队列2000)之后渲染，但是会在镜中物体(队列2002)之前渲染
            "Queue" = "Geometry+1"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //渲染状态
            Stencil
            {
                //为了与普通物体区分，Ref值不是0，可以是1-255中任意一个值
                //但是一定要和Mirror_Object中的Ref值一致---因为在Mirror_Object的比较方式为Comp Equal
                Ref[_ID]
                //当物体通过模板测试时，会将这些通过的片元的Ref值写入模板缓冲区
                //这样在镜中物体(队列2002)渲染，前Ref值已经被设置非0值，
                //在镜中物体的渲染通过内部Comp Equal，使镜子后的物体通过模板测试从而渲染，而边上没有通过的片元就看不到镜中物体
                Pass Replace
            }

            //不该在此处深度写入，这会导致后面的物体被遮挡
            ZWrite Off
            //不该在此处输出颜色，这里只是一个遮罩Mask
            ColorMask 0

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
                //任意输出，因为已经通过ColorMask 0使不输出任意通道
                float3 finalRGB = float3(1,1,1);
                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}