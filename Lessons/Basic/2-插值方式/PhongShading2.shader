Shader "MineselfShader/Basic/2-InterpolationMethod/PhongShading2"
{
    Properties
    {
        _Gloss("Gloss", Range(0.1, 100)) = 30.0
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
            float _Gloss;
                
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
                float3 wlDir : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
                float3 wvDir : TEXCOORD2;
                float3 wrlDir : TEXCOORD3;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //���������������������Ҫ�õ���������������ϣ�Ȼ��ʹ�ýṹ��������
                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.wlDir = WorldSpaceLightDir(v.vertex);
                o.wrlDir = reflect(-o.wlDir, o.wNormal);
                o.wvDir = WorldSpaceViewDir(v.vertex);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //�����е��������й�һ������
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(i.wlDir);
                float3 rlDir = normalize(i.wrlDir);
                float3 vDir = normalize(i.wvDir);

                //����Phong����ģ��(ȥ������������)
                float diffuse = saturate(dot(lDir, nDir));
                float specular = pow(saturate(dot(vDir, rlDir)), _Gloss);
                
                 //�ϲ����������д��---Swizzle������
                float3 finalRGB = (diffuse + specular).rrr;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}