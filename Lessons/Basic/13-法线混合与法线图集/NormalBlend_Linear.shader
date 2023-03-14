Shader "MineselfShader/Basic/13-NormalBlend&NormalAtlas/NormalBlend/Linear"
{
    Properties
    {
        [Normal]_MainNormalTex("MainNormalTexture", 2D) = "bump"{}
        [Normal]_SecondNormalTex("SecondNormalTexture", 2D) = "bump"{}
        _MainSacle("MainScale", Range(0.1, 10)) = 1
        _SecondSacle("SecondSacle", Range(0.1, 10)) = 5

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
            #include "Lighting.cginc"
			
            //��������
            sampler2D _MainNormalTex;
            sampler2D _SecondNormalTex;
            float _MainSacle;
            float _SecondSacle;
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

                o.uv = v.uv;

                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //ʹ�û�ϼ��������
                float3 mainUnpackNormal = UnpackNormal(tex2D(_MainNormalTex, i.uv * _MainSacle));
                float3 secondUnpackNormal = UnpackNormal(tex2D(_SecondNormalTex, i.uv * _SecondSacle));
                float3 blendNormal = mainUnpackNormal + secondUnpackNormal;//���Ի�ϣ�ֱ�ӽ��������
                float3 finalNormal = normalize(mul(blendNormal, i.tbn));

                //������������
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = normalize(reflect(-lDir, finalNormal));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                //���ռ���
                //_LightColor0��ü��ϣ�ԭ��
                //û��Albedo����������׳��ֹ��أ�����ʹ��_LightColor0����̫�����ǿ�ȷ�ֹ����
                float3 ambient = unity_AmbientSky;
                float diffuse = _LightColor0 * saturate(dot(lDir, finalNormal));
                float specular = _LightColor0 * pow(saturate(dot(rlDir, vDir)), _Gloss);

                float3 finalRGB = ambient + diffuse + specular;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}