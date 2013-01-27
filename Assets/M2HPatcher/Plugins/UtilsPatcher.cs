using UnityEngine;
using System.Collections;
using System.Text.RegularExpressions;


/// <summary>
/// Various helper methods
/// </summary>
public class UtilsPatcher : MonoBehaviour
{

    public static bool IsWebplayer()
    {
        return (Application.platform == RuntimePlatform.OSXDashboardPlayer || Application.platform == RuntimePlatform.OSXWebPlayer || Application.platform == RuntimePlatform.WindowsWebPlayer);
    }
    public static bool IsStandalone()
    {
        return (Application.platform == RuntimePlatform.WindowsPlayer || Application.platform == RuntimePlatform.OSXPlayer);
    }
    public static bool IsEditor()
    {
        return (Application.platform == RuntimePlatform.WindowsEditor || Application.platform == RuntimePlatform.OSXEditor);
    }

    public static bool IsAlfabetical(string input)
    {
        Regex r = new Regex("^[a-z]*$", RegexOptions.IgnoreCase);
        return r.IsMatch(input);
    }

    public static string Md5Sum(string strToEncrypt)
    {
        System.Text.UTF8Encoding ue = new System.Text.UTF8Encoding();
        byte[] bytes = ue.GetBytes(strToEncrypt);

        // encrypt bytes
        System.Security.Cryptography.MD5CryptoServiceProvider md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
        byte[] hashBytes = md5.ComputeHash(bytes);

        // Convert the encrypted bytes back to a string (base 16)
        string hashString = "";

        for (int i = 0; i < hashBytes.Length; i++)
        {
            hashString += System.Convert.ToString(hashBytes[i], 16).PadLeft(2, '0');
        }

        return hashString.PadLeft(32, '0');
    }



    public static int gameVersion = 0;

    public static int GetGameVersion()
    {
        if (gameVersion == 0 || IsEditor())
        {
            SettingsDeploy bla = (SettingsDeploy)Resources.Load("SettingsDeploy", typeof(SettingsDeploy));
            if (bla != null)
                gameVersion = bla.buildVersion;
            else
                Debug.LogError("No buildversion found in Resources!");
        }
        return gameVersion;
    }

    public static string versionURL = "";
    public static string GetVersionURL()
    {
        if (versionURL == "" || IsEditor())
        {
            SettingsDeploy bla = (SettingsDeploy)Resources.Load("SettingsDeploy", typeof(SettingsDeploy));
            if (bla != null)
                versionURL = bla.patcherLink;
            else
                Debug.LogError("No patcherLink found in Resources!");
        }
        return versionURL;
    }




}
