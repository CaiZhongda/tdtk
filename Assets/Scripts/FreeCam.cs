using UnityEngine;
using System.Collections;

//Decompile by Si Borokokok

[AddComponentMenu("Camera-Control/Free Cam")]
internal class FreeCam : MonoBehaviour
{

    public RotationAxes axes;
    public float maximumX = 360f;
    public float maximumY = 60f;
    public float minimumX = -360f;
    public float minimumY = -60f;
    private Quaternion originalRotation;
    private float rotationX;
    private float rotationY;
    public float sensitivityX = 15f;
    public float sensitivityY = 15f;
    public float speed = 50f;


    public static float ClampAngle(float angle, float min, float max)
    {
        if (angle < -360f)
        {
            angle += 360f;
        }
        if (angle > 360f)
        {
            angle -= 360f;
        }
        return Mathf.Clamp(angle, min, max);
    }

    private void Start()
    {
        if (rigidbody != null)
        {
            rigidbody.freezeRotation = true;
        }
        originalRotation = transform.localRotation;
    }

    private void Update()
    {
        if (axes == RotationAxes.MouseXAndY)
        {
            rotationX += Input.GetAxis("Mouse X") * sensitivityX;
            rotationY += Input.GetAxis("Mouse Y") * sensitivityY;
            rotationX = ClampAngle(rotationX, minimumX, maximumX);
            rotationY = ClampAngle(rotationY, minimumY, maximumY);
            Quaternion quaternion = Quaternion.AngleAxis(rotationX, Vector3.up);
            Quaternion quaternion2 = Quaternion.AngleAxis(rotationY, Vector3.left);
            transform.localRotation = (originalRotation * quaternion) * quaternion2;
        }
        else if (axes == RotationAxes.MouseX)
        {
            rotationX += Input.GetAxis("Mouse X") * sensitivityX;
            rotationX = ClampAngle(rotationX, minimumX, maximumX);
            Quaternion quaternion3 = Quaternion.AngleAxis(rotationX, Vector3.up);
            transform.localRotation = originalRotation * quaternion3;
        }
        else
        {
            rotationY += Input.GetAxis("Mouse Y") * sensitivityY;
            rotationY = ClampAngle(rotationY, minimumY, maximumY);
            Quaternion quaternion4 = Quaternion.AngleAxis(rotationY, Vector3.left);
            transform.localRotation = originalRotation * quaternion4;
        }
        if (Input.GetAxis("Vertical") > 0f)
        {
            Transform transform = base.transform;
            transform.position += (Vector3) ((transform.forward * speed) * Time.deltaTime);
        }
        else if (Input.GetAxis("Vertical") < 0f)
        {
            Transform transform2 = transform;
            transform2.position += (Vector3) ((transform.forward * -speed) * Time.deltaTime);
        }
        else if (Input.GetAxis("Horizontal") > 0f)
        {
            Transform transform3 = transform;
            transform3.position += (Vector3) ((transform.right * speed) * Time.deltaTime);
        }
        else if (Input.GetAxis("Horizontal") < 0f)
        {
            Transform transform4 = transform;
            transform4.position += (Vector3) ((-transform.right * speed) * Time.deltaTime);
        }
    }


    public enum RotationAxes
    {
        MouseXAndY,
        MouseX,
        MouseY
    }
}

 
