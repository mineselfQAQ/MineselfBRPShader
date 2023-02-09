using UnityEngine;

public class ObjectMove : MonoBehaviour
{
    public Vector3 initPos;
    public Vector3 endPos;
    public float speed;

    void Start()
    {
        this.transform.position = initPos;
    }


    void Update()
    {
        this.transform.Translate(-speed * Time.deltaTime, 0, 0);
        if (this.transform.position.x < endPos.x)
        {
            this.transform.position = new Vector3(initPos.x, this.transform.position.y, this.transform.position.z);
        }
    }
}