Shader "MineselfShader/Basic/8_Shadow/OnlyCastShadow_Test"
{
    Properties
    {
        
    }
    SubShader
    {
        //SubShader Tags
		Tags{}
        //Pass1---����Pass
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
                float3 finalRGB = float3(1,1,1);
                return float4(finalRGB, 1);
            }
            ENDCG
        }
        //Pass2---ShadowCaster
        Pass
        {
            Tags{"LightMode"="ShadowCaster"}
            //��Ⱦ״̬
    
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_shadowcaster
        
            //��������
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
    
            //�������
            struct v2f
            {
                V2F_SHADOW_CASTER;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    //�����Ҫ����Ͷ����Ӱ��Ч���Ļ�:
    //Ҫô��������ShadowCasterPass
    //Ҫô��������Fallback��䣬ֻҪFallback����а���ShadowCasterPass����������ʾ
    Fallback "Diffuse"
}