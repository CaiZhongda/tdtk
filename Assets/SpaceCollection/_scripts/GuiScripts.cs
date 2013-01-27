using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class GuiScripts : MonoBehaviour {
  
	
	public GUISkin guiSkin;
	public Material material2;
	
	public Vector2 size;
	public Vector2 position;
	public float distance;
	
	public float timerTick;
	float maxTimer;
	
	Rect colorCollision;
	
	
	//Color baseColorMaterialEmis;
	void Start()
	{
		this.position = new Vector2(position.x, Screen.height - 91);
	}		

	void OnGUI() {
		GUI.skin = guiSkin;
		GUI.depth = 0;
		
		//GUI.Button(new Rect(500.0f, 546.0f, 250, 46),"","ZoomBG");
		
		if(GUI.Button(new Rect(950.0f, Screen.height- 56.0f, 29, 45),"","about"))
			GameObject.Find("Window").GetComponent<Window>().Change();
		
		
	}       

}