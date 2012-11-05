using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(AsteroidField))]
public class AsteroidFieldEditor : Editor
{
	bool addRigid = true;
	bool addCollider = true;
	bool addAsteroid = true;
	bool addDamagable = true;
	bool addMaterial = true;
	AsteroidField field;
	public override void OnInspectorGUI ()
	{
		
		// Get the place of the next available position in the script
		field = (AsteroidField)target;
		
		
		base.OnInspectorGUI ();
		
		if (GUILayout.Button ("Load asteroids from resources")) {
			Object[] objects = Resources.LoadAll ("Asteroids", typeof(GameObject));
			GameObject[] asteroids = new GameObject[objects.Length];
			for (int i = 0; i < objects.Length; i++) {
				asteroids[i] = (GameObject)objects[i];
			}
			field.prefabs = asteroids;
			
		}
		
		addRigid = EditorGUILayout.Toggle ("Add RigidBody", addRigid);
		addCollider = EditorGUILayout.Toggle ("Add BoxCollider", addCollider);
		addAsteroid = EditorGUILayout.Toggle ("Add Asteroid script", addAsteroid);
		addDamagable = EditorGUILayout.Toggle ("Add DamagableObject", addDamagable);
		addMaterial = EditorGUILayout.Toggle ("Assign same material to asteroid", addMaterial);
		
		
		
		if (GUILayout.Button ("Generate")) {
			GenerateAsteroids (addRigid, addCollider, addAsteroid, addDamagable, addMaterial);
		}
	}

	public void GenerateAsteroids (bool addRigid, bool addCollider, bool addAsteroid, bool addDamagable, bool addMaterial)
	{
		
		while (field.transform.childCount > 0) {
			foreach (Transform child in field.transform) {
				
				if (!EditorApplication.isPlaying) {
					DestroyImmediate (child.gameObject);
				} else {
					Destroy (child.gameObject);
				}
			}
		}
		
		for (int i = 0; i < field.count; i++) {
			GenerateAsteroid (addRigid, addCollider, addAsteroid, addDamagable, addMaterial);
		}
	}

	void GenerateAsteroid (bool addRigid, bool addCollider, bool addAsteroid, bool addDamagable, bool addMaterial)
	{
		if (field.prefabs.Length > 0) {
			
			Vector3 pos = new Vector3 ((Random.value - 0.5f) * field.width, (Random.value - 0.5f) * field.height, (Random.value - 0.5f) * field.length) + field.transform.position;
			GameObject prefab = field.prefabs[Random.Range (0, field.prefabs.Length)];
			GameObject asteroid = (GameObject)EditorUtility.InstantiatePrefab (prefab);
			asteroid.transform.position = pos;
			asteroid.transform.rotation = Random.rotation;
			asteroid.transform.parent = field.transform;
			if (addRigid && asteroid.rigidbody == null) {
				Rigidbody rig = asteroid.AddComponent<Rigidbody> ();
				rig.useGravity = false;
				rig.angularDrag = 0;
			}
			if (addCollider && asteroid.collider == null) {
				asteroid.AddComponent<BoxCollider> ();
				
			}
			if (addDamagable && asteroid.GetComponent<DamagableObject> () == null) {
				asteroid.AddComponent<DamagableObject> ();
				
			}
			if (addAsteroid && asteroid.GetComponent<Asteroid> () == null) {
				Asteroid ast = asteroid.AddComponent<Asteroid> ();
				ast.detonator = field.basicDetonator;
			}
			if (addMaterial) {
				asteroid.renderer.material = field.asteroidMaterial;
			}
			
			bool collides = false;
			float maxSizeAsteroid = Mathf.Max (asteroid.collider.bounds.size.x, asteroid.collider.bounds.size.y, asteroid.collider.bounds.size.z);
			
			do {
				
				
				collides = false;
				foreach (Transform item in field.transform) {
					if (item != asteroid.transform) {
						
						float itemSize = Mathf.Max (item.collider.bounds.size.x, item.collider.bounds.size.y, item.collider.bounds.size.z);
						
						if (Vector3.Distance (asteroid.transform.position, item.position) < maxSizeAsteroid + itemSize) {
							collides = true;
						}
						//Debug.Log (Vector3.Distance (asteroid.transform.position, item.position) + "  " + (maxSizeAsteroid + itemSize));
					}
				}
				if (collides) {
					pos = new Vector3 ((Random.value - 0.5f) * field.width, (Random.value - 0.5f) * field.height, (Random.value - 0.5f) * field.length) + field.transform.position;
					asteroid.transform.position = pos;
					
				}
			} while (collides);
			
		}
		
	}
	
}
