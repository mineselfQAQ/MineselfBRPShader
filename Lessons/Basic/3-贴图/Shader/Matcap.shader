Shader "MineselfShader/Basic/3-Texture/Matcap"
{
    Properties
    {
        _Matcap("Matcap", 2D) = "white"{}
        _Scale("ScaleXY", vector) = (1,1,0,0)
    }
    SubShader
    {
        //SubShader Tags
		Tags{}
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
            sampler2D _Matcap;
            float2 _Scale;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            //��ӳ�䣬������ȷӳ��ȡֵ��Χ
            float2 Remap(float2 xy, float2 inMin, float2 inMax, float2 outMin, float2 outMax)
            {
                return (outMax - outMin) / (inMax - inMin) * (xy - inMin) + outMin;
            }

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //����:�����ַǾ�������ʱ������ȫ����
                //float3 vNormal = mul(UNITY_MATRIX_MV, v.normal);
                //����:��Ӧ�ý��й�һ��
                //float3 vNormal = normalize(mul(UNITY_MATRIX_IT_MV, v.normal));

                //ʹ����ת��MV���󽫷��ߴ�����ռ�ת�����۲�ռ�(֧�ַǾ�������)
                float3 vNormal = mul(UNITY_MATRIX_IT_MV, v.normal);

                //��ȡֵ��Χ��[-1,1]ӳ�䵽��ȷ�ķ�Χ
                o.uv = Remap(vNormal.xy, -1, 1, 0.5 - 0.5 * _Scale, 0.5 + 0.5 * _Scale);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float3 finalRGB = tex2D(_Matcap, i.uv);
                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}