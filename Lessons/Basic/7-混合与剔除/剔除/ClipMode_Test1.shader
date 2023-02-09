Shader "MineselfShader/Basic/7-ClipMode&BlendMode/ClipMode_Test1"
{
    Properties
    {
        [Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 2
        _CutOut("CutOut", Range(-1, 1)) = 0
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            //����ʹ����AlphaTest��Shader����ü����⼸��
            "Queue"="AlphaTest" 
            "RenderType"="TransparentCutout" 
            "IgnoreProjector"="True"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //��Ⱦ״̬
            //�����޳�ģʽ��Ĭ��ΪCull Back��Ҳ�����޳�����
            Cull [_CullMode]
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //��������ļ�����ָ��

			
            //��������
            float _CutOut;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 oPos : TEXCOORD0;
            };

            //������ɫ��
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //�������ռ䶥��λ��
                o.oPos = v.vertex;

                return o;
            }

            //ƬԪ��ɫ��
            fixed4 frag (v2f i) : SV_Target
            {
                //ͨ������ռ䶥��λ����������
                //����ԭ��(0,0,0)����ô�ڴ�֮�ϵ�λ��ֵԽ��Խ�󣬷�֮
                float mask = i.oPos.y;

                //ʹ��������Ϊ��ɫֵ(���ӻ�)
                //ʹ��1��Ϊ͸���ȣ���û��Blend������������ô���Ķ���û���õ�(��Ҫ��Ϊclip()��ֵʱ����)
                float3 finalRGB = mask.rrr;
                float alpha = 1;

                //���ԣ���Alphaֵ�̶�Ϊ1��ʹ��Rͨ�������޳�
                //���ۣ�clip()��һ������Alphaֵ���Ǹ��ݴ����������0�Ĺ�ϵ
                clip(finalRGB.r - _CutOut);

                return float4(finalRGB, alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}