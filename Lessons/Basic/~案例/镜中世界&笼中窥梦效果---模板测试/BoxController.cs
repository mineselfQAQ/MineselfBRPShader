using UnityEngine;

public class BoxController : MonoBehaviour
{
    public bool isRotating;

    public int xSign = 1;
    public int ySign = 1;
    public int zSign = 1;

    public void RotateOn()
    {
        isRotating = true;
    }
    public void RotateOff()
    {
        isRotating = false;
    }
    public void NegX()
    {
        xSign *= -1;
    }
    public void NegY()
    {
        ySign *= -1;
    }
    public void NegZ()
    {
        zSign *= -1;
    }
}
