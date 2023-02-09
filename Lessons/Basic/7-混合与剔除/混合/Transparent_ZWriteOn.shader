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
            "Queue"="Transparent"//必要---正确的顺序可以防止闪烁(还有顺序问题)
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
            //渲染状态
            ZWrite Off
            Blend [_Src] [_Dst]
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令

			
            //变量申明
            fixed3 _Color;
            float _Alpha;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 wPos : TEXCOORD0;
                float3 wNormal : TEXCOORD1;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));

                //_Color给予如Blend One One这种rgb通道驱动的混合模式控制权
                float3 diffuse = saturate(dot(lDir, nDir)) * _Color;

                float3 finalRGB = diffuse;

                //_Alpha给予如Blend SrcAlpha OneMinusSrcAlpah这种a通道驱动的混合模式控制权
                return float4(finalRGB, _Alpha);
            }
            ENDCG
        }
    }
    Fallback Off
}