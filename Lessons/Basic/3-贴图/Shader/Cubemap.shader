Shader "MineselfShader/Basic/3-Texture/Cubemap"
{
    //ע��һ�£���ĳ��д��"_Skybox"����������ʵд��д��һ����ֻ��Ĭ��ֵ��ɫ
    Properties
    {
        _Cubemap("Cubemap", Cube) = ""{}
        [KeywordEnum(Reflect, Refract)]_Mode("Mode", Float) = 0
        [Toggle]_FresnelSwitch("WithFresnel", Float) = 0
        [Space(10)]
        _CubemapMip("CubemapMipmap", Range(0, 8)) = 0
        _ReflectRatio("(Refract)ReflectRatio", Range(0.1, 1)) = 1
        _R0("(Fresnel)R0", vector) = (1,1,1,0)
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
            #pragma shader_feature _FRESNELSWITCH_ON
            #pragma shader_feature _MODE_REFLECT _MODE_REFRACT
			
            //��������
            samplerCUBE _Cubemap;//ע����CUBE����д��2D��
            float _CubemapMip;
            float _ReflectRatio;
            float3 _R0;
                
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
                float3 wNormal : TEXCOORD0;
                float4 wPos : TEXCOORD1;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //�����������
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

              #if _MODE_REFLECT
                float3 rvDir = normalize(reflect(-vDir, nDir));
                //ʹ��texCUBElod()���������"�����߹ⷴ��"
                //����texCUBE()��˵����tex2D()��һ������Ҫ�Ĳ���uv������һ��������������"�۾����յ����Ժδ��Ļ���"
                //����lod�ĺ���ͨ�Ĳ�һ������w��������Ҫ����LOD---Level of detail
                //texCUBElod()���4D��ֻ������ֻ��3D���ɣ�ʵ�鷢��w�������ܾ���1
                float3 cubemap = texCUBElod(_Cubemap, float4(rvDir, _CubemapMip));

                //ͬ������ʹ��texCUBE()�����ַ�ʽ�Դ�"�仯��mipmap"
                //float3 cubemap = texCUBE(_Cubemap, rvDir);
              #elif _MODE_REFRACT
                //����������˵���ͷ���ʹ�õ�texCUBElod()һ�£�ֻ��������Ҫ��������������������Ƿ�������
                float3 rvDir = normalize(refract(-vDir, nDir, _ReflectRatio));
                float3 cubemap = texCUBElod(_Cubemap, float4(rvDir, _CubemapMip));

                //ͬ������ʹ��texCUBE()�����ַ�ʽ�Դ�"�仯��mipmap"
                //float3 cubemap = texCUBE(_Cubemap, rvDir);
              #endif

                float3 finalRGB = cubemap;

              #if _FRESNELSWITCH_ON
                float3 diffuse = saturate(dot(lDir, nDir));
                float3 fresnel = _R0 + (1 - _R0) * pow(1 - saturate(dot(nDir, vDir)), 5);
                finalRGB = lerp(diffuse, cubemap, saturate(fresnel));
              #endif

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}