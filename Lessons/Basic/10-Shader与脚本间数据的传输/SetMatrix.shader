Shader "MineselfShader/Basic/10-Shader&MaterialClass/SetMatrix"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
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
            //��C#�˵õ������ݣ���Ҫע�����¼��㣺
            //����Ҫ��CG�������������ǲ���Ҫ��Properties������
            //���ֲ���Ҫ���·�ʹ��ʱ��ƥ�䣬����Ҫ��SetMatrix()�е�ƥ��
            float4x4 _TextureRotation;
                
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

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv = mul(_TextureRotation, float4(o.uv, 0, 1)).xy;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                return tex2D(_MainTex, i.uv);
            }
            ENDCG
        }
    }
    Fallback Off
}