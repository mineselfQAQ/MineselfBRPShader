Shader "MineselfShader/Basic/7-ClipMode&BlendMode/BlendMode_BlendModeByEnum"
{
    Properties
    {
        _Color("Color", COLOR) = (1,1,1,1)

        [Space(20)]

        [Enum(UnityEngine.Rendering.BlendOp)]_BlendOp("BlendOp", Float) = 0
        [Enum(UnityEngine.Rendering.BlendMode)]_Src("Src", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)]_Dst("Dst", Float) = 10
        [Enum(Off, 0, On, 1)]_ZWrite("ZWrite", Float) = 0
    }
    SubShader
    {
        //SubShader Tags
		Tags 
        { 
            "Queue"="Transparent"//��Ҫ---��ȷ��˳����Է�ֹ��˸(����˳������)
            "RenderType"="Transparent"
            "IgnoreProjector"="True"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //��Ⱦ״̬
            ZWrite [_ZWrite]
            Blend [_Src] [_Dst]
            BlendOp [_BlendOp]
            
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