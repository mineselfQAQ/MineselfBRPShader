Shader "MineselfShader/Basic/2-InterpolationMethod/PhongShading"
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
                float4 wPos : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //在顶点着色器中先获得世界位置信息和世界法线信息 ，传入片元着色器使用
                //此时其实只获取了法线
                //在片元着色器中有方便的函数可以通过wPos来获取某些向量
                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //计算光照向量
                //要注意的是：由于是在片元着色器计算，所以这些向量都是逐片元级别的，也就是每个片元都会有它自己的向量
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = normalize(reflect(-lDir, nDir));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

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