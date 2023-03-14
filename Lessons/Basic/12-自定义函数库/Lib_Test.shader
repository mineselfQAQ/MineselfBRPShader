Shader "MineselfShader/Basic/12-MyLib/Lib_Test"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        
        [Space(10)]
        _Origin("Origin", vector) = (0.5,0.5,0,0)
        _Scale("Scale", vector) = (1,1,0,0)
        _Rotation("Rotation", Range(0, 1)) = 0
        _Translation("Translation", vector) = (0,0,0,0)
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
            #include "..\..\_Common\MyLib.cginc"
			
            //��������
            sampler2D _MainTex;

            float2 _Origin;
            float2 _Scale;
            float _Rotation;
            float2 _Translation;
                
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

                //������ʽ1
                //o.uv = UVTransform(v.uv, _Scale, _Rotation * UNITY_TWO_PI, _Translation);
                //������ʽ2
                o.uv = UVTransform(v.uv, _Scale, _Rotation * UNITY_TWO_PI, _Translation, _Origin);

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