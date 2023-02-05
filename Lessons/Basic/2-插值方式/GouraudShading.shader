Shader "MineselfShader/Basic/2-InterpolationMethod/GouraudShading"
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
                float4 color : COLOR;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //�����������    
                float3 nDir = normalize(UnityObjectToWorldNormal(v.normal));
                float3 lDir = normalize(WorldSpaceLightDir(v.vertex));
                float3 rlDir = normalize(reflect(-lDir, nDir));
                float3 vDir = normalize(WorldSpaceViewDir(v.vertex));

                //����Phong����ģ��(ȥ������������)
                float diffuse = saturate(dot(lDir, nDir));
                float specular = pow(saturate(dot(rlDir, vDir)), _Gloss);

                //ͨ��o.color���ݶ��������Ϣ         ����д��---Swizzle������
                o.color = float4((diffuse + specular).rrr, 1);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //�����ǴӶ�����ɫ���м���õĹ���ģ�ͣ������𶥵㼶��ģ�Ҳ����ÿ�����������Լ�������
                //���ջ�ͨ����ֵ�ķ�ʽ������ɫ��Ϣ�Ӷ�����ɫ�����ݵ�ƬԪ��ɫ��
                return i.color;
            }
            ENDCG
        }
    }
    Fallback Off
}