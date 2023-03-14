using UnityEngine;
using UnityEngine.Rendering;

public class LocalKeyword_Test : MonoBehaviour
{
    public Material material;

    private LocalKeyword keyword;

    void Start()
    {
        //获取材质使用的Shader
        Shader shader = material.shader;

        //创建一个keyword，在Shader中它的名字为_INVERT_ON
        keyword = new LocalKeyword(shader, "_INVERT_ON");

        //默认状态---不开启_INVERT_ON，也就是_INVERT_OFF
        material.DisableKeyword(keyword);
    }

    void Update()
    {
        //两种状态:
        //按下E，开启_INVERT_ON关键字
        //按下Q，关闭_INVERT_ON关键字
        if(Input.GetKeyDown(KeyCode.E))
        {
            EnableFeature();
            Debug.Log("_INVERT_ON");
        }
        if (Input.GetKeyDown(KeyCode.Q))
        {
            DisableFeature();
            Debug.Log("_INVERT_OFF");
        }
    }

    public void EnableFeature()
    {
        material.EnableKeyword(keyword);
    }
    public void DisableFeature()
    {
        material.DisableKeyword(keyword);
    }
}