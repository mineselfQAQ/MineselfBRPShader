Shader "MineselfShader/Basic/2-InterpolationMethod/PhongShading2"
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
                float3 wlDir : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
                float3 wvDir : TEXCOORD2;
                float3 wrlDir : TEXCOORD3;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //计算光照向量，将所有需要用到的向量都计算完毕，然后使用结构体进行输出
                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.wlDir = WorldSpaceLightDir(v.vertex);
                o.wrlDir = reflect(-o.wlDir, o.wNormal);
                o.wvDir = WorldSpaceViewDir(v.vertex);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //对所有的向量进行归一化处理
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(i.wlDir);
                float3 rlDir = normalize(i.wrlDir);
                float3 vDir = normalize(i.wvDir);

                //计算Phong光照模型(去除环境漫反射)
                float diffuse = saturate(dot(lDir, nDir));
                float specular = pow(saturate(dot(vDir, rlDir)), _Gloss);
                
                 //合并输出，特殊写法---Swizzle操作符
                float3 finalRGB = (diffuse + specular).rrr;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}