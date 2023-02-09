Shader "MineselfShader/Basic/6_StencilTest&DepthTest/DepthTest_Test"
{
    Properties
    {
        _Color("Color", COLOR) = (1,1,1,1)
        [Enum(UnityEngine.Rendering.CompareFunction)]_ZTest("ZTest", Float) = 4 //默认值为LEqual，其枚举值为4
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
            //渲染状态
            //由于这里只有一个Pass，所以将以下两句写在Pass中和SubShader中都是等价的
            ZTest [_ZTest]
            ZWrite [_ZWrite]
            
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