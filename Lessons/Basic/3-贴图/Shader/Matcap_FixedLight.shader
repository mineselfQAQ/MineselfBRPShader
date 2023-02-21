Shader "MineselfShader/Basic/3-Texture/Matcap_FixedLight"
{
    Properties
    {
        _Matcap("Matcap", 2D) = "white"{}
        _Border("Border", Range(0.1, 0.5)) = 0.45
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
            float _Border;
                
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

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //ʹ������ռ䷨��
                //������һ����Ҫ��һ������Ϊ����ϣ��ģ�͵���/�����涼��������ͼ������
                float3 wNormal = UnityObjectToWorldNormal(v.normal);
                //float3 wNormal = mul(v.normal, (float3x3)unity_WorldToObject);

                //����ʹ������ռ䷨�ߣ�����ֱ��ʹ������ռ䷨��---���Խ��й�Դ"�ƶ�"����
                float3 oNormal = v.normal;

                //��[-1,1]ӳ�䵽[0,1]---_Border=0.5
                //Ϊ�˷�ֹ��Ե��������ȡֵ��Χ����������ͼ���Ͼ��ǲ���"����һȦ"
                o.uv = wNormal.xy * _Border + 0.5;

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