Shader "MineselfShader/Basic/Instance/XRay"
{
    Properties
    {
        _Color("Color", COLOR) = (1,1,1,1)
        _FresnelColor("FresnelColor", COLOR) = (1,1,1,1)
        _FresnelPow("FresnelPower", Range(0,10)) = 3
    }
    SubShader
    {
        //SubShader Tags
		Tags
        {
            //关键：2001队列比默认的2000大，说明使用该Shader的物体都是会比默认的物体后进行渲染
            //正常来说可能没有什么区别，但是将其放在最后一个进行渲染有利于我们思考
            "Queue"="Geometry+1"
        }

        //Pass1---被遮挡部分，使用Fresnel
        Pass
        {
            //Pass Tags
            Tags{}
            //渲染状态
            //XRay的核心：
            //ZWrite Off用来不影响后面的操作(Pass2)
            //ZTest Greater用来只渲染被遮挡部分
            ZWrite Off
            ZTest Greater

            //不是该Shader的核心，混合模式---使物体可以半透明，对于这种Blend方式需要通过A通道修改
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令

			
            //变量申明
            fixed4 _FresnelColor;
            float _FresnelPow;
                
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
                float3 wNormal : TEXCOORD0;
                float4 wPos : TEXCOORD1;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wNormal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul(unity_ObjectToWorld, v.vertex);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                float fresnel = pow(1 - saturate(dot(vDir, nDir)), _FresnelPow);

                float3 finalRGB = fresnel * _FresnelColor;
                float alpha = fresnel;

                return float4(finalRGB, fresnel);
            }
            ENDCG
        }

        //Pass2---未被遮挡部分，使用单一颜色
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