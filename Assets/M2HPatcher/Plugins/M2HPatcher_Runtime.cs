using UnityEngine;
using System.Collections;

public class M2HPatcher_Runtime : MonoBehaviour
{

    static int onlineVersion = -1;

    static M2HPatcher_Runtime()
    {
        //Spawn GO with this script attached to it.
        GameObject myGO = new GameObject();
        myGO.AddComponent<M2HPatcher_Runtime>();
        myGO.name = "M2HPatcher_Runtime";
        myGO.hideFlags = HideFlags.HideInHierarchy;

    }

    /// <summary>
    /// Calling Init will start a call to check the online version number (via Awake)
    /// </summary>
    public static void Init()
    {
        //Nothing here, this is on purpose!
    }

    void Awake()
    {
        //SP = this;
        StartCoroutine(CheckVersion());
    }


    public static IEnumerator CheckVersion()
    {
        string urly = UtilsPatcher.GetVersionURL();
        WWWForm form = new WWWForm();
        form.AddField("action", "versiononly");
        form.AddField("platform", "" + Application.platform);
        form.AddField("clientsversion", "" + UtilsPatcher.GetGameVersion());

        WWW www = new WWW(urly, form);
        while (!www.isDone)
        {
            yield return 0;
        }

        yield return www;
        if (www.error != null)
        {
            Debug.LogError("Couldn't connect to the version URL: " + urly);
            yield break;
        }
        else
        {
            string info = www.text;
            if (info.Substring(0, 1) != "1")
            {
                Debug.LogError("Unable to connect to version server." + UtilsPatcher.GetVersionURL() + "\n" + info);
                yield break;
            }

            string[] infoArray = info.Substring(1).Split('#');
            if (infoArray.Length < 3)
            {
                Debug.LogError("Latest version information is wrong (" + infoArray.Length + " <- should be >=3)");
                yield break;
            }

            onlineVersion = int.Parse(infoArray[0]);
            
        }
    }

    public static int GetOnlineVersion()
    {
        return onlineVersion;
    }

    public static int GetThisVersion()
    {
        return UtilsPatcher.GetGameVersion();
    }

    public static bool HasLoadedVersion()
    {
        return onlineVersion >= 0;
    }

    public static bool NeedUpdate()
    {
        if (!HasLoadedVersion())
        {
            Debug.LogWarning("You are calling NeedUpdate(); before it has loaded the online version. Check HasLoadedVersion(); before calling NeedUpdate!");
            return false;
        }
        return GetOnlineVersion() > UtilsPatcher.GetGameVersion();
    }

    public static void QuitAndStartPatcher()
    {
        //Start patcher (same directory)
        try
        {
            System.Diagnostics.Process Proc = new System.Diagnostics.Process();
            if (!Application.platform.ToString().Contains("Windows"))
                Proc.StartInfo.FileName = "Patcher.app/Contents/MacOS/Patcher";
            else
                Proc.StartInfo.FileName = "Patcher.exe";
            Proc.Start();
        }
        catch (System.Exception e)
        {
            Debug.LogError("Could not QuitAndStartPatcher. The patch client could not be found or has no execution permission.\n\n" +e);
        }

        Application.Quit();
    }
}
