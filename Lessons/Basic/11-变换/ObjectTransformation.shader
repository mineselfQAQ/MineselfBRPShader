Shader "MineselfShader/Basic/11-Transformation/ObjectTransformation"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        [IntRange]_TimeSwitch("TimeSwitch", Range(0, 1)) = 1
        
        [Space(10)]
        _Scale("Scale", vector) = (1,1,1,0)
        _Translation("Translation", vector) = (0,0,0,0)
        _Rotation("Rotation", Range(0, 10)) = 1
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
            sampler2D _MainTex;
            float _TimeSwitch;

            float3 _Scale;
            float3 _Translation;
            float _Rotation;
                
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

                //要记住的是:
                //由于是更改顶点，所以要在物体空间顶点信息转到为其他空间之前处理完顶点

                //先缩放
                v.vertex.xyz *= _Scale;

                //再平移
                v.vertex.xyz += _Translation;

                //最后旋转
                float t = lerp(_Rotation * UNITY_PI, frac(_Time.x * _Rotation) * UNITY_TWO_PI, _TimeSwitch);
                float3x3 rM = float3x3(cos(t),  0, sin(t),
                                           0,   1,     0,
                                      -sin(t),  0, cos(t));
                v.vertex.xyz = mul(rM, v.vertex.xyz);

                //常规操作
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float4 mainTex = tex2D(_MainTex, i.uv);

                return mainTex;
            }
            ENDCG
        }
    }
    Fallback Off
}