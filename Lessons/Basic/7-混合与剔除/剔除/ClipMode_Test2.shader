Shader "MineselfShader/Basic/7-ClipMode&BlendMode/ClipMode_Test2"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        _Color("Color", COLOR) = (1,1,1,1)

        [Space(10)]

        _CutOut("CutOut", Range(0, 1)) = 0
        [IntRange]_Invert("Invert", Range(0, 1)) = 0
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            //����ʹ����AlphaTest��Shader����ü����⼸��
            "Queue"="AlphaTest" 
            "RenderType"="TransparentCutout" 
            "IgnoreProjector"="True"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //��Ⱦ״̬
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            sampler2D _MainTex;
            fixed4 _Color;
            float _CutOut;
            float _Invert;
                
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
            fixed4 frag (v2f i) : SV_Target
            {
                //������������float4���������������Aͨ������ͼ�Ǳ�Ҫ��
                //���������ͼû��Aͨ������ô�ͻ���Ĭ�ϵ�1
                float4 mainTex = tex2D(_MainTex, i.uv);
                //�𿪣���ΪRGB���ֺ�A����
                float3 finalRGB = mainTex.rgb;
                float alpha = mainTex.a;

                //������ͼ��Ҳ���ǽ�0��1���ֽ���
                float3 invfinalRGB = 1 - finalRGB;

                //ʹ��lerp()�Լ�һ��0��1ֵ���кڰ׷�ת�Ŀ���
                finalRGB = lerp(mainTex, invfinalRGB, _Invert);
                //ʹ��lerp()����ɫ������ɫ
                finalRGB = lerp(finalRGB, _Color, finalRGB);
                
                //�̶��޳�������������Ķ��ಿ���޳�
                clip(alpha - _CutOut);
                //ʹ��Rͨ�������޳��м䲿��(������G��Bͨ��)
                clip(finalRGB.r - _CutOut);
                
                //�������յ�����������alphaֵ��ʵ��û�����õģ�����������ֵ
                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}