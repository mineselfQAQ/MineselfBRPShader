//Phong就是环境漫反射+Lambert漫反射+Phong高光反射
Shader "MineselfShader/Basic/1-BasicLightingModel/Phong"
{
    Properties
    {
        [Header(Switch)][Space(5)]
        [IntRange]_AmbSwitch("AmbientSwitch", Range(0, 1)) = 1
        [IntRange]_DiffSwitch("DiffuseSwitch", Range(0, 1)) = 1
        [IntRange]_SpecSwitch("SpecularSwitch", Range(0, 1)) = 1

        [Header(Ambient)][Space(5)]
        _AmbCol("AmbientColor", COLOR) = (1,1,1,1)
        _AmbInt("AmbientIntensity", Range(0, 3)) = 1

        [Header(Diffuse)][Space(5)]
        _DiffCol("DiffuseColor", COLOR) = (1,1,1,1)
        _DiffInt("DiffuseIntensity", Range(0, 3)) = 1

        [Header(Specular)][Space(5)]
        _SpecCol("SpecularColor", COLOR) = (1,1,1,1)
        _SpecInt("SpecularIntensity", Range(0, 3)) = 1
        _Gloss("Gloss", Range(0.1, 100)) = 30

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
            #include "Lighting.cginc"
			
            //变量申明
            //注意点:
            //1.颜色是四维的，一般用fixed4
            //2.上下名字要对应，所以最好在属性写完后直接复制过来保证正确性，或者使用智能输入
            float _AmbSwitch;
            float _DiffSwitch;
            float _SpecSwitch;

            fixed4 _AmbCol;
            float _AmbInt;

            fixed4 _DiffCol;
            float _DiffInt;

            fixed4 _SpecCol;
            float _SpecInt;
            float _Gloss;
                
			//顶点输入
            struct appdata
            {
                //是4D的，个人猜测：是写成了齐次坐标的形式，这里w大概率是1，代表是一个位置
                //当然可以声明为3D，但是矩阵用的是4x4，那么就不合适了
                float4 vertex : POSITION;

                float3 normal : NORMAL;//由于漫反射是基于法线的---nDir·lDir，所以需要声明
            };
			
            //顶点输出
            struct v2f
            {
                //此时输出一定是4D的，因为这是一个经过MVP矩阵的变换的位置信息，w是一定有值的，简单来说就是"深度值"
                float4 pos : SV_POSITION;

                //这里选择在世界空间下计算
                //要注意的就是：所有的内容都应该在同一空间
                //比如：nDir在世界空间，那么lDir就一定要转换到世界空间才能进行计算
                float4 wPos : TEXCOORD0;//使用4D，其中一个原因是unity_ObjectToWorld是4x4矩阵
                float3 wNormal : TEXCOORD1;
            };

            //顶点着色器
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                //将两个信息---顶点/法线，转换到世界空间中，将其放入输出结构，最终传入片元着色器
                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                o.wNormal = UnityObjectToWorldNormal(v.normal);//注意:不要normalize()，在片元着色器中再进行，否则会被插值破坏"归一值"

                return o;
            }

            //片元着色器
            fixed4 frag (v2f i) : SV_Target
            {
                //向量处理
                float3 nDir = normalize(i.wNormal);//直接拿过来归一化即可
                float3 lDir = normalize(UnityWorldSpaceLightDir(i.wPos));//使用函数进行获得光照向量
                float3 rlDir = reflect(-lDir, nDir);//注意:由于nDir/lDir已经进行归一化，所以这里不需要在进行操作，但是为了以防万一，添加上也是可以的
                float3 vDir = normalize(UnityWorldSpaceViewDir(i.wPos));//使用函数进行获得光照向量

                //光照计算
                //===环境漫反射项===
                //就是简单的颜色值
                float3 ambientRGB = unity_AmbientSky * _AmbCol * _AmbInt;

                //===Lambert光源漫反射项===
                //核心就是lDir·nDir，其取值范围为[-1,1]，所以使用saturate()限制在[0,1]
                float diffuse = saturate(dot(lDir, nDir));
                float3 diffuseRGB = _LightColor0 * _DiffCol * _DiffInt * diffuse;//右侧本应该是4D，但是这里只需要获取3D，最后的a---透明度，使用1即可

                //===Phong高光反射项===
                //核心就是rlDir·vDir，pow()可以"调整高光范围"
                float specular = pow(saturate(dot(rlDir, vDir)), _Gloss);
                float3 specularRGB = _LightColor0 * _SpecCol * _SpecInt * specular;

                //合并输出  使用0/1值进行开关控制
                float3 finalRGB = _AmbSwitch * ambientRGB + _DiffSwitch * diffuseRGB + _SpecSwitch * specularRGB;

                return float4(finalRGB, 1);
            }
            ENDCG
        }
    }
    Fallback Off
}