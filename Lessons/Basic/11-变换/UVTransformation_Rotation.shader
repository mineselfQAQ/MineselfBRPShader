Shader "MineselfShader/Basic/11-Transformation/UVTransformation_Rotation"
{
    Properties
    {
        _MainTex("MainTexture", 2D) = "white"{}
        [IntRange]_TimeSwitch("TimeSwitch", Range(0, 1)) = 1
        
        [Space(10)]
        _RotationSpeed("RotationSpeed", Range(0, 10)) = 1
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

            float _RotationSpeed;
                
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

                //计算变换
                float t = lerp(0.5 * UNITY_PI, frac(_Time.x) * UNITY_TWO_PI, _TimeSwitch) * _RotationSpeed;

                //移动uv至坐标系原点
                o.uv -= float2(0.5, 0.5);

                //旋转
                //方法1---使用代数进行计算
                //o.uv = float2(o.uv.x * cos(time) -
                //              o.uv.y * sin(time),
                //              o.uv.x * sin(time) +
                //              o.uv.y * cos(time));
                //方法2---使用矩阵进行计算
                float2x2 rM = float2x2(cos(t), -sin(t),
                                       sin(t), cos(t));
                o.uv = mul(rM, o.uv);

                //再将uv移动回原处
                o.uv += float2(0.5, 0.5);

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