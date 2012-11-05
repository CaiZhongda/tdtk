using UnityEngine;
using System.Collections;

public class Asteroid : MonoBehaviour
{

	public float damage = 10.0f;

	public Detonator detonator;

	void Start ()
	{
		this.tag = "Asteroid";
		DamagableObject damObj = gameObject.GetComponent<DamagableObject> ();
		if (damObj) {
			damObj.OnDeath += Death;
		}
	}

	void OnCollisionEnter (Collision collision)
	{
		DamagableObject damObj = collision.gameObject.GetComponent<DamagableObject> ();
		DamagableObject damObjMine = gameObject.GetComponent<DamagableObject> ();
		if (damObj) {
			damObj.TakeDamage (damage);
		}
		if (damObjMine) {
			damObjMine.TakeDamage (damage);
		}
		
	}

	void Death ()
	{
		if (!this.rigidbody.isKinematic) {
			this.rigidbody.isKinematic = true;
			Instantiate (detonator, this.transform.position, this.transform.rotation);
			Mathf.Max (collider.bounds.size.x, collider.bounds.size.y, collider.bounds.size.z);
			
			Destroy (gameObject);
			
		}
	}
}
