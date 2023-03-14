Shader "MineselfShader/Basic/14-RamdomUV/RandomUV2"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _NoiseTex("NoiseTexture", 2D) = "white"{}
        _RandomMin("RandomMin", Range(0, 1)) = 0
        _RandomMax("RandomMax", Range(0, 1)) = 1
        [IntRange]_RandomAmount("RandomAmount", Range(1, 15)) = 7
        _RotationMin("RotationMin", Float) = -180
        _RotationMax("RotationMax", Float) = 180
        _ScaleMin("ScaleMin", Float) = 0.8
        _ScaleMax("ScaleMax", Float) = 1.2
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
            #include "..\..\_Common\MyLib.cginc"
			
            //变量申明
            sampler2D _MainTex; float4 _MainTex_ST;
            sampler2D _NoiseTex; float4 _NoiseTex_ST;
            float _RandomMin;
            float _RandomMax;
            float _RandomAmount;
            float _RotationMin;
            float _RotationMax;
            float _ScaleMin;
            float _ScaleMax;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv2 = TRANSFORM_TEX(v.uv, _NoiseTex);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float2 noiseMask = tex2D(_NoiseTex, i.uv2);
                noiseMask = round(smoothstep(_RandomMin, _RandomMax, noiseMask) * _RandomAmount);

                float2 randomUV = RandomUVTransform(i.uv, float2(_ScaleMin, _ScaleMax), float2(_RotationMin, _RotationMax), noiseMask);
                float4 mainTex = tex2D(_MainTex, randomUV);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}