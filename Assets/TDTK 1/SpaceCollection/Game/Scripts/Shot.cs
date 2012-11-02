using UnityEngine;
using System.Collections;

public class Shot : MonoBehaviour
{

	public Transform projectilePrefab;
	public float fireRate = 0.5f;
	
	private float nextFire = 0.0f;
	private bool shooting = false;
	

	// Update is called once per frame
	void Update ()
	{
		if (Input.GetButtonDown ("Fire1"))
			shooting = true;
		if (Input.GetButtonUp ("Fire1"))
			shooting = false;
		
		
		if (shooting && Time.time > nextFire) {
			
			
			Ray ray = Camera.main.ScreenPointToRay (Input.mousePosition);
			RaycastHit hit;
			if (Physics.Raycast (ray, out hit, 100000.0f)&&hit.collider.gameObject.tag!="PlayerShip") {
				
				GameObject projectile = (GameObject)Instantiate (projectilePrefab, transform.position + transform.forward * 8, transform.rotation);
				projectile.transform.LookAt (hit.point);
			}else
			{
				
				GameObject projectile = (GameObject)Instantiate (projectilePrefab, transform.position + transform.forward * 8, transform.rotation);
				projectile.transform.LookAt (ray.GetPoint(300.0f));
			}
			
			
			nextFire = Time.time + fireRate;
			
		}
	}
}
