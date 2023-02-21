Shader "MineselfShader/Basic/8_Shadow/ShadowWithForwardAdd2"
{
    Properties
    {

    }

    CGINCLUDE
    #include "UnityCG.cginc"
    //��������ļ�����ָ��
    #include "Lighting.cginc"//����_LightColor0
    #include "AutoLight.cginc"//��Щ��Ĺؼ�

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
        SHADOW_COORDS(2)
    };

    //������ɫ��---ForwardBase/ForwardAddͨ��
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

    //ƬԪ��ɫ��---ForwardBase
    fixed4 frag (v2f i) : SV_Target
    {
        float3 nDir = normalize(i.wNormal);
        float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
        float3 rlDir = normalize(reflect(-lDir, nDir));
        float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
                
        float3 ambient = unity_AmbientSky;
        float3 diffuse = _LightColor0 * saturate(dot(lDir, nDir));
        float3 specular = _LightColor0 * pow(saturate(dot(rlDir, vDir)), 30);

        //�������˥������Ӱֵ
        UNITY_LIGHT_ATTENUATION(atten, i, i.wPos.xyz);

        float3 finalRGB = ambient + (diffuse + specular) * atten;

        return float4(finalRGB, 1);
    }
    //ƬԪ��ɫ��---ForwardAdd
    fixed4 fragAdd (v2f i) : SV_Target
    {
        float3 nDir = normalize(i.wNormal);
        float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
        float3 rlDir = normalize(reflect(-lDir, nDir));
        float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
                
        float3 diffuse = _LightColor0 * saturate(dot(lDir, nDir));
        float3 specular = _LightColor0 * pow(saturate(dot(rlDir, vDir)), 30);

        //�������˥������Ӱֵ
        UNITY_LIGHT_ATTENUATION(atten, i, i.wPos.xyz);

        //ע�⣡�����������ambient
        float3 finalRGB = (diffuse + specular) * atten;

        return float4(finalRGB, 1);
    }
    ENDCG

    SubShader
    {
        //SubShader Tags
		Tags{}

        //Pass1---ForwardBase
        Pass
        {
            //Pass Tags
            Tags
            {
                //Pass1һ������ForwardBase��������Ҫ��̫�������𶥵�/SH��Դ���д���
                "LightMode"="ForwardBase"
            }
            //��Ⱦ״̬
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //��ӹؼ��֣�����ForwardBase�����·��ĺ�Ҳ�й�
            #pragma multi_compile_fwdbase
            ENDCG
        }
        //Pass2---ForwardAdd
        Pass
        {
            //Pass Tags
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
            //Ҫע������ʹ�õ���CGINCLUDE�е�fragAdd������frag
            #pragma fragment fragAdd
            //����ForwardAdd��˵�������Ҫ���ȫ������ӰЧ���Ļ�
            //��Ҫʹ��fwdadd_fullshadows������fwdadd
            #pragma multi_compile_fwdadd_fullshadows
            ENDCG
        }
    }
    //����Ͷ����Ӱ�ķ�ʽ
    Fallback "Diffuse"
}