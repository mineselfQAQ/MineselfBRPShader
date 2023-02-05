Shader "MineselfShader/Basic/2-InterpolationMethod/FlatShading"
{
    Properties
    {
        _Gloss("Gloss", Range(0.1, 100)) = 30.0
        _Int("0:PhongShading 1:FlatShading", Range(0, 1)) = 1
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
            float _Int;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;//计算正常法线用
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 wPos : TEXCOORD0;
                float3 wNormal : TEXCOORD1;//计算正常法线用
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //通过DDX与DDY求出世界位置法线
                 float3 worldDx = ddx(i.wPos);
                 float3 worldDy = ddy(i.wPos);
                 float3 worldNormal = normalize(cross(worldDy, worldDx));

                 //使用滑条控制法线，0时输出正常法线，1时输出偏导法线
                 //由于插值后搞不清到底是不是单位向量，多进行一步normalize()即可
                 float3 nDir = normalize(lerp(normalize(i.wNormal), worldNormal, _Int));

                 //计算光照向量
                 float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                 float3 rlDir = reflect(-lDir, nDir);
                 float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                 //计算Phong光照模型(去除环境漫反射)
                 float diffuse = saturate(dot(lDir, nDir));
                 float specular = pow(saturate(dot(rlDir, vDir)), _Gloss);

                 //合并输出，特殊写法---Swizzle操作符
                 float3 finalRGB = (diffuse + specular).rrr;

                 return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}