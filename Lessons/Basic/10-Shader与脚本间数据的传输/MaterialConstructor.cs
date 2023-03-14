using UnityEngine;

public class MaterialConstructor : MonoBehaviour
{
    public Shader shader;

    [ColorUsageAttribute(true, true)]
    public Color color;

    private Renderer rend;
    private Material originMat;
    private Material tempMat;

    private bool isChanged = false;

    // Start is called before the first frame update
    void Start()
    {
        rend = GetComponent<Renderer>();

        originMat = rend.material;

        tempMat = new Material(shader);

        //д��1---ʹ��SetColor()
        //tempMat.SetColor("_FresnelColor", color);
        //д��2---ʹ��Material.color
        tempMat.color = color;
    }

    // Update is called once per frame
    void Update()
    {
        //���¿ո��л�״̬---ԭ�������²���
        if (Input.GetKeyDown(KeyCode.Space))
        {
            isChanged = !isChanged;
        }

        //��������
        if (!isChanged)
        {
            rend.material = originMat;
        }
        else
        {
            rend.material = tempMat;
        }
    }
}
