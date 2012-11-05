using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class AsteroidField : MonoBehaviour
{

	public float width;
	public float height;
	public float length;
	public int count;
	public GameObject[] prefabs;
	public float asteroidSpeed;
	public float asteroidAngularSpeed;
	public Detonator basicDetonator;
	public Material asteroidMaterial;


	void Start ()
	{
		foreach (Transform child in transform) {
			if (child.rigidbody != null)
				child.rigidbody.AddForce (Random.insideUnitSphere * asteroidSpeed);
			child.rigidbody.angularVelocity = Random.insideUnitSphere * asteroidAngularSpeed;
		}
	}


	
}
