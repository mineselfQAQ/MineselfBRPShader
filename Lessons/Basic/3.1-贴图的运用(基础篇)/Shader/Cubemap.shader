Shader "MineselfShader/Basic/3-Texture/Cubemap"
{
    //注意一下：在某处写的"_Skybox"，但这里其实写不写都一样，只有默认值灰色
    Properties
    {
        _Cubemap("Cubemap", Cube) = ""{}
        [KeywordEnum(Reflect, Refract)]_Mode("Mode", Float) = 0
        [Toggle]_FresnelSwitch("WithFresnel", Float) = 0
        [Space(10)]
        _CubemapMip("CubemapMipmap", Range(0, 8)) = 0
        _ReflectRatio("(Refract)ReflectRatio", Range(0.1, 1)) = 1
        _R0("(Fresnel)R0", vector) = (1,1,1,0)
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
            #pragma shader_feature _FRESNELSWITCH_ON
            #pragma shader_feature _MODE_REFLECT _MODE_REFRACT
			
            //变量申明
            samplerCUBE _Cubemap;//注意是CUBE，别写成2D了
            float _CubemapMip;
            float _ReflectRatio;
            float3 _R0;
                
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
                //计算光照向量
                float3 nDir = normalize(i.wNormal);
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));

              #if _MODE_REFLECT
                float3 rvDir = normalize(reflect(-vDir, nDir));
                //使用texCUBElod()计算采样的"环境高光反射"
                //对于texCUBE()来说，与tex2D()不一样，需要的不是uv，而是一个向量，代表着"眼睛接收到来自何处的环境"
                //带有lod的和普通的不一样，在w分量上需要放入LOD---Level of detail
                //texCUBElod()输出4D，只是这里只用3D即可，实验发现w分量可能就是1
                float3 cubemap = texCUBElod(_Cubemap, float4(rvDir, _CubemapMip));

                //同样可以使用texCUBE()，这种方式自带"变化的mipmap"
                //float3 cubemap = texCUBE(_Cubemap, rvDir);
              #elif _MODE_REFRACT
                //对于折射来说，和反射使用的texCUBElod()一致，只是这里需要计算的是折射向量而不是反射向量
                float3 rvDir = normalize(refract(-vDir, nDir, _ReflectRatio));
                float3 cubemap = texCUBElod(_Cubemap, float4(rvDir, _CubemapMip));

                //同样可以使用texCUBE()，这种方式自带"变化的mipmap"
                //float3 cubemap = texCUBE(_Cubemap, rvDir);
              #endif

                float3 finalRGB = cubemap;

              #if _FRESNELSWITCH_ON
                float3 diffuse = saturate(dot(lDir, nDir));
                float3 fresnel = _R0 + (1 - _R0) * pow(1 - saturate(dot(nDir, vDir)), 5);
                finalRGB = lerp(diffuse, cubemap, saturate(fresnel));
              #endif

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}