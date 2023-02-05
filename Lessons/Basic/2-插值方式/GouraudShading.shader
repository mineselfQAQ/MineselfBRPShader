Shader "MineselfShader/Basic/2-InterpolationMethod/GouraudShading"
{
    Properties
    {
        _Gloss("Gloss", Range(0.1, 100)) = 30.0
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
            float _Gloss;
                
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
                float4 color : COLOR;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //计算光照向量    
                float3 nDir = normalize(UnityObjectToWorldNormal(v.normal));
                float3 lDir = normalize(WorldSpaceLightDir(v.vertex));
                float3 rlDir = normalize(reflect(-lDir, nDir));
                float3 vDir = normalize(WorldSpaceViewDir(v.vertex));

                //计算Phong光照模型(去除环境漫反射)
                float diffuse = saturate(dot(lDir, nDir));
                float specular = pow(saturate(dot(rlDir, vDir)), _Gloss);

                //通过o.color传递顶点光照信息         特殊写法---Swizzle操作符
                o.color = float4((diffuse + specular).rrr, 1);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //由于是从顶点着色器中计算好的光照模型，这是逐顶点级别的，也就是每个顶点有它自己的向量
                //最终会通过插值的方式，从颜色信息从顶点着色器传递到片元着色器
                return i.color;
            }
            ENDCG
        }
    }
    Fallback Off
}