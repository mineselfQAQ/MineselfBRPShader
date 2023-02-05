Shader "MineselfShader/Basic/2-InterpolationMethod/FlatShading"
{
    Properties
    {
        _Gloss("Gloss", Range(0.1, 100)) = 30.0
        _Int("0:PhongShading 1:FlatShading", Range(0, 1)) = 1
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
            float _Gloss;
            float _Int;
                
			//��������
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;//��������������
            };
			
            //�������
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 wPos : TEXCOORD0;
                float3 wNormal : TEXCOORD1;//��������������
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
                //ͨ��DDX��DDY�������λ�÷���
                 float3 worldDx = ddx(i.wPos);
                 float3 worldDy = ddy(i.wPos);
                 float3 worldNormal = normalize(cross(worldDy, worldDx));

                 //ʹ�û������Ʒ��ߣ�0ʱ����������ߣ�1ʱ���ƫ������
                 //���ڲ�ֵ��㲻�嵽���ǲ��ǵ�λ�����������һ��normalize()����
                 float3 nDir = normalize(lerp(normalize(i.wNormal), worldNormal, _Int));

                 //�����������
                 float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                 float3 rlDir = reflect(-lDir, nDir);
                 float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                 //����Phong����ģ��(ȥ������������)
                 float diffuse = saturate(dot(lDir, nDir));
                 float specular = pow(saturate(dot(rlDir, vDir)), _Gloss);

                 //�ϲ����������д��---Swizzle������
                 float3 finalRGB = (diffuse + specular).rrr;

                 return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}