Shader "MineselfShader/Basic/3-Texture/Matcap_FixedLight"
{
    Properties
    {
        _Matcap("Matcap", 2D) = "white"{}
        _Border("Border", Range(0.1, 0.5)) = 0.45
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
            sampler2D _Matcap;
            float _Border;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
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

                //使用世界空间法线
                //在这里一定需要归一化，因为我们希望模型的正/负半面都将呈现贴图的样子
                float3 wNormal = UnityObjectToWorldNormal(v.normal);
                //float3 wNormal = mul(v.normal, (float3x3)unity_WorldToObject);

                //与其使用世界空间法线，不如直接使用物体空间法线---可以进行光源"移动"操作
                float3 oNormal = v.normal;

                //将[-1,1]映射到[0,1]---_Border=0.5
                //为了防止边缘异样，将取值范围向内缩，从图像上就是采样"向内一圈"
                o.uv = wNormal.xy * _Border + 0.5;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float3 finalRGB = tex2D(_Matcap, i.uv);
                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}