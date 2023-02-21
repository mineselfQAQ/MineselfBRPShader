Shader "MineselfShader/Basic/3-Texture/Matcap"
{
    Properties
    {
        _Matcap("Matcap", 2D) = "white"{}
        _Scale("ScaleXY", vector) = (1,1,0,0)
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
            float2 _Scale;
                
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

            //重映射，用于正确映射取值范围
            float2 Remap(float2 xy, float2 inMin, float2 inMax, float2 outMin, float2 outMax)
            {
                return (outMax - outMin) / (inMax - inMin) * (xy - inMin) + outMin;
            }

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //错误:当出现非均匀缩放时采样完全出错
                //float3 vNormal = mul(UNITY_MATRIX_MV, v.normal);
                //错误:不应该进行归一化
                //float3 vNormal = normalize(mul(UNITY_MATRIX_IT_MV, v.normal));

                //使用逆转置MV矩阵将法线从物体空间转换到观察空间(支持非均匀缩放)
                float3 vNormal = mul(UNITY_MATRIX_IT_MV, v.normal);

                //将取值范围从[-1,1]映射到正确的范围
                o.uv = Remap(vNormal.xy, -1, 1, 0.5 - 0.5 * _Scale, 0.5 + 0.5 * _Scale);

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