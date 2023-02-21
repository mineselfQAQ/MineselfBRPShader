Shader "MineselfShader/Basic/8_Shadow/CastAndReceiveShadow"
{
    Properties
    {

    }
    SubShader
    {
        //SubShader Tags
		Tags{}
        Pass
        {
            //Pass Tags
            Tags
            {
            //前向渲染路径---基础Pass，一般来说都会使用这个
            "LightMode"="ForwardBase"
            }
            //渲染状态
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            //额外包含文件编译指令
            #include "AutoLight.cginc"//以下宏都使用到了
            //与前向渲染路径基础pass配套的关键字
            #pragma multi_compile_fwdbase
			
            //变量申明
                
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
                //声明一个用于对阴影纹理采样的坐标
                SHADOW_COORDS(2)
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);

                //在顶点着色器中计算阴影纹理坐标
                TRANSFER_SHADOW(o);

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 rlDir = reflect(-lDir, nDir);
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

                float3 ambient = unity_AmbientSky;
                float diffuse = saturate(dot(lDir, nDir));
                float specular = pow(saturate(dot(rlDir, vDir)), 30);

                //计算阴影值
                float shadow = SHADOW_ATTENUATION(i);

                //结合阴影值计算finalRGB
                float3 finalRGB = ambient + (diffuse + specular) * shadow;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    //使用Fallback语句选择Diffuse为备用Shader，自动生成投射阴影
    Fallback "Diffuse"
}