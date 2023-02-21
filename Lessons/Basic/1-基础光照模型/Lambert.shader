//Lambert����˵��һ�ֹ���ģ�ͣ�����˵��Phong����ģ������ɵ�һ����
Shader "MineselfShader/Basic/1-BasicLightingModel/Lambert"
{
    Properties
    {
        [Header(Diffuse)][Space(5)]
        _DiffCol("DiffuseColor", COLOR) = (1,1,1,1)
        _DiffInt("DiffuseIntensity", Range(0, 3)) = 1
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
            #include "Lighting.cginc"
			
            //��������
            //ע���:
            //1.��ɫ����ά�ģ�һ����fixed4
            //2.��������Ҫ��Ӧ���������������д���ֱ�Ӹ��ƹ�����֤��ȷ��
            fixed4 _DiffCol;
            float _DiffInt;
                
			//��������
            struct appdata
            {
                //��4D�ģ����˲²⣺��д��������������ʽ������w�������1��������һ��λ��
                //��Ȼ��������Ϊ3D�����Ǿ����õ���4x4����ô�Ͳ�������(�������������)
                float4 vertex : POSITION;

                float3 normal : NORMAL;//�����������ǻ��ڷ��ߵ�---nDir��lDir��������Ҫ����
            };
			
            //�������
            struct v2f
            {
                //��ʱ���һ����4D�ģ���Ϊ����һ������MVP����ı任��λ����Ϣ��w��һ����ֵ�ģ�����˵����"���ֵ"
                float4 pos : SV_POSITION;

                //����ѡ��������ռ��¼���
                //Ҫע��ľ��ǣ����е����ݶ�Ӧ����ͬһ�ռ�
                //���磺nDir������ռ䣬��ôlDir��һ��Ҫת��������ռ���ܽ��м���
                float4 wPos : TEXCOORD0;//ʹ��4D������һ��ԭ����unity_ObjectToWorld��4x4����
                float3 wNormal : TEXCOORD1;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //��������Ϣ---����/���ߣ�ת��������ռ��У������������ṹ�����մ���ƬԪ��ɫ��
                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);//ע��:��Ҫnormalize()����ƬԪ��ɫ�����ٽ��У�����ᱻ��ֵ�ƻ�"��һֵ"

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //��������
                float3 nDir = normalize(i.wNormal);//ֱ���ù�����һ������
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));//ʹ�ú������л�ù�������

                //���ռ���
                //����ֻ���������ʹ�õ���Lambert
                //���ľ���lDir��nDir����ȡֵ��ΧΪ[-1,1]������ʹ��saturate()������[0,1]
                float diffuse = saturate(dot(lDir, nDir));
                float3 diffuseRGB = _LightColor0 * _DiffCol * _DiffInt * diffuse;//�Ҳ౾Ӧ����4D����������ֻ��Ҫ��ȡ3D������a---͸���ȣ�ʹ��1����

                float3 finalRGB = diffuseRGB;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}