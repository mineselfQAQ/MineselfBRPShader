Shader "MineselfShader/Basic/3-Texture/NormalMap_WorldSpace"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        //����һ��ʹ��"bump"
        [Normal][NoScaleOffset]_NormalTex("NormalTexture", 2D) = "bump"{}
        _BumpScale("BumpScale",Range(-2, 2)) = 1.0
        _Gloss("Gloss", Range(0, 100)) = 30
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
            sampler2D _MainTex; float4 _MainTex_ST;
            sampler2D _NormalTex;
            float _BumpScale;
            float _Gloss;
                
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
                float3 wPos : TEXCOORD1;
                float3x3 tbn : TEXCOORD2;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                //tbn�������
                float3 wNormal = UnityObjectToWorldNormal(v.normal);
                float3 wTangent = UnityObjectToWorldDir(v.tangent.xyz);
                //wTangent����һ��д����ʹ�þ������
                //float3 wTangent = mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0));
                float3 wBitangent = cross(wNormal, wTangent) * v.tangent.w * unity_WorldTransformParams.w;

                //���tbn����
                o.tbn = float3x3(wTangent, wBitangent, wNormal);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //�ӷ�����ͼ�л�ȡ���߿ռ䷨������
                float3 localNormal = UnpackNormal(tex2D(_NormalTex, i.uv));
                //���ķ���ƫ��ǿ��
                localNormal.xy *= _BumpScale;
                //�����߿ռ䷨�������任������ռ�
                float3 worldNormal = normalize(mul(localNormal, i.tbn));
                //��һ��д��---����������о���
                //float3 worldNormal = normalize(mul(transpose(i.tbn), localNormal));

                //Сtrick
                //ͨ��lerp���Ʒ���ƫ��ǿ��    0Ϊ���ı䣬1Ϊ��ȫ�ı�
                //(���û��localNormal.xy *= _BumpScale;�Ļ�����ʹ��)
                //worldNormal = lerp(i.nDir, worldNormal, _BumpScale);


                //��ͨ�Ĺ��ռ���
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = normalize(reflect(-lDir, worldNormal));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
                
                float4 mainTex = tex2D(_MainTex, i.uv);
                
                float3 ambient = unity_AmbientSky;
                float3 diffuse = saturate(dot(lDir, worldNormal));
                float3 specular = pow(saturate(dot(rlDir, vDir)), _Gloss) ;

                float3 finalRGB = ambient * mainTex + diffuse * mainTex + specular;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}