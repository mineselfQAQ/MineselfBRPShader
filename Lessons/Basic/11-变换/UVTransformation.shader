Shader "MineselfShader/Basic/11-Transformation/UVTransformation"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        [IntRange]_TimeSwitch("TimeSwitch", Range(0, 1)) = 1
        
        [Space(10)]
        _Origin("Origin", vector) = (0.5,0.5,0,0)
        _Scale("Scale", vector) = (1,1,0,0)
        _Rotation("Rotation", Range(0, 10)) = 1
        _Translation("Translation", vector) = (0,0,0,0)
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

            float2 _Origin;
            float2 _Scale;
            float _Rotation;
            float2 _Translation;
                
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
                o.uv = v.uv;

                float t = lerp(0.5 * UNITY_PI, frac(_Time.x) * UNITY_TWO_PI, _TimeSwitch) * _Rotation;

                //移动uv至坐标系原点
                o.uv -= _Origin;

                //先缩放
                o.uv *= _Scale;

                //再旋转
                float2x2 rM = float2x2(cos(t), -sin(t),
                                       sin(t), cos(t));
                o.uv = mul(rM, o.uv);

                //最后平移
                //_Translation = mul(rM, _Translation);//纠正我们的平移方向
                o.uv -= _Translation;

                //再将uv移动回原处
                o.uv += _Origin;


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