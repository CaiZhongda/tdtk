using UnityEngine;
using System.Collections;

public class Light_Flicker : MonoBehaviour 
{
	public float max = 5;
    public float min = 0.5f;
    public float smoothTime = 10;
    public float time = 0.2f;
    public bool useSmooth;

	// Use this for initialization
	void Start () 
	{
		if (!useSmooth && (this.light != null))
        {
            InvokeRepeating("OneLightChange", time, time);
        }
	}
	
	// Update is called once per frame
	void Update ()
	{
		if (useSmooth && (this.light != null))
        {
            this.light.intensity = Mathf.Lerp(this.light.intensity, Random.Range(min, max), Time.deltaTime * smoothTime);
        }
        if (this.light == null)
        {
            Debug.Log("Please add a light component for light flicker");
        }
	}
	
	public void OneLightChange()
    {
        this.light.intensity = Random.Range(min, max);
    }
}
