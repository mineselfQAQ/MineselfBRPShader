Shader "MineselfShader/Basic/3-Texture/Albedo"
{
    Properties
    {
        _MainTex("MainTex", 2D) = "white"{}
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

			
            //变量申明
            //_ST的内容是用于贴图公开属性中的Tilling和Offset的
            sampler2D _MainTex; float4 _MainTex_ST;
                
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

                //如果不需要Tiling和Offset，直接传入传出即可
                //o.uv = v.uv;

                //如果需要Tiling和Offset，可以使用函数实现，也可以手动编写
                //函数实现：TRANSFORM_TEX(uv, 贴图)
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //手动实现：xy分量代表着横向和竖向Tiling，zw分量代表着横向和竖向Offset
                //对于uv来说，先缩放，再平移
                o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //使用tex2D()进行采样即可
                float3 mainTex = tex2D(_MainTex, i.uv);

                return float4(mainTex, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}