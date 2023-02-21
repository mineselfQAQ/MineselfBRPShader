Shader "MineselfShader/Basic/3-Texture/MatcapPro"
{
    Properties
    {
        _Matcap("Matcap", 2D) = "white"{}
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
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
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

                //计算vPos和vNormal，需要特殊映射才能去掉normalize()
                float3 vPos = normalize(UnityObjectToViewPos(v.vertex));
                float3 vNormal = normalize(mul(UNITY_MATRIX_IT_MV, v.normal));

                //使用叉乘得到一个垂直于这两个向量的方向
                float3 crossResult = cross(vPos, vNormal);

                //纠正方向并进行映射
                o.uv = float2(-crossResult.y, crossResult.x) * 0.5 + 0.5;

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