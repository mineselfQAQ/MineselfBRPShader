Shader "MineselfShader/Basic/7-ClipMode&BlendMode/ClipMode_Test2"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _Color("Color", COLOR) = (1,1,1,1)

        [Space(10)]

        _CutOut("CutOut", Range(0, 1)) = 0
        [IntRange]_Invert("Invert", Range(0, 1)) = 0
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
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令

			
            //变量申明
            sampler2D _MainTex;
            fixed4 _Color;
            float _CutOut;
            float _Invert;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                
                o.uv = v.uv;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //这里声明的是float4，这对于正常带有A通道的贴图是必要的
                //但是如果贴图没有A通道，那么就会是默认的1
                float4 mainTex = tex2D(_MainTex, i.uv);
                //拆开，分为RGB部分和A部分
                float3 finalRGB = mainTex.rgb;
                float alpha = mainTex.a;

                //反向贴图，也就是将0和1部分交换
                float3 invfinalRGB = 1 - finalRGB;

                //使用lerp()以及一个0或1值进行黑白翻转的开关
                finalRGB = lerp(mainTex, invfinalRGB, _Invert);
                //使用lerp()将白色部分上色
                finalRGB = lerp(finalRGB, _Color, finalRGB);
                
                //固定剔除，将左右两侧的多余部分剔除
                clip(alpha - _CutOut);
                //使用R通道进行剔除中间部分(可以是G或B通道)
                clip(finalRGB.r - _CutOut);
                
                //对于最终的输出，这里的alpha值其实是没有作用的，可以是任意值
                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}