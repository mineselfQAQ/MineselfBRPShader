Shader "MineselfShader/Basic/Instance/Mirror/Mirror_Object"
{
    Properties
    {
        [IntRange]_ID("ID", Range(0, 255)) = 1
        _Color("Color", COLOR) = (1,1,1,1)
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            //�ų������������壬�����һ����Ⱦ�����壬������(����2001)����Ⱦ
            "Queue" = "Geometry+2"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //��Ⱦ״̬
            Stencil
            {
                //Ϊ������ͨ�������֣�Refֵ����0��������1-255������һ��ֵ
                //����һ��Ҫ��Mirror_Mask�е�Refֵһ��
                Ref[_ID]
                //�������õıȽϷ�ʽΪ���ڣ���ô���ֺ;��������Refֵ��һ�µ�(���������ȷ)��
                //���մ�����������������ֺ�ľ���������ܿ������������������Ϳ�������������
                Comp Equal
            }
            
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
                //��������ȡ������Ҫ��Ч��
                //�����ҪPhong����ģ�ͣ���ô���������
                //����ѡ����򵥵������ɫ
                return _Color;
            }
            ENDCG
        }
    }
    Fallback Off
}