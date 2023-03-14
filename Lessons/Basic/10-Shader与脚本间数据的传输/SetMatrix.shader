Shader "MineselfShader/Basic/10-Shader&MaterialClass/SetMatrix"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
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
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令

			
            //变量申明
            sampler2D _MainTex; float4 _MainTex_ST;
            //从C#端得到的数据，需要注意以下几点：
            //必须要在CG段中声明，但是不需要在Properties中声明
            //名字不仅要和下方使用时的匹配，还需要与SetMatrix()中的匹配
            float4x4 _TextureRotation;
                
			//顶点输入
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
			
            //顶点输出
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv = mul(_TextureRotation, float4(o.uv, 0, 1)).xy;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                return tex2D(_MainTex, i.uv);
            }
            ENDCG
        }
    }
    Fallback Off
}