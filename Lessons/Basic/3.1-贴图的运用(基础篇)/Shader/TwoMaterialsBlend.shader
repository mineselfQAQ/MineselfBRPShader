Shader "MineselfShader/Basic/3-Texture/TwoMaterialsBlend"
{
    Properties
    {
        [Header(Noise)] [Space(5)]
        _NoiseTex("NoiseTexture", 2D) = "white"{}
        _NoiseInt("0:Main 1:Noise", Range(0, 1)) = 1
        [Header(Diffuse)] [Space(5)]
        _MainColor("MainColor", COLOR) = (1,1,1,1)
        _NoiseColor("NoiseColor", COLOR) = (1,1,1,1)
        [Header(Specular)] [Space(5)]
        _MainGloss("MainGloss", Range(0.1, 100)) = 30
        _NoiseGloss("NoiseGloss", Range(0.1, 100)) = 30
        _MainSpecInt("MainSpecularIntensity", Range(0, 1)) = 1
        _NoiseSpecInt("NoiseSpecularIntensity", Range(0, 1)) = 1
        [Header(Fresnel)] [Space(5)]
        _FresnelCol("FresnelColor", COLOR) = (1,1,1,1)
        _FresnelPow("FresnelPower", Range(1, 10)) = 3
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
            sampler2D _NoiseTex; float4 _NoiseTex_ST;
            float _NoiseInt;
            fixed4 _MainColor;
            fixed4 _NoiseColor;
            float _MainGloss;
            float _NoiseGloss;
            float _MainSpecInt;
            float _NoiseSpecInt;
            fixed4 _FresnelCol;
            float _FresnelPow;
                
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

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                //ʹTiling��Offset����
                o.uv = TRANSFORM_TEX(v.uv, _NoiseTex);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = normalize(reflect(-lDir, nDir));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                //�����Լ�����Mask������Mask����һ�ŷǺڼ��׵���ͼ
                //ע�⣺maskֻ��һ������ͼ�������¼����"ֵ"��������1D��
                float noiseMask = tex2D(_NoiseTex, i.uv);
                noiseMask = step(_NoiseInt, noiseMask);

                //��������Ҫʹ��mask���Ʊ������д���---���
                //����˵��gloss������noiseMaskΪ0��ʱ��ʹ��������glossֵ��Ϊ1��ʱ��ʹ�ñ�����glossֵ
                float3 diffCol = lerp(_NoiseColor, _MainColor, noiseMask);
                float gloss = lerp(_NoiseGloss, _MainGloss, noiseMask);
                float specInt = lerp(_NoiseSpecInt, _MainSpecInt, noiseMask);

                //���ռ���
                //ע��һ�㣺ambient����Ҫ����diffCol�ģ���Ȼ���������ڵ�
                float3 ambient =  unity_AmbientSky;
                float3 diffuse = diffCol * saturate(dot(nDir, lDir));
                float3 specular = specInt * pow(saturate(dot(rlDir, vDir)), gloss);
                float3 fresnel = _FresnelCol * pow(1 - saturate(dot(vDir, nDir)), _FresnelPow);

                float3 finalRGB = ambient + diffuse + specular + fresnel;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}
