using UnityEngine;

public class CameraController_13 : MonoBehaviour
{
    public float speed;

    private bool isAutoMove = false;
    private int dir = 1;
    void Update()
    {
        //手动操控
        if (Input.GetKeyDown(KeyCode.A))
        {
            transform.Translate(-1.5f, 0, 0);
        }
        if (Input.GetKeyDown(KeyCode.D))
        {
            transform.Translate(1.5f, 0, 0);
        }

        //自动操控
        if (Input.GetKeyDown(KeyCode.Space))
        {
            isAutoMove = !isAutoMove;
        }
        if (Input.GetKeyDown(KeyCode.R))
        {
            dir = -dir;
        }
        if (isAutoMove)
        {
            transform.Translate(Time.deltaTime * speed * dir, 0, 0);
        }
    }
}
