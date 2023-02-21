Shader "MineselfShader/Basic/8_Shadow/ShadowWithForwardAdd2"
{
    Properties
    {

    }

    CGINCLUDE
    #include "UnityCG.cginc"
    //额外包含文件编译指令
    #include "Lighting.cginc"//用于_LightColor0
    #include "AutoLight.cginc"//这些宏的关键

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

        //声明_ShadowCoord，使用TEXCOORDx语义，所以不能重复
        SHADOW_COORDS(2)
    };

    //顶点着色器---ForwardBase/ForwardAdd通用
    v2f vert (appdata v)
    {
        v2f o;
        o.pos = UnityObjectToClipPos(v.vertex);

        o.wPos = mul(unity_ObjectToWorld, v.vertex);
        o.wNormal = UnityObjectToWorldNormal(v.normal);

        //空间转换
        TRANSFER_SHADOW(o);

        return o;
    }

    //片元着色器---ForwardBase
    fixed4 frag (v2f i) : SV_Target
    {
        float3 nDir = normalize(i.wNormal);
        float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
        float3 rlDir = normalize(reflect(-lDir, nDir));
        float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
                
        float3 ambient = unity_AmbientSky;
        float3 diffuse = _LightColor0 * saturate(dot(lDir, nDir));
        float3 specular = _LightColor0 * pow(saturate(dot(rlDir, vDir)), 30);

        //计算光线衰减与阴影值
        UNITY_LIGHT_ATTENUATION(atten, i, i.wPos.xyz);

        float3 finalRGB = ambient + (diffuse + specular) * atten;

        return float4(finalRGB, 1);
    }
    //片元着色器---ForwardAdd
    fixed4 fragAdd (v2f i) : SV_Target
    {
        float3 nDir = normalize(i.wNormal);
        float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
        float3 rlDir = normalize(reflect(-lDir, nDir));
        float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));
                
        float3 diffuse = _LightColor0 * saturate(dot(lDir, nDir));
        float3 specular = _LightColor0 * pow(saturate(dot(rlDir, vDir)), 30);

        //计算光线衰减与阴影值
        UNITY_LIGHT_ATTENUATION(atten, i, i.wPos.xyz);

        //注意！！！不能添加ambient
        float3 finalRGB = (diffuse + specular) * atten;

        return float4(finalRGB, 1);
    }
    ENDCG

    SubShader
    {
        //SubShader Tags
		Tags{}

        //Pass1---ForwardBase
        Pass
        {
            //Pass Tags
            Tags
            {
                //Pass1一定得是ForwardBase，其中需要对太阳光与逐顶点/SH光源进行处理
                "LightMode"="ForwardBase"
            }
            //渲染状态
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //添加关键字，用于ForwardBase，与下方的宏也有关
            #pragma multi_compile_fwdbase
            ENDCG
        }
        //Pass2---ForwardAdd
        Pass
        {
            //Pass Tags
            Tags
            {
                //Pass2一定得是ForwardAdd，其中需要对除了太阳光的其他逐像素光源进行处理
                "LightMode"="ForwardAdd"
            }
            //渲染状态
            //注意需要与Pass1进行混合，所以有Blend命令
            Blend One One

            CGPROGRAM
            #pragma vertex vert
            //要注意这里使用的是CGINCLUDE中的fragAdd而不是frag
            #pragma fragment fragAdd
            //对于ForwardAdd来说，如果想要获得全部的阴影效果的话
            //需要使用fwdadd_fullshadows而不是fwdadd
            #pragma multi_compile_fwdadd_fullshadows
            ENDCG
        }
    }
    //产生投射阴影的方式
    Fallback "Diffuse"
}