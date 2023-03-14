using UnityEngine;
using UnityEngine.Rendering;

public class GlobalKeyword_Test : MonoBehaviour
{
    private GlobalKeyword keyword;

    void Start()
    {
        //����һ��ȫ�ֹؼ��֣���Shader�е�һ��������Ϊ_INVERT_ON
        //Ҫע�����:
        //������ȫ�ֹؼ��֣��ùؼ���һ����Ҫ��ȫ����������ܿ���
        //Ҳ����˵�ùؼ��ֲ�����_local��׺
        keyword = GlobalKeyword.Create("_INVERT_ON");

        //Ĭ��״̬---������_INVERT_ON��Ҳ����_INVERT_OFF
        Shader.DisableKeyword(keyword);
    }

    void Update()
    {
        //����״̬:
        //����E������_INVERT_ON�ؼ���
        //����Q���ر�_INVERT_ON�ؼ���
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
