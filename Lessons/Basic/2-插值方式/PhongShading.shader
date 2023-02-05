Shader "MineselfShader/Basic/2-InterpolationMethod/PhongShading"
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
                float4 wPos : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //�ڶ�����ɫ�����Ȼ������λ����Ϣ�����編����Ϣ ������ƬԪ��ɫ��ʹ��
                //��ʱ��ʵֻ��ȡ�˷���
                //��ƬԪ��ɫ�����з���ĺ�������ͨ��wPos����ȡĳЩ����
                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //�����������
                //Ҫע����ǣ���������ƬԪ��ɫ�����㣬������Щ����������ƬԪ����ģ�Ҳ����ÿ��ƬԪ���������Լ�������
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = normalize(reflect(-lDir, nDir));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

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