Shader "MineselfShader/Basic/3-Texture/NormalMap_WorldSpace"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        //法线一般使用"bump"
        [Normal][NoScaleOffset]_NormalTex("NormalTexture", 2D) = "bump"{}
        _BumpScale("BumpScale",Range(-2, 2)) = 1.0
        _Gloss("Gloss", Range(0, 100)) = 30
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
            sampler2D _MainTex; float4 _MainTex_ST;
            sampler2D _NormalTex;
            float _BumpScale;
            float _Gloss;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 wPos : TEXCOORD1;
                float3x3 tbn : TEXCOORD2;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                //tbn矩阵计算
                float3 wNormal = UnityObjectToWorldNormal(v.normal);
                float3 wTangent = UnityObjectToWorldDir(v.tangent.xyz);
                //wTangent的另一种写法，使用矩阵计算
                //float3 wTangent = mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0));
                float3 wBitangent = cross(wNormal, wTangent) * v.tangent.w * unity_WorldTransformParams.w;

                //组合tbn矩阵
                o.tbn = float3x3(wTangent, wBitangent, wNormal);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //从法线贴图中获取切线空间法线向量
                float3 localNormal = UnpackNormal(tex2D(_NormalTex, i.uv));
                //更改法线偏移强度
                localNormal.xy *= _BumpScale;
                //将切线空间法线向量变换到世界空间
                float3 worldNormal = normalize(mul(localNormal, i.tbn));
                //另一种写法---列向量左乘列矩阵
                //float3 worldNormal = normalize(mul(transpose(i.tbn), localNormal));

                //小trick
                //通过lerp控制法线偏移强度    0为不改变，1为完全改变
                //(如果没有localNormal.xy *= _BumpScale;的话可以使用)
                //worldNormal = lerp(i.nDir, worldNormal, _BumpScale);


                //普通的光照计算
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = normalize(reflect(-lDir, worldNormal));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
                
                float4 mainTex = tex2D(_MainTex, i.uv);
                
                float3 ambient = unity_AmbientSky;
                float3 diffuse = saturate(dot(lDir, worldNormal));
                float3 specular = pow(saturate(dot(rlDir, vDir)), _Gloss) ;

                float3 finalRGB = ambient * mainTex + diffuse * mainTex + specular;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}