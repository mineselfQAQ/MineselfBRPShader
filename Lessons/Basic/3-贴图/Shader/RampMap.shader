Shader "MineselfShader/Basic/3-Texture/RampMap"
{
    Properties
    {
        _Rampmap("RampMap", 2D) = "white"{}
        _uvY("uv:Y",Range(0,1)) = 0
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
            sampler2D _Rampmap;
            float _uvY;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal :NORMAL;
                float2 uv : TEXCOORD0;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 wPos : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.uv;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //�����������
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                //����halfLambert�������ⲻӦ�ÿ��ɹ���ģ�ͣ���Ӧ����һ������ֵ
                //halfLambert�Ǵ�[-1,1]ӳ�䵽��[0,1]����ô������Ϊ1�����Ϊ0
                float halfLambert = dot(lDir, i.wNormal) * 0.5 + 0.5;
                //���ƽ���ӳ��ķ�ʽ
                //x---������halfLambert
                //y---������ʹ��һ��[0,1]��ֵ
                //�����Ͼ��ǣ���halfLambert��ɫֵΪ0.5�����ͻ����_Rampmap����������м�(ͬʱ����yֵ)����ɫ
                i.uv.x = halfLambert;
                i.uv.y = _uvY;

                //���������uv��������Ϊ��ʹ��halfLambert��uv
                //�����Ӧ����ͼ������������Ӧ����ͼ����
                //[0,1]��ֵ������ͼ������
                float4 finalRGB = tex2D(_Rampmap, i.uv);

                return finalRGB;
            }
            ENDCG
        }
    }
    Fallback Off
}