Shader "MineselfShader/Basic/4-CustomMaterialInspector"
{
    Properties
    {
        [Header(Custom Material Inspector)]

        [Header(Texture_NoScaleOffset)][Space(5)]
        [NoScaleOffset]_MainTex("MainTex", 2D) = "white" {}

        [Header(HDR)][Space(5)]
        [HDR]_Color("Color", COLOR) = (1,1,1,1)

        [Header(Toggle)][Space(5)]
        [Toggle]_Invert("InvertColor", Float) = 0
        [Toggle(CHANGETOBLUE)]_ChangeCol("ChangeToBlue", Float) = 0

        [Header(Enum)]
        [Space(5)]
        [Enum(UnityEngine.Rendering.BlendMode)]_SrcBlend("SrcBlendMode", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)]_DstBlend("DstBlendMode", Float) = 1
        [Enum(UnityEngine.Rendering.CullMode)]_Cull("CullMode", Float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)]_ZTest("ZTest", Float) = 0
        [Space(5)]
        [Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Float) = 0
        [Space(5)]
        [KeywordEnum(None, Black, White)] _Change ("ChangeColor", Float) = 0

        [Header(PowerSlider)][Space(5)]
        [PowerSlider(3.0)] _Brightness ("Brightness", Range (0.01, 1)) = 0.1

        [Header(IntRange)][Space(5)]
        [IntRange]_Alpha("Alpha", Range(0, 255)) = 100

        //�Լ�����һ��ö��ֵ������ͨ��д�ű�ʵ��
        [Header(CustomEnum)][Space(5)]
        [Enum(MyEnum)]_MyEnum("MyEnum", Float) = 0
    }
    SubShader
    {
        Tags 
        {
            "Queue"="Transparent" 
            "RenderType"="Transparent" 
        }
        Blend [_SrcBlend] [_DstBlend]
        Cull [_Cull]
        ZTest [_ZTest]
        ZWrite [_ZWrite]

        Pass
        {
            CGPROGRAM
            //ע��:���ﲻ��ʹ��multi_compile�������ʹ�ã�ʹ������ע�͵���ʽ
            //#pragma multi_compile __ _INVERT_ON
            #pragma shader_feature _INVERT_ON
            #pragma shader_feature CHANGETOBLUE

            #pragma multi_compile _CHANGE_NONE _CHANGE_BLACK _CHANGE_WHITE

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            fixed4 _Color;
            float _Brightness;

            float _Alpha;

            //��������
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_TARGET
            {
                float4 mainTex = tex2D(_MainTex, i.uv);
                
                //ע�⣺����������һ��Ҫ�ǵ����#endif������ӱ����ָ�����Ϸ����������Ҳ��������

                #if _INVERT_ON
                mainTex.rgb = 1 - mainTex.rgb;
                #endif

                #if CHANGETOBLUE
                mainTex.rgb = float3(0, 0, 1);
                #endif

                #if _CHANGE_BLACK
                mainTex.rgb = float3(0, 0, 0);
                #elif _CHANGE_WHITE
                mainTex.rgb = float3(1, 1, 1);
                #endif

                mainTex.rgb *= _Brightness * _Color;

                float alpha = _Alpha / 255;
                mainTex.a *= alpha;

                return mainTex;
            }
            ENDCG
        }
    }
}
