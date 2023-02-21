Shader "MineselfShader/Template/Template_VFX"
{
    Properties
    {

    }
    SubShader
    {
        //SubShader Tags
		Tags{}
        Pass
        {
            //Pass Tags
            Tags
            {
                "Queue"="Transparent"
                "RenderType"="Transparent"
                "ForceNoShadowCasting"="True"
                "IgnoreProjector"="True"
            }
            //��Ⱦ״̬
            ZWrite Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            
                
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

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float3 finalRGB = float3(1,1,1);
                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}