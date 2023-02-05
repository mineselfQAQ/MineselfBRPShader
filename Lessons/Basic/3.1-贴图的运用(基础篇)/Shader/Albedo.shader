Shader "MineselfShader/Basic/3-Texture/Albedo"
{
    Properties
    {
        _MainTex("MainTex", 2D) = "white"{}
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
            //_ST��������������ͼ���������е�Tilling��Offset��
            sampler2D _MainTex; float4 _MainTex_ST;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
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

                //�������ҪTiling��Offset��ֱ�Ӵ��봫������
                //o.uv = v.uv;

                //�����ҪTiling��Offset������ʹ�ú���ʵ�֣�Ҳ�����ֶ���д
                //����ʵ�֣�TRANSFORM_TEX(uv, ��ͼ)
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //�ֶ�ʵ�֣�xy���������ź��������Tiling��zw���������ź��������Offset
                //����uv��˵�������ţ���ƽ��
                o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //ʹ��tex2D()���в�������
                float3 mainTex = tex2D(_MainTex, i.uv);

                return float4(mainTex, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}