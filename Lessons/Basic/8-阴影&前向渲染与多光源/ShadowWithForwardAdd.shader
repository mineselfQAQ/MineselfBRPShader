Shader "MineselfShader/Basic/8_Shadow/ShadowWithForwardAdd"
{
    Properties
    {

    }
    SubShader
    {
        //SubShader Tags
		Tags{}

        //Pass1---ForwardBase
        Pass
        {
            Tags
            {
                //Pass1һ������ForwardBase��������Ҫ��̫�������𶥵�/SH��Դ���д���
                "LightMode"="ForwardBase"
            }
            //��Ⱦ״̬
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"//����_LightColor0
            #include "AutoLight.cginc"//��Щ��Ĺؼ�
            //��ӹؼ��֣�����ForwardBase�����·��ĺ�Ҳ�й�
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

                //����_ShadowCoord��ʹ��TEXCOORDx���壬���Բ����ظ�
                SHADOW_COORDS(2)//ע��:û�зֺ�
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                //�ռ�ת��
                TRANSFER_SHADOW(o);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = normalize(reflect(-lDir, nDir));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
                
                float3 ambient = unity_AmbientSky;
                float3 diffuse = _LightColor0 * saturate(dot(lDir, nDir));
                float3 specular = _LightColor0 * pow(saturate(dot(rlDir, vDir)), 30);

                //������Ӱֵ
                float shadow = SHADOW_ATTENUATION(i);

                float3 finalRGB = ambient + (diffuse + specular) * shadow;

                return float4(finalRGB, 1);
            }
            ENDCG
        }

        //Pass2---ForwardAdd
        Pass
        {
            Tags
            {
                //Pass2һ������ForwardAdd��������Ҫ�Գ���̫��������������ع�Դ���д���
                "LightMode"="ForwardAdd"
            }
            //��Ⱦ״̬
            //ע����Ҫ��Pass1���л�ϣ�������Blend����
            Blend One One
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //ͬPass1
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            //����ForwardAdd��˵�������Ҫ���ȫ������ӰЧ���Ļ�
            //��Ҫʹ��fwdadd_fullshadows������fwdadd
            #pragma multi_compile_fwdadd_fullshadows
			
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
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = normalize(reflect(-lDir, nDir));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
                
                float3 ambient = unity_AmbientSky;
                float3 diffuse = _LightColor0 * saturate(dot(lDir, nDir));
                float3 specular = _LightColor0 * pow(saturate(dot(rlDir, vDir)), 30);

                //�������˥��
                #ifdef USING_DIRECTIONAL_LIGHT
					fixed atten = 1.0;
				#else
					#if defined (POINT)
				        float3 lightCoord = mul(unity_WorldToLight, i.wPos).xyz;
				        fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
				    #elif defined (SPOT)
				        float4 lightCoord = mul(unity_WorldToLight, i.wPos);
				        fixed atten = (lightCoord.z > 0) *
                        tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * 
                        tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
				    #else
				        fixed atten = 1.0;
				    #endif
				#endif

                //ע�⣡�����������ambient
                float3 finalRGB = (diffuse + specular) * atten;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    //����Ͷ����Ӱ�ķ�ʽ
    Fallback "Diffuse"
}