Shader "MineselfShader/Basic/7-ClipMode&BlendMode/BlendMode_Transparent_ZWriteOn"
{
    Properties
    {
        _Color("Color", COLOR) = (1,1,1,1)
        _Alpha("Alpha", Range(0, 1)) = 0.5
        [Enum(UnityEngine.Rendering.BlendMode)]_Src("Src", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)]_Dst("Dst", Float) = 10
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
            ZWrite On
            ColorMask 0
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //��Ⱦ״̬
            ZWrite Off
            Blend [_Src] [_Dst]
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            fixed3 _Color;
            float _Alpha;
                
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
                float4 wPos : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));

                //_Color������Blend One One����rgbͨ�������Ļ��ģʽ����Ȩ
                float3 diffuse = saturate(dot(lDir, nDir)) * _Color;

                float3 finalRGB = diffuse;

                //_Alpha������Blend SrcAlpha OneMinusSrcAlpah����aͨ�������Ļ��ģʽ����Ȩ
                return float4(finalRGB, _Alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}