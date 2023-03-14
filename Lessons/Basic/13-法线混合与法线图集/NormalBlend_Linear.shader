Shader "MineselfShader/Basic/13-NormalBlend&NormalAtlas/NormalBlend/Linear"
{
    Properties
    {
        [Normal]_MainNormalTex("MainNormalTexture", 2D) = "bump"{}
        [Normal]_SecondNormalTex("SecondNormalTexture", 2D) = "bump"{}
        _MainSacle("MainScale", Range(0.1, 10)) = 1
        _SecondSacle("SecondSacle", Range(0.1, 10)) = 5

        _Gloss("Gloss", Range(1, 100)) = 30
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
            #include "Lighting.cginc"
			
            //变量申明
            sampler2D _MainNormalTex;
            sampler2D _SecondNormalTex;
            float _MainSacle;
            float _SecondSacle;
            float _Gloss;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3x3 tbn : TEXCOORD0;
                float2 uv : TEXCOORD3;
                float4 wPos : TEXCOORD4;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                float3 t = UnityObjectToWorldDir(v.tangent);
                float3 n = UnityObjectToWorldNormal(v.normal);
                float3 b = cross(n, t) * v.tangent.w * unity_WorldTransformParams.w;
                o.tbn = float3x3(t, b, n);

                o.uv = v.uv;

                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //使用混合计算出法线
                float3 mainUnpackNormal = UnpackNormal(tex2D(_MainNormalTex, i.uv * _MainSacle));
                float3 secondUnpackNormal = UnpackNormal(tex2D(_SecondNormalTex, i.uv * _SecondSacle));
                float3 blendNormal = mainUnpackNormal + secondUnpackNormal;//线性混合，直接将两者相加
                float3 finalNormal = normalize(mul(blendNormal, i.tbn));

                //光照向量计算
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = normalize(reflect(-lDir, finalNormal));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                //光照计算
                //_LightColor0最好加上，原因：
                //没有Albedo的情况下容易出现过曝，可以使用_LightColor0调整太阳光的强度防止过曝
                float3 ambient = unity_AmbientSky;
                float diffuse = _LightColor0 * saturate(dot(lDir, finalNormal));
                float specular = _LightColor0 * pow(saturate(dot(rlDir, vDir)), _Gloss);

                float3 finalRGB = ambient + diffuse + specular;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}