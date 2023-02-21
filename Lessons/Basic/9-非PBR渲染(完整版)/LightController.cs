using UnityEngine;

public class LightController : MonoBehaviour
{
    public Material material;

    private GameObject[] lights;
    private Color tempCol;

    // Start is called before the first frame update
    void Start()
    {
        lights = GameObject.FindGameObjectsWithTag("Light");
        tempCol = material.color;
    }

    public void OnApplicationQuit()
    {
        material.color = tempCol;
    }

    public void LightOn()
    {
        foreach (var light in lights)
        {
            light.SetActive(true);
            material.color = tempCol;
        }
    }
    public void LightOff()
    {
        foreach (var light in lights)
        {
            light.SetActive(false);
            material.color = Color.black;
        }
    }
}
