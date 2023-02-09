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
            "Queue"="Transparent"//必要---正确的顺序可以防止闪烁(还有顺序问题)
            "RenderType"="Transparent"
            "IgnoreProjector"="True"
        }
        Pass
        {
            //Pass Tags
            Tags{}
            //渲染状态
            ZWrite [_ZWrite]
            Blend [_Src] [_Dst]
            BlendOp [_BlendOp]
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令

			
            //变量申明
            fixed4 _Color;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
    Fallback Off
}