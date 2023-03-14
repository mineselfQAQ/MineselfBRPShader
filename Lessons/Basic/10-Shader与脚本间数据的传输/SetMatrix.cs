using UnityEngine;

public class SetMatrix : MonoBehaviour
{
    // Attach to an object that has a Renderer component,
    // and use material with the shader below.
    public float rotateSpeed = 30f;
    public void Update()
    {
        // Construct a rotation matrix and set it for the shader
        Quaternion rot = Quaternion.Euler(0, 0, Time.time * rotateSpeed);
        Matrix4x4 m = Matrix4x4.TRS(Vector3.zero, rot, Vector3.one);
        GetComponent<Renderer>().material.SetMatrix("_TextureRotation", m);
    }
}