using UnityEngine;

public class MoncageRotate : MonoBehaviour
{
    public Vector3 speed;

    private bool isRotating;

    private int xSign = 1;
    private int ySign = 1;
    private int zSign = 1;

    void Update()
    {
        isRotating = GetComponent<BoxController>().isRotating;

        xSign = GetComponent<BoxController>().xSign;
        ySign = GetComponent<BoxController>().ySign;
        zSign = GetComponent<BoxController>().zSign;

        if (isRotating)
        {
            float x = Time.deltaTime * speed.x * xSign;
            float y = Time.deltaTime * speed.y * ySign;
            float z = Time.deltaTime * speed.z * zSign;
            this.transform.Rotate(x, y, z);
        }
    }
}
