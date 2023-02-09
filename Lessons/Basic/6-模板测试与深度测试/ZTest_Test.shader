Shader "MineselfShader/Basic/6_StencilTest&DepthTest/DepthTest_Test"
{
    Properties
    {
        _Color("Color", COLOR) = (1,1,1,1)
        [Enum(UnityEngine.Rendering.CompareFunction)]_ZTest("ZTest", Float) = 4 //Ĭ��ֵΪLEqual����ö��ֵΪ4
        [Enum(Off, 0, On, 1)]_ZWrite("ZWrite", Float) = 1
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
            //��������ֻ��һ��Pass�����Խ���������д��Pass�к�SubShader�ж��ǵȼ۵�
            ZTest [_ZTest]
            ZWrite [_ZWrite]
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            fixed4 _Color;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
    Fallback Off
}