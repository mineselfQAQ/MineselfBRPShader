Shader "MineselfShader/Basic/3-Texture/RampMap"
{
    Properties
    {
        _Rampmap("RampMap", 2D) = "white"{}
        _uvY("uv:Y",Range(0,1)) = 0
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
            sampler2D _Rampmap;
            float _uvY;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal :NORMAL;
                float2 uv : TEXCOORD0;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 wPos : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.uv;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //计算光照向量
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                //计算halfLambert，但是这不应该看成光照模型，而应该是一个渐变值
                //halfLambert是从[-1,1]映射到的[0,1]，那么最亮处为1，最暗处为0
                float halfLambert = dot(lDir, i.wNormal) * 0.5 + 0.5;
                //控制渐变映射的方式
                //x---左右向，halfLambert
                //y---上下向，使用一个[0,1]的值
                //大致上就是：在halfLambert颜色值为0.5处，就会采样_Rampmap左右向的正中间(同时考虑y值)的颜色
                i.uv.x = halfLambert;
                i.uv.y = _uvY;

                //这里采样的uv，可以认为是使用halfLambert的uv
                //最暗处对应着贴图的左，最亮处对应着贴图的有
                //[0,1]的值控制贴图的上下
                float4 finalRGB = tex2D(_Rampmap, i.uv);

                return finalRGB;
            }
            ENDCG
        }
    }
    Fallback Off
}