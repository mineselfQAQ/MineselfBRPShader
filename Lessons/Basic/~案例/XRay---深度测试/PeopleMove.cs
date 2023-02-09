using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PeopleMove : MonoBehaviour
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
        this.transform.Translate(0, 0, speed * Time.deltaTime);
        if (this.transform.position.x < endPos.x)
        {
            this.transform.position = new Vector3(initPos.x, this.transform.position.y, this.transform.position.z);
        }
    }
}