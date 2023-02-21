Shader "MineselfShader/Template/Template_cginclude"
{
    Properties
    {
        
    }

    CGINCLUDE
        
    #include "UnityCG.cginc"
    //��������ļ�����ָ��

    //��������
                

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
        float3 finalRGB = float3(1,1,1);
        return float4(finalRGB, 1);
    }
    ENDCG

    SubShader
    {
        Pass
        {
            //Pass Tags
            Tags{}
            //��Ⱦ״̬
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
    }
    Fallback Off
}