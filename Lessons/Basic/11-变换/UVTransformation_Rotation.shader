Shader "MineselfShader/Basic/11-Transformation/UVTransformation_Rotation"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        [IntRange]_TimeSwitch("TimeSwitch", Range(0, 1)) = 1
        
        [Space(10)]
        _RotationSpeed("RotationSpeed", Range(0, 10)) = 1
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
            sampler2D _MainTex;
            float _TimeSwitch;

            float _RotationSpeed;
                
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
                o.uv = v.uv;

                //����任
                float t = lerp(0.5 * UNITY_PI, frac(_Time.x) * UNITY_TWO_PI, _TimeSwitch) * _RotationSpeed;

                //�ƶ�uv������ϵԭ��
                o.uv -= float2(0.5, 0.5);

                //��ת
                //����1---ʹ�ô������м���
                //o.uv = float2(o.uv.x * cos(time) -
                //              o.uv.y * sin(time),
                //              o.uv.x * sin(time) +
                //              o.uv.y * cos(time));
                //����2---ʹ�þ�����м���
                float2x2 rM = float2x2(cos(t), -sin(t),
                                       sin(t), cos(t));
                o.uv = mul(rM, o.uv);

                //�ٽ�uv�ƶ���ԭ��
                o.uv += float2(0.5, 0.5);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}