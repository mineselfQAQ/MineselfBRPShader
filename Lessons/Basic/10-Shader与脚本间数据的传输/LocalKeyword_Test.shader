Shader "MineselfShader/Basic/10-Shader&MaterialClass/Keyword_Test"
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
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

            //˫�»���__��������һ�������صĹؼ��֣�����ָ_INVERT_OFF
            //Ϊ��������ʹ�ܽ��п��أ���Ҫʹ��multi_compile������ʹ��shader_feature
            //���ʹ��Material����п��عؼ��֣�Ӧ��ʹ��multi_compile_local
            //���ʹ��Shader����п��عؼ��֣�Ӧ��ʹ��multi_compile
            //��Ϊ:
            //Material���µ��Ǿֲ��ؼ��֣���Shader���µ���ȫ�ֹؼ���
            //һ�����ڵ�ǰmaterial��һ�����������иùؼ����Ҿ���ȫ�������������
            //***���忴�ĵ�***
            #pragma multi_compile __ _INVERT_ON

            //��������
            fixed4 _Color;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float3 finalRGB = _Color;

                #if _INVERT_ON
                    finalRGB = 1 - finalRGB;
                #endif

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}