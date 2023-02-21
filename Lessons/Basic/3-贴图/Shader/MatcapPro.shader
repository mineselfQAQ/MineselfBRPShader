Shader "MineselfShader/Basic/3-Texture/MatcapPro"
{
    Properties
    {
        _Matcap("Matcap", 2D) = "white"{}
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
            sampler2D _Matcap;
                
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
                float2 uv : TEXCOORD0;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //����vPos��vNormal����Ҫ����ӳ�����ȥ��normalize()
                float3 vPos = normalize(UnityObjectToViewPos(v.vertex));
                float3 vNormal = normalize(mul(UNITY_MATRIX_IT_MV, v.normal));

                //ʹ�ò�˵õ�һ����ֱ�������������ķ���
                float3 crossResult = cross(vPos, vNormal);

                //�������򲢽���ӳ��
                o.uv = float2(-crossResult.y, crossResult.x) * 0.5 + 0.5;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float3 finalRGB = tex2D(_Matcap, i.uv);
                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}