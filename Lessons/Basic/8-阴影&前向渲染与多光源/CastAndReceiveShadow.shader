Shader "MineselfShader/Basic/8_Shadow/CastAndReceiveShadow"
{
    Properties
    {

    }
    SubShader
    {
        //SubShader Tags
		Tags{}
        Pass
        {
            //Pass Tags
            Tags
            {
            //ǰ����Ⱦ·��---����Pass��һ����˵����ʹ�����
            "LightMode"="ForwardBase"
            }
            //��Ⱦ״̬
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��
            #include "AutoLight.cginc"//���º궼ʹ�õ���
            //��ǰ����Ⱦ·������pass���׵Ĺؼ���
            #pragma multi_compile_fwdbase
			
            //��������
                
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
                //����һ�����ڶ���Ӱ�������������
                SHADOW_COORDS(2)
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                //�ڶ�����ɫ���м�����Ӱ��������
                TRANSFER_SHADOW(o);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = reflect(-lDir, nDir);
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                float3 ambient = unity_AmbientSky;
                float diffuse = saturate(dot(lDir, nDir));
                float specular = pow(saturate(dot(rlDir, vDir)), 30);

                //������Ӱֵ
                float shadow = SHADOW_ATTENUATION(i);

                //�����Ӱֵ����finalRGB
                float3 finalRGB = ambient + (diffuse + specular) * shadow;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    //ʹ��Fallback���ѡ��DiffuseΪ����Shader���Զ�����Ͷ����Ӱ
    Fallback "Diffuse"
}