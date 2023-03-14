Shader "MineselfShader/Basic/13-NormalBlend&NormalAtlas/NormalAtlas"
{
    Properties
    {
        _NormalTexArray("MainNormalTexture", 2DArray) = ""{}
        _NormalMask("NormalMask", 2D) = "white"{}
        _MainSacle("MainScale", Range(0.1, 10)) = 1
        _TexScale("TexScale", Range(0.1, 10)) = 1

        _Gloss("Gloss", Range(1, 100)) = 30
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
            #pragma require 2darray
			
            //��������
            UNITY_DECLARE_TEX2DARRAY(_NormalTexArray);
            sampler2D _NormalMask;
            float _MainSacle;
            float _TexScale;
            float _Gloss;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float4 tangent : TANGENT;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3x3 tbn : TEXCOORD0;
                float2 uv : TEXCOORD3;
                float4 wPos : TEXCOORD4;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                float3 t = UnityObjectToWorldDir(v.tangent);
                float3 n = UnityObjectToWorldNormal(v.normal);
                float3 b = cross(n, t) * v.tangent.w * unity_WorldTransformParams.w;
                o.tbn = float3x3(t, b, n);

                o.uv = v.uv * _MainSacle;

                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //�������ֲ���������
                //����Ϊ�����ÿһ����������Ӧ������
                //ͨ���������в���������������ķ�����ͼһ��---�Ƚ����Ȼ��ת������ռ�
                float mask = tex2D(_NormalMask, i.uv);
                float index = floor(mask * 4);
                float3 normalTexArray = UnpackNormal(UNITY_SAMPLE_TEX2DARRAY(_NormalTexArray, float3(i.uv * _TexScale, index)));
                float3 finalNormal = normalize(mul(normalTexArray, i.tbn));
                
                //������������
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = normalize(reflect(-lDir, finalNormal));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                //���ռ���
                float3 ambient = unity_AmbientSky;
                float diffuse = saturate(dot(lDir, finalNormal));
                float specular = pow(saturate(dot(rlDir, vDir)), _Gloss);

                float3 finalRGB = ambient + diffuse + specular;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}