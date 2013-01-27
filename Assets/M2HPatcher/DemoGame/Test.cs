using UnityEngine;
using System.Collections;

public class Test : MonoBehaviour
{

    public Texture2D texture;

    void Awake()
    {
        //Instantiate the Patcher runtime class. It will check your server for the latest version number.
        M2HPatcher_Runtime.Init();

    }

    void OnGUI()
    {
        if (texture != null)
        {
            GUI.DrawTexture(new Rect(0, 0, Screen.width, Screen.height), texture, ScaleMode.ScaleToFit);
        }
        GUI.Window(0, new Rect((Screen.width - 300) / 2, (Screen.height - 200) / 2, 300, 200), DoMyWindow, "Game screen");
    }

    void DoMyWindow(int ID)
    {
        if (GUILayout.Button("Quit"))
        {
            Application.Quit();
        }

        GUILayout.Label("This version: " + M2HPatcher_Runtime.GetThisVersion());
        GUILayout.Label("Online version: " + M2HPatcher_Runtime.GetOnlineVersion());
        GUILayout.Label("Loaded version= " + M2HPatcher_Runtime.HasLoadedVersion());
        
        if (M2HPatcher_Runtime.HasLoadedVersion())
        {
            if (M2HPatcher_Runtime.NeedUpdate())
            {
                //We need to update
                if (GUILayout.Button("Update me!"))
                {
                    
                    M2HPatcher_Runtime.QuitAndStartPatcher();
                }
            }
            else
            {
                //The game is up to date
                GUILayout.Label("No update required :)");
            }
        }
    }


}
