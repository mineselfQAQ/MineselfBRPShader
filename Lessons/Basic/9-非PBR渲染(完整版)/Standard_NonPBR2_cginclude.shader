Shader "MineselfShader/Basic/9-NonPBRRendering2/Standard_NonPBR2_cginclude"
{
    Properties
    {
        [Header(Common)][Space(5)]
        _FinalInt("FinalIntensity", Range(0, 2)) = 1

        [Header(Texture)][Space(5)]
        _MainTex("MainTexture", 2D) = "white"{}
        [NoScaleOffset]_Cubemap("Cubemap", CUBE) = ""{}
        _CubemapMipmap("CubemapMipmap", Range(0, 8)) = 2
        [NoScaleOffset]_AO("AO", 2D) = "white"{}
        [NoScaleOffset]_RoughnessTex("Roughness", 2D) = "white"{}
        [Header(NewTexture)]
        [Normal][NoScaleOffset]_NormalMap("NormalMap", 2D) = "bump"{}
        _BumpScale("BumpScale", Range(0, 3)) = 1
        
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

    CGINCLUDE
        
    #include "UnityCG.cginc"
    //��������ļ�����ָ��
    #include "Lighting.cginc"
    #include "AutoLight.cginc"

    //��������
    float _FinalInt;

    sampler2D _MainTex; float4 _MainTex_ST;
    samplerCUBE _Cubemap;
    float _CubemapMipmap;
    sampler2D _AO;
    sampler2D _RoughnessTex;
    sampler2D _NormalMap;
    float _BumpScale;

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
        float4 tangent : TANGENT;
    };
			
    //�������
    struct v2f
    {
        float4 pos : SV_POSITION;
        float2 uv : TEXCOORD0;
        float3 wNormal : TEXCOORD1;
        float4 wPos : TEXCOORD2;
        float3x3 tbn : TEXCOORD3;
        SHADOW_COORDS(6)
    };

    //������ɫ��---ͨ��
    v2f vert (appdata v)
    {
        v2f o;
        o.pos = UnityObjectToClipPos(v.vertex);

        o.uv = TRANSFORM_TEX(v.uv, _MainTex);
        o.wPos = mul(unity_ObjectToWorld, v.vertex);

        float3 wNormal = UnityObjectToWorldNormal(v.normal);
        float3 wTangent = UnityObjectToWorldDir(v.tangent.xyz);
        float3 wBitangent = cross(wNormal, wTangent) * v.tangent.w * unity_WorldTransformParams.w;
        o.tbn = float3x3(wTangent, wBitangent, wNormal);
        o.wNormal = wNormal;

        TRANSFER_SHADOW(o);

        return o;
    }
    //ƬԪ��ɫ��---ForwardBase
    fixed4 frag (v2f i) : SV_Target
    {
        //����ͨ��������ͼ��õķ�������
        float3 localNormal = UnpackNormal(tex2D(_NormalMap, i.uv));
        localNormal.xy *= _BumpScale;
        float3 nDir = normalize(mul(localNormal, i.tbn));

        //�����������
        float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
        float3 rlDir = normalize(reflect(-lDir, nDir));
        float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
        float3 rvDir = normalize(reflect(-vDir, nDir));

        //������ͼ
        float3 mainTex = tex2D(_MainTex, i.uv);
        float3 cubemap = texCUBElod(_Cubemap, float4(rvDir, _CubemapMipmap));
        float roughnessTex = tex2D(_RoughnessTex, i.uv);


        //����������AO����---����������
        float ao = tex2D(_AO, i.uv);
        float3 n = normalize(i.wNormal);
        float upMask = saturate(n.y);
        float bottomMask = saturate(-n.y);
        float sideMask = 1 - upMask - bottomMask;
        float3 finalAO = (upMask * unity_AmbientSky +
                            sideMask * unity_AmbientEquator +
                            bottomMask * unity_AmbientGround) * ao;//����������

        //�������Ļ�������
        float diffuse = saturate(dot(lDir, nDir));//��Դ������
        float specular = pow(saturate(dot(rlDir, vDir)), _Gloss);//��Դ�߹ⷴ��
        float3 fresnel = _R0 + (1 - _R0) * pow(1 - saturate(dot(vDir, nDir)), _FresnelPow) * _FresnelInt;//�����߹ⷴ�����Ҫ����

        //�������˥������Ӱ
        UNITY_LIGHT_ATTENUATION(atten, i, i.wPos.xyz);

        //�ĸ�������ɲ���
        float3 dirDiff = _LightColor0 * mainTex * diffuse * _DiffInt * _DiffCol * atten;
        float3 indirDiff = mainTex * finalAO * _AmbiInt;
        float3 dirSpec = _LightColor0 * specular * _SpecInt * _SpecCol * roughnessTex * atten;
        float3 indirSpec = cubemap * roughnessTex * finalAO;

        //�ϲ���ͨ��fresnel��������ʹ��dirDiff����indirSpec��ʹ�����ַ�ʽ��ӻ����߹ⷴ��
        float3 finalRGB = indirDiff + dirSpec + lerp(dirDiff, indirSpec, fresnel);
        finalRGB *= _FinalInt;

        return float4(finalRGB, 1);
    }
    //ƬԪ��ɫ��---ForwardAdd
    fixed4 fragAdd (v2f i) : SV_Target
    {
        //����ͨ��������ͼ��õķ�������
        float3 localNormal = UnpackNormal(tex2D(_NormalMap, i.uv));
        localNormal.xy *= _BumpScale;
        float3 nDir = normalize(mul(localNormal, i.tbn));

        //�����������
        float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
        float3 rlDir = normalize(reflect(-lDir, nDir));
        float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
        float3 rvDir = normalize(reflect(-vDir, nDir));

        //������ͼ
        float3 mainTex = tex2D(_MainTex, i.uv);
        float roughnessTex = tex2D(_RoughnessTex, i.uv);

        //�������Ļ�������
        float diffuse = saturate(dot(lDir, nDir));//��Դ������
        float specular = pow(saturate(dot(rlDir, vDir)), _Gloss);//��Դ�߹ⷴ��

        //�������˥������Ӱ
        UNITY_LIGHT_ATTENUATION(atten, i, i.wPos.xyz);

        //���յĹ�Դ����
        float3 dirDiff = _LightColor0 * mainTex * diffuse * _DiffInt * _DiffCol * atten;
        float3 dirSpec = _LightColor0 * specular * _SpecInt * _SpecCol * roughnessTex * atten;

        //�ϲ���ͨ��fresnel��������ʹ��dirDiff����indirSpec��ʹ�����ַ�ʽ��ӻ����߹ⷴ��
        float3 finalRGB = dirDiff + dirSpec;
        finalRGB *= _FinalInt;

        return float4(finalRGB, 1);
    }
    ENDCG

    SubShader
    {
        //Pass1---ForwardBase
        Pass
        {
            //Pass Tags
            Tags
            {
                "LightMode"="ForwardBase"
            }
            //��Ⱦ״̬
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            ENDCG
        }
        //Pass2---ForwardAdd
        Pass
        {
            //Pass Tags
            Tags
            {
                "LightMode"="ForwardAdd"
            }
            //��Ⱦ״̬
            Blend One One
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment fragAdd
            #pragma multi_compile_fwdadd_fullshadows
            ENDCG
        }
    }
    Fallback "Diffuse"
}