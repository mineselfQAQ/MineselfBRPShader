//Phong���ǻ���������+Lambert������+Phong�߹ⷴ��
Shader "MineselfShader/Basic/1-BasicLightingModel/Phong"
{
    Properties
    {
        [Header(Switch)][Space(5)]
        [IntRange]_AmbSwitch("AmbientSwitch", Range(0, 1)) = 1
        [IntRange]_DiffSwitch("DiffuseSwitch", Range(0, 1)) = 1
        [IntRange]_SpecSwitch("SpecularSwitch", Range(0, 1)) = 1

        [Header(Ambient)][Space(5)]
        _AmbCol("AmbientColor", COLOR) = (1,1,1,1)
        _AmbInt("AmbientIntensity", Range(0, 3)) = 1

        [Header(Diffuse)][Space(5)]
        _DiffCol("DiffuseColor", COLOR) = (1,1,1,1)
        _DiffInt("DiffuseIntensity", Range(0, 3)) = 1

        [Header(Specular)][Space(5)]
        _SpecCol("SpecularColor", COLOR) = (1,1,1,1)
        _SpecInt("SpecularIntensity", Range(0, 3)) = 1
        _Gloss("Gloss", Range(0.1, 100)) = 30

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
            //2.��������Ҫ��Ӧ���������������д���ֱ�Ӹ��ƹ�����֤��ȷ�ԣ�����ʹ����������
            float _AmbSwitch;
            float _DiffSwitch;
            float _SpecSwitch;

            fixed4 _AmbCol;
            float _AmbInt;

            fixed4 _DiffCol;
            float _DiffInt;

            fixed4 _SpecCol;
            float _SpecInt;
            float _Gloss;
                
			//��������
            struct appdata
            {
                //��4D�ģ����˲²⣺��д��������������ʽ������w�������1��������һ��λ��
                //��Ȼ��������Ϊ3D�����Ǿ����õ���4x4����ô�Ͳ�������
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
                float3 rlDir = reflect(-lDir, nDir);//ע��:����nDir/lDir�Ѿ����й�һ�����������ﲻ��Ҫ�ڽ��в���������Ϊ���Է���һ�������Ҳ�ǿ��Ե�
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));//ʹ�ú������л�ù�������

                //���ռ���
                //===������������===
                //���Ǽ򵥵���ɫֵ
                float3 ambientRGB = unity_AmbientSky * _AmbCol * _AmbInt;

                //===Lambert��Դ��������===
                //���ľ���lDir��nDir����ȡֵ��ΧΪ[-1,1]������ʹ��saturate()������[0,1]
                float diffuse = saturate(dot(lDir, nDir));
                float3 diffuseRGB = _LightColor0 * _DiffCol * _DiffInt * diffuse;//�Ҳ౾Ӧ����4D����������ֻ��Ҫ��ȡ3D������a---͸���ȣ�ʹ��1����

                //===Phong�߹ⷴ����===
                //���ľ���rlDir��vDir��pow()����"�����߹ⷶΧ"
                float specular = pow(saturate(dot(rlDir, vDir)), _Gloss);
                float3 specularRGB = _LightColor0 * _SpecCol * _SpecInt * specular;

                //�ϲ����  ʹ��0/1ֵ���п��ؿ���
                float3 finalRGB = _AmbSwitch * ambientRGB + _DiffSwitch * diffuseRGB + _SpecSwitch * specularRGB;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}