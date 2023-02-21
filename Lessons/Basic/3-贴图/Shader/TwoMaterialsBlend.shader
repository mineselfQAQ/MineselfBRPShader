Shader "MineselfShader/Basic/3-Texture/TwoMaterialsBlend"
{
    Properties
    {
        [Header(Noise)] [Space(5)]
        _NoiseTex("NoiseTexture", 2D) = "white"{}
        _NoiseInt("0:Main 1:Noise", Range(0, 1)) = 1
        [Header(Diffuse)] [Space(5)]
        _MainColor("MainColor", COLOR) = (1,1,1,1)
        _NoiseColor("NoiseColor", COLOR) = (1,1,1,1)
        [Header(Specular)] [Space(5)]
        _MainGloss("MainGloss", Range(0.1, 100)) = 30
        _NoiseGloss("NoiseGloss", Range(0.1, 100)) = 30
        _MainSpecInt("MainSpecularIntensity", Range(0, 1)) = 1
        _NoiseSpecInt("NoiseSpecularIntensity", Range(0, 1)) = 1
        [Header(Fresnel)] [Space(5)]
        _FresnelCol("FresnelColor", COLOR) = (1,1,1,1)
        _FresnelPow("FresnelPower", Range(1, 10)) = 3
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
            sampler2D _NoiseTex; float4 _NoiseTex_ST;
            float _NoiseInt;
            fixed4 _MainColor;
            fixed4 _NoiseColor;
            float _MainGloss;
            float _NoiseGloss;
            float _MainSpecInt;
            float _NoiseSpecInt;
            fixed4 _FresnelCol;
            float _FresnelPow;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
                float4 wPos : TEXCOORD2;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                //使Tiling和Offset可用
                o.uv = TRANSFORM_TEX(v.uv, _NoiseTex);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = normalize(reflect(-lDir, nDir));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                //采样以及制作Mask，最终Mask会是一张非黑即白的贴图
                //注意：mask只是一张遮罩图，上面记录的是"值"，所以是1D的
                float noiseMask = tex2D(_NoiseTex, i.uv);
                noiseMask = step(_NoiseInt, noiseMask);

                //对我们需要使用mask控制变量进行处理---混合
                //比如说：gloss就是在noiseMask为0的时候使用噪声的gloss值，为1的时候使用本来的gloss值
                float3 diffCol = lerp(_NoiseColor, _MainColor, noiseMask);
                float gloss = lerp(_NoiseGloss, _MainGloss, noiseMask);
                float specInt = lerp(_NoiseSpecInt, _MainSpecInt, noiseMask);

                //光照计算
                //注意一点：ambient是需要带上diffCol的，不然背面是死黑的
                float3 ambient =  unity_AmbientSky;
                float3 diffuse = diffCol * saturate(dot(nDir, lDir));
                float3 specular = specInt * pow(saturate(dot(rlDir, vDir)), gloss);
                float3 fresnel = _FresnelCol * pow(1 - saturate(dot(vDir, nDir)), _FresnelPow);

                float3 finalRGB = ambient + diffuse + specular + fresnel;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}
