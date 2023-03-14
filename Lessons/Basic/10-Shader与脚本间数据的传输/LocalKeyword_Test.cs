using UnityEngine;
using UnityEngine.Rendering;

public class LocalKeyword_Test : MonoBehaviour
{
    public Material material;

    private LocalKeyword keyword;

    void Start()
    {
        //��ȡ����ʹ�õ�Shader
        Shader shader = material.shader;

        //����һ��keyword����Shader����������Ϊ_INVERT_ON
        keyword = new LocalKeyword(shader, "_INVERT_ON");

        //Ĭ��״̬---������_INVERT_ON��Ҳ����_INVERT_OFF
        material.DisableKeyword(keyword);
    }

    void Update()
    {
        //����״̬:
        //����E������_INVERT_ON�ؼ���
        //����Q���ر�_INVERT_ON�ؼ���
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