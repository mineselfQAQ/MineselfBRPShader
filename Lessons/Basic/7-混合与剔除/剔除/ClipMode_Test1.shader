Shader "MineselfShader/Basic/7-ClipMode&BlendMode/ClipMode_Test1"
{
    Properties
    {
        [Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 2
        _CutOut("CutOut", Range(-1, 1)) = 0
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            //对于使用了AlphaTest的Shader，最好加上这几句
            "Queue"="AlphaTest" 
            "RenderType"="TransparentCutout" 
            "IgnoreProjector"="True"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //渲染状态
            //更改剔除模式，默认为Cull Back，也就是剔除背面
            Cull [_CullMode]
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令

			
            //变量申明
            float _CutOut;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 oPos : TEXCOORD0;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //获得物体空间顶点位置
                o.oPos = v.vertex;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //通过物体空间顶点位置制作遮罩
                //物体原点(0,0,0)，那么在此之上的位置值越变越大，反之
                float mask = i.oPos.y;

                //使用遮罩作为颜色值(可视化)
                //使用1作为透明度，在没有Blend命令的情况下怎么更改都是没有用的(需要作为clip()的值时有用)
                float3 finalRGB = mask.rrr;
                float alpha = 1;

                //测试：将Alpha值固定为1，使用R通道进行剔除
                //结论：clip()不一定传入Alpha值，是根据传入的内容与0的关系
                clip(finalRGB.r - _CutOut);

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}