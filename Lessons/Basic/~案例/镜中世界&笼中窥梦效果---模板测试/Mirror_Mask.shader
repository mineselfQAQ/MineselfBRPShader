Shader "MineselfShader/Basic/Instance/Mirror/Mirror_Mask"
{
    Properties
    {
        [IntRange]_ID("ID", Range(0, 255)) = 1
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            //�ų������������壬������˵��������������(����2000)֮����Ⱦ�����ǻ��ھ�������(����2002)֮ǰ��Ⱦ
            "Queue" = "Geometry+1"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //��Ⱦ״̬
            Stencil
            {
                //Ϊ������ͨ�������֣�Refֵ����0��������1-255������һ��ֵ
                //����һ��Ҫ��Mirror_Object�е�Refֵһ��---��Ϊ��Mirror_Object�ıȽϷ�ʽΪComp Equal
                Ref[_ID]
                //������ͨ��ģ�����ʱ���Ὣ��Щͨ����ƬԪ��Refֵд��ģ�建����
                //�����ھ�������(����2002)��Ⱦ��ǰRefֵ�Ѿ������÷�0ֵ��
                //�ھ����������Ⱦͨ���ڲ�Comp Equal��ʹ���Ӻ������ͨ��ģ����ԴӶ���Ⱦ��������û��ͨ����ƬԪ�Ϳ�������������
                Pass Replace
            }

            //�����ڴ˴����д�룬��ᵼ�º�������屻�ڵ�
            ZWrite Off
            //�����ڴ˴������ɫ������ֻ��һ������Mask
            ColorMask 0

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            
                
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
                //�����������Ϊ�Ѿ�ͨ��ColorMask 0ʹ���������ͨ��
                float3 finalRGB = float3(1,1,1);
                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}