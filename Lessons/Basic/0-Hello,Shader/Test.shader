Shader "MineselfShader/Basic/0-HelloShaderTest"
{
    Properties
    {
        _Color("Color", COLOR) = (1,1,1,1)
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
            /*
            vert/frag�붥��/ƬԪ��ɫ�������������ֶ�Ӧ---Ҫ��һ���
            */
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"//�������Ǳ���ģ���������Ҫ��API
            //��������ļ�����ָ��

			
            //��������
            fixed4 _Color;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;//POSITION���壬��vertex����Ϊ����λ��
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;//SV_POSITION���壬���ս�pos����(��Ҫ�ڲü��ռ�)
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;

                //������λ��ʹ��MVP����任���ü��ռ䣬��pos���գ����������ڲ���ɺ����Ĳ������"��Ļ�ϵĵ�"
                //����˵���������е�vertex�Ͷ�������е�pos�Ǳ�����ڵ�
                //��������þ�����������Щ��涨�����֣���ƥ��ͻ����
                o.pos = UnityObjectToClipPos(v.vertex);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target//SV_Target����
            {
                //�����ɫ������ʹ��Properties����
                float3 finalRGB = _Color;

                //�����ɫ      ԭ��---ȡֵ��Χ��[0,1]ӳ��Ϊ[1,0]
                finalRGB = 1 - finalRGB;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off//��ʹ�ûص�
}