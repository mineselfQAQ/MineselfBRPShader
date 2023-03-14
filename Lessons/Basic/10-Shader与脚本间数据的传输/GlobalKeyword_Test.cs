using UnityEngine;
using UnityEngine.Rendering;

public class GlobalKeyword_Test : MonoBehaviour
{
    private GlobalKeyword keyword;

    void Start()
    {
        //创建一个全局关键字，和Shader中的一样，名字为_INVERT_ON
        //要注意的是:
        //由于是全局关键字，该关键字一定需要有全局作用域才能开启
        //也就是说该关键字不能有_local后缀
        keyword = GlobalKeyword.Create("_INVERT_ON");

        //默认状态---不开启_INVERT_ON，也就是_INVERT_OFF
        Shader.DisableKeyword(keyword);
    }

    void Update()
    {
        //两种状态:
        //按下E，开启_INVERT_ON关键字
        //按下Q，关闭_INVERT_ON关键字
        if (Input.GetKeyDown(KeyCode.A))
        {
            EnableFeature();
            Debug.Log("_INVERT_ON");
        }
        if (Input.GetKeyDown(KeyCode.D))
        {
            DisableFeature();
            Debug.Log("_INVERT_OFF");
        }
    }

    public void EnableFeature()
    {
        Shader.EnableKeyword(keyword);
    }
    public void DisableFeature()
    {
        Shader.DisableKeyword(keyword);
    }
}
