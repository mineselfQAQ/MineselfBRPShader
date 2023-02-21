Shader "MineselfShader/Basic/5-NonPBRRendering1/Standard_NonPBR1"
{
    Properties
    {
        [Header(Texture)][Space(5)]
        _MainTex("MainTexture", 2D) = "white"{}
        [NoScaleOffset]_Cubemap("Cubemap", CUBE) = ""{}
        _CubemapMipmap("CubemapMipmap", Range(0, 8)) = 2
        [NoScaleOffset]_AO("AO", 2D) = "white"{}
        [NoScaleOffset]_RoughnessTex("Roughness", 2D) = "white"{}
        
        [Space(10)]
        [Header(Diffuse)][Space(5)]
        _DiffInt("DiffuseIntensity", Range(0, 3)) = 1
        _DiffCol("DiffuseColor", COLOR) = (1,1,1,1)
        
        [Space(10)]
        [Header(Specular)][Space(5)]
        [PowerSlider(3.0)]_Gloss("Gloss", Range(1, 200)) = 30
        _SpecInt("SpecularIntensity", Range(0, 3)) = 1
        _SpecCol("SpecularColor", COLOR) = (1,1,1,1)
        
        [Space(10)]
        [Header(Fresnel)][Space(5)]
        _R0("R0", vector) = (0.04,0.04,0.04,0)
        _FresnelPow("FresnelPower", Range(1, 10)) = 3
        _FresnelInt("FresnelIntensity", Range(0, 3)) = 1

        [Space(10)]
        [Header(Ambient)][Space(5)]
        _AmbiInt("AmbientIntensity", Range(0, 5)) = 1
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
            sampler2D _MainTex; float4 _MainTex_ST;
            samplerCUBE _Cubemap;
            float _CubemapMipmap;
            sampler2D _AO;
            sampler2D _RoughnessTex;

            float _DiffInt;
            fixed4 _DiffCol;

            float _Gloss;
            float _SpecInt;
            fixed4 _SpecCol;

            float3 _R0;
            float _FresnelPow;
            float _FresnelInt;

            float _AmbiInt;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
                float4 wPos : TEXCOORD2;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
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
                float3 rlDir = normalize(reflect(-lDir, nDir));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
                float3 rvDir = normalize(reflect(-vDir, nDir));

                //������ͼ
                float3 mainTex = tex2D(_MainTex, i.uv);
                float3 cubemap = texCUBElod(_Cubemap, float4(rvDir, _CubemapMipmap));
                float3 ao = tex2D(_AO, i.uv);
                float3 roughnessTex = tex2D(_RoughnessTex, i.uv);

                //�������Ļ�������
                float3 ambient = unity_AmbientSky;//����������
                float diffuse = saturate(dot(lDir, nDir));//��Դ������
                float specular = pow(saturate(dot(rlDir, vDir)), _Gloss);//��Դ�߹ⷴ��
                float3 fresnel = _R0 + (1 - _R0) * pow(1 - saturate(dot(vDir, nDir)), _FresnelPow) * _FresnelInt;//�����߹ⷴ�����Ҫ����

                //�ĸ�������ɲ���
                float3 dirDiff = _LightColor0 * mainTex * diffuse * _DiffInt * _DiffCol;
                float3 indirDiff = mainTex * ambient * ao * _AmbiInt;
                float3 dirSpec = _LightColor0 * specular * _SpecInt * _SpecCol * roughnessTex;
                float3 indirSpec = cubemap * roughnessTex * ao;

                //�ϲ���ͨ��fresnel��������ʹ��dirDiff����indirSpec��ʹ�����ַ�ʽ��ӻ����߹ⷴ��
                float3 finalRGB = indirDiff + dirSpec + lerp(dirDiff, indirSpec, fresnel);

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}