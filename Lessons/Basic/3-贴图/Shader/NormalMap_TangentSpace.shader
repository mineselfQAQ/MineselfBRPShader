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
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 uv : TEXCOORD0;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 lDir : TEXCOORD1;
                float3 vDir : TEXCOORD2;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                //�����tbn���󣬲���ȡ��Ϊrotation
                TANGENT_SPACE_ROTATION;

                //����ռ�����ת�������߿ռ�
                o.lDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
                o.vDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //���߽��
                float3 unpackNormal = UnpackNormal(tex2D(_NormalTex, i.uv));
                //���ķ���ƫ�Ƴ̶�
                unpackNormal.xy *= _BumpScale;

                //�����Ĺ��ռ���---�����߿ռ��м���
                float3 lDir = normalize(i.lDir);
                float3 rlDir = normalize(reflect(-lDir, unpackNormal));
                float3 vDir = normalize(i.vDir);

                float4 mainTex = tex2D(_MainTex, i.uv);

                float3 ambient = unity_AmbientSky;
                float3 diffuse = saturate(dot(lDir, unpackNormal));
                float3 specular = pow(saturate(dot(rlDir, vDir)), _Gloss);

                float3 finalRGB = ambient * mainTex + diffuse * mainTex + specular;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}