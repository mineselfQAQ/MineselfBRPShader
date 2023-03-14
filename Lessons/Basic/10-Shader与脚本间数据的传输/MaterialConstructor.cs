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

        //写法1---使用SetColor()
        //tempMat.SetColor("_FresnelColor", color);
        //写法2---使用Material.color
        tempMat.color = color;
    }

    // Update is called once per frame
    void Update()
    {
        //按下空格切换状态---原材质与新材质
        if (Input.GetKeyDown(KeyCode.Space))
        {
            isChanged = !isChanged;
        }

        //更换材质
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
