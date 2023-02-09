Shader "MineselfShader/Basic/Instance/XRay"
{
    Properties
    {
        _Color("Color", COLOR) = (1,1,1,1)
        _FresnelColor("FresnelColor", COLOR) = (1,1,1,1)
        _FresnelPow("FresnelPower", Range(0,10)) = 3
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            //�ؼ���2001���б�Ĭ�ϵ�2000��˵��ʹ�ø�Shader�����嶼�ǻ��Ĭ�ϵ�����������Ⱦ
            //������˵����û��ʲô���𣬵��ǽ���������һ��������Ⱦ����������˼��
            "Queue"="Geometry+1"
        }

        //Pass1---���ڵ����֣�ʹ��Fresnel
        Pass
        {
            //Pass Tags
            Tags{}
            //��Ⱦ״̬
            //XRay�ĺ��ģ�
            //ZWrite Off������Ӱ�����Ĳ���(Pass2)
            //ZTest Greater����ֻ��Ⱦ���ڵ�����
            ZWrite Off
            ZTest Greater

            //���Ǹ�Shader�ĺ��ģ����ģʽ---ʹ������԰�͸������������Blend��ʽ��Ҫͨ��Aͨ���޸�
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            fixed4 _FresnelColor;
            float _FresnelPow;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 wNormal : TEXCOORD0;
                float4 wPos : TEXCOORD1;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                float fresnel = pow(1 - saturate(dot(vDir, nDir)), _FresnelPow);

                float3 finalRGB = fresnel * _FresnelColor;
                float alpha = fresnel;

                return float4(finalRGB, fresnel);
            }
            ENDCG
        }

        //Pass2---δ���ڵ����֣�ʹ�õ�һ��ɫ
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
                return _Color;
            }
            ENDCG
        }
    }
    Fallback Off
}