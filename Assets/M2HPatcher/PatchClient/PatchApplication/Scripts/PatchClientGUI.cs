#if !UNITY_WEBPLAYER

using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions; //regex for isnum
using System;

using System.Text;
using System.Security.Cryptography;


public class PatchClientGUI : MonoBehaviour
{
    private bool DEBUG_LOGGING = false; //When set to true, will log quite some more patch client info. E.g. MD5 hashes of files before and after patching

    //Settings
    private string settingfile;

    //Other
    enum PatchStatus { readingsettingsfile = 1, getlatestversioninfo, downloading, unzipping, startinggame, failed }
    PatchStatus currentStatus;
    public string statusText = "";
    public float currentProgressPercent = 0;
    public Texture2D companyLogo;

    public Texture2D barBG;
    public Texture2D progressBar;

    public GUIStyle headerStyle;
    public GUIStyle textStyle;
    public GUIStyle buttonStyle;
    public GUIStyle nullStyle;

    private string patchUpdateLink = "";


    void Awake()
    {
        if (Application.platform == RuntimePlatform.WindowsPlayer)
            settingfile = "Patcher_Data/patchsettings.txt";
        else if (Application.platform == RuntimePlatform.OSXPlayer)
            settingfile = "Patcher.app/Contents/Data/patchsettings.txt";
        else if (Application.platform == RuntimePlatform.WindowsEditor || Application.platform == RuntimePlatform.OSXEditor)
            settingfile = "Patcher.app/Contents/Data/patchsettings.txt"; //settingfile = "Builds/Patchers/Win/Patcher_Data/patchsettings.txt";
        else
            Debug.LogError("INVALID PLATFORM: " + Application.platform);

        Debug.Log("PatchClient Awake, settingsfile: "+settingfile);
    }

 

    IEnumerator Start()
    {
        statusText = "Starting updater...";
        currentStatus = PatchStatus.readingsettingsfile;

        Application.runInBackground = true;

        //Read settings
        Dictionary<string, string> settingsDict = ReadSettings();
        if (currentStatus == PatchStatus.failed) yield break;

        //Get latest version information
        yield return StartCoroutine(GetLatestVersion(settingsDict));
        if (currentStatus == PatchStatus.failed) yield break;
        
        Debug.Log("Start Got the settings and latest online version");

        if (NeedsToUpdate(settingsDict))
        {
            Debug.Log("Start We need to update!");

            //Download and Unzip latest game        
            yield return StartCoroutine(DownloadGame(settingsDict));
            if (currentStatus == PatchStatus.failed) yield break;

            //Write new settings file
            WriteNewSettingsFile(settingsDict);

           /*
            if (IsMac())
            {
               // System.Diagnostics.Process Proc = new System.Diagnostics.Process();
               // Proc.StartInfo.FileName = "FixPermissions.app/Contents/MacOS/applet";
                //Proc.Start();

                SetError("The game has updated, please run the FixPermissions file once. After doing so you can launch the game!");
                yield break;
            }*/

            //Reload patcher to check for further updates OR start game.
            Application.LoadLevel(Application.loadedLevel);
            yield break; //dont run StartGame();
        }
        else
        {
            statusText = "Up to date!";
        }

        //Start the up2date game :)
        StartGame();
    }

    string GetBSPatchFile()
    {
        string file = Directory.GetCurrentDirectory() + "/" + settingfile.Replace("patchsettings.txt", "bspatch");
        if (Application.platform.ToString().Contains("Windows"))
            file += ".exe";
        return file;
    }

    void OnGUI()
    {
        if (GUI.Button(new Rect(Screen.width - 128 - 4, -30, 128, 128), companyLogo, nullStyle))
        {
            Application.OpenURL("http://www.M2H.nl/?refer=patcher");
        }
        //GUI.DrawTexture(new Rect(Screen.width-128-4,-30, 128,128), companyLogo);

        if (currentStatus == PatchStatus.failed)
        {
            GUI.Label(new Rect(10, 4, 250, 30), "Error during update", headerStyle);
            GUI.Label(new Rect(10, 30, 250, 90), errorMessage, textStyle);

            if (GUI.Button(new Rect(10, Screen.height - 25, 100, 20), "Close", buttonStyle))
            {
                Application.Quit();
            }

            if (patchUpdateLink != "")
            {
                if (GUI.Button(new Rect(120, Screen.height - 25, 100, 20), "More information", buttonStyle))
                    Application.OpenURL(patchUpdateLink);
            }
            if (patchUpdateLink == "" && !cannotFindGame)
                if (GUI.Button(new Rect(120, Screen.height - 25, 100, 20), "Launch game", buttonStyle))
                    StartGame();


        }
        else
        {
            GUI.Label(new Rect(10, 4, 250, 30), "Updating the game...", headerStyle);
            GUI.Label(new Rect(10, 25, 200, 30), "Step  " + (int)currentStatus + "/" + (int)PatchStatus.startinggame, textStyle);
            GUI.Label(new Rect(10, 65, 300, 60), statusText, textStyle);

            float percent = currentProgressPercent;
            GUI.DrawTexture(new Rect(7, Screen.height - 30, 386, 22), barBG);
            GUI.DrawTexture(new Rect(8, Screen.height - 28, 382 * percent, 18), progressBar, ScaleMode.ScaleAndCrop);
        }

    }


    Dictionary<string, string> ReadSettings()
    {
        statusText = "Reading settings...";
        Dictionary<string, string> settingsDict = new Dictionary<string, string>();
        if (File.Exists(settingfile))
        {
            StreamReader tr = new StreamReader(settingfile);
            string S = tr.ReadLine();
            while (S != null)
            {
                string[] arr = S.Split('=');
                if (arr.Length == 2)
                {
                    settingsDict.Add(arr[0], arr[1]);
                }
                S = tr.ReadLine();
            }
            tr.Close();
        }
        else
        {
            SetError("Settings file not found: " + settingfile);
            return null;
        }
        if (!CheckSettings(settingsDict))
        {
            return null;
        }
        return settingsDict;
    }

    bool CheckSettings(Dictionary<string, string> settingsDict)
    {
        statusText = "Checking settings...";
        if (!settingsDict.ContainsKey("universalPatchInfo"))
        {
            SetError("Error parsing setting file, 'universalPatchInfo' is missing.");
            return false;
        }
        /*if (settingsDict.ContainsKey("thisVersion"))
        {
            string versionnumber = settingsDict["thisVersion"];
            if (!IsNumeric(versionnumber))
            {
                SetError("Error parsing setting file settings file 'thisVersion' is not numeric");
                return false;
            }
        }*/
        return true;
    }

    IEnumerator GetLatestVersion(Dictionary<string, string> settingsDict)
    {
        statusText = "Downloading latest version information...";
        currentStatus = PatchStatus.getlatestversioninfo;
        WWWForm form = new WWWForm();
        form.AddField("platform", "" + Application.platform);

        string curVersion = "0";
        if (settingsDict.ContainsKey("thisVersion")) curVersion = settingsDict["thisVersion"];
        form.AddField("clientsversion", "" + curVersion);
        form.AddField("buildTarget", "" + settingsDict["BuildTarget"]);

        WWW www = new WWW(settingsDict["universalPatchInfo"], form);

        while (!www.isDone)
        {
            currentProgressPercent = www.progress;
            yield return 0;
        }

        yield return www;
        if (www.error != null)
        {
            SetError("Couldn't connect to the patch server.");
            yield break;
        }
        else
        {
            Debug.Log("GetLatestVersion=" + www.text);
            string info = www.text;
            if (info.Substring(0, 1) != "1")
            {
                SetError("Unable to connect to update server.");
                yield break;
            }

            string[] infoArray = info.Substring(1).Split('#');
            if (infoArray.Length < 3)
            {
                SetError("Latest version information is wrong (" + infoArray.Length + " <- should >=3)");
                yield break;
            }

            settingsDict.Add("latestVersion", infoArray[0]);
            settingsDict.Add("patchVersion", infoArray[1]);
            settingsDict.Add("downloadlink", infoArray[2]);
            settingsDict.Add("disabledLink", infoArray[3]);

            if (settingsDict["disabledLink"].Length >= 4)
            {
                patchUpdateLink = settingsDict["disabledLink"];
                SetError("Couldn't update, please click the button below for more information.");
                yield break;
            }

        }

    }

    bool NeedsToUpdate(Dictionary<string, string> settingsDict)
    {
        if (settingsDict.ContainsKey("thisVersion"))
        {
            int thisVersion = int.Parse("0" + settingsDict["thisVersion"]);
            int onlineVersion = int.Parse("0" + settingsDict["latestVersion"]);
            Debug.Log("NeedsToUpdate? thisVersion=" + thisVersion + " onlineVersion=" + onlineVersion);
            if (thisVersion < onlineVersion)
                return true;
            else
                return false;
        }
        else
        {
            Debug.LogError("settingsDict has no thisVersion!");
            return true;
        }
    }



    IEnumerator DownloadGame(Dictionary<string, string> settingsDict)
    {
        statusText = "Starting download...";
        currentStatus = PatchStatus.downloading;
        WWW www = new WWW(settingsDict["downloadlink"]);

        while (!www.isDone)
        {
            currentProgressPercent = www.progress;
            statusText = "Downloading patch " + settingsDict["thisVersion"] + " -> " + settingsDict["patchVersion"] + ": " + Mathf.Round(www.progress * 100) + "%"; //\nTime passed:" + Mathf.Round(Time.realtimeSinceStartup - downloadStarted) + " seconds - Remaining:" + Mathf.Ceil(remain) + " seconds";

            yield return 0;
        }
        if (www.error != null && www.error != "" || www.bytes.Length<=0)
        {
            SetError("Download failed for: "+www.url);
            yield break;
        }

        currentStatus = PatchStatus.unzipping;

        statusText = "Unzipping...";
        yield return 0;
        //Process the update: unzip, copy/patch/remove
        string tmpRoot = TMPFolder();
        string tmpFolder = tmpRoot + Application.platform + settingsDict["latestVersion"] + "/";
        if (!UnzipUpdate(www, tmpFolder))
        {
            DeleteDirectory(tmpRoot); 
            yield break;
        }
        if (!ProcessUpdateData(tmpFolder))
        {
            DeleteDirectory(tmpRoot); 
            yield break;
        }
        DeleteDirectory(tmpRoot);

        Debug.Log("Applied patch " + settingsDict["patchVersion"] + " on version " + settingsDict["thisVersion"] + " latest=" + settingsDict["latestVersion"]+" downloadLink="+settingsDict["downloadlink"]);      
        settingsDict["thisVersion"] = settingsDict["patchVersion"];
    }

     bool ProcessUpdateData(string folder)
    {
        folder = folder.Replace('\\', '/');

        string patchData = folder + "PATCHDATA.M2H";
		Debug.Log(patchData);
        if (File.Exists(patchData))
        {
            StreamReader tr = new StreamReader(patchData);
            string patchInfoLine = tr.ReadLine();
			
            while (patchInfoLine != null)
            {
			    Debug.Log(patchInfoLine);
               if (patchInfoLine.Length > 3)
                {
                    string from = (folder + patchInfoLine.Substring(1)).Replace('\\', '/');
                    string to = (Directory.GetCurrentDirectory() + "/" + patchInfoLine.Substring(1)).Replace('\\', '/');
                    string fromParent = Directory.GetParent(from).FullName.Replace('\\', '/') + "/";
                    string toParent = Directory.GetParent(to).FullName.Replace('\\', '/');

                    if (!fromParent.Contains(folder))
                    {
                        SetError("Cannot grab file outside of source folder! " + fromParent + " and " + folder);
                        return false;
                    }
                    if (!toParent.Contains(Directory.GetCurrentDirectory().Replace('\\', '/')))
                    {
                        SetError("Cannot write to file outside of current dir!" + toParent + " and " + Directory.GetCurrentDirectory());
                        return false;
                    }

                    if (patchInfoLine.Substring(0, 1) == "C")
                    {
                        //CREATE DIRECTORY
                        EnsureFolders(to);

                    }else if (patchInfoLine.Substring(0, 1) == "E")
                    {
						Debug.Log("FROM="+from+"   to="+to);
                        if (!File.Exists(from))
                        {
                            //This is OK, this file has not changed
                        }
                        else
                        {
                            if (!File.Exists(to))
                            {
                                SetError("One of the patch files does not exist! " + from + " OR " + to);
                                return false;
                            }
                            Debug.Log("Apply patch " + from + " to " + to);
                            if (!ApplyPatch(from, to))
                            {   //Failed
                                SetError("Could not apply patch (Developer: see logfile)");
                                return false;
                            }
                        }
                        
                    }
                    else if (patchInfoLine.Substring(0, 1) == "N")
                    {
                        Debug.Log("Copy " + from + " to " + to);
                        if (!File.Exists(from))
                        {
                            SetError("Copy file does not exist! " + from);
                            return false;
                        }
                        EnsureFolders(to);
                        File.Copy(from, to, true);
                    }
                    else if (patchInfoLine.Substring(0, 1) == "R")
                    {
                        Debug.Log("Remove: " + to);
                        if (Directory.Exists(to))
                            DeleteDirectory(to);
                        else if (File.Exists(to))
                            File.Delete(to);
                    }
                    else
                    {
                        SetError("Invalid patch data, unknown action: [" + patchInfoLine + "]");
                        return false;
                    }
                }
                patchInfoLine = tr.ReadLine();
            }
            tr.Close();
        }
        else
        {
            SetError("Invalid patch data, no PATCHDATA.M2H file found! Searched for: [" + patchData + "]");
            return false;
        }
        return true;
    }

    bool ApplyPatch(string from, string to)
    {     
        string fileC = GetBSPatchFile();
        string arg = "\""+ to + "\" \"" + to +"\" " + "\""+ from+"\"";

        
        Debug.LogWarning(" FBSPatchile:" + fileC);
        Debug.Log(arg + " CALLED");

        if (DEBUG_LOGGING) Debug.Log("BEFORE md5=" + MD5FromFile(to));
        try
        {
            System.Diagnostics.ProcessStartInfo bla = new System.Diagnostics.ProcessStartInfo(fileC, arg);
            bla.CreateNoWindow = true;
            bla.UseShellExecute = false;
            System.Diagnostics.Process proc = System.Diagnostics.Process.Start(bla);
           
            proc.WaitForExit();        
        }
        catch (Exception e)
        {
            Debug.LogError("Problem applying patch. Does the file have execution permission? (chmod +x) " + fileC+" "+arg+". \n\n"+e);
            return false;
        }
        if (DEBUG_LOGGING) Debug.Log("AFTER md5=" + MD5FromFile(to));
        
        return true;
    }

    bool UnzipUpdate(WWW www, string tmpFolder)
    {
        EnsureFolders(tmpFolder);
        try
        {
            ZipUtil.UnZipBytes(www.bytes, tmpFolder);
            Debug.Log("Unzipped to:" + tmpFolder);
        }
        catch (Exception ex)
        {
            SetError("Couldn't unzip the latest update, do you have sufficient disk space? " + ex);
            Debug.Log("Bytes:" + www.bytes.Length + " tmpFolder=" + tmpFolder);
			Debug.Log("Text:" + www.text);
			
            return false;
        }
        return true;
    }



    static string TMPFolder()
    {
        string pat = "M2HPatcherTMP/";//Path.GetTempPath() + "M2HPatcherTMP/";
        EnsureFolders(pat);
        return pat;
    }
    static void EnsureFolders(string path)
    {
        path = path.Replace('\\', '/');
        string[] folders = path.Split('/');
        for (int i = 0; i < folders.Length - 1; i++)
        {
            string currentpath = folders[i];
            if (i > 0)
            {
                for (int j = i - 1; j >= 0; j--)
                    currentpath = folders[j] + '/' + currentpath;
            }
            if (currentpath == "") continue;
            if (!Directory.Exists(currentpath))
            {
                Directory.CreateDirectory(currentpath);
            }
        }
    }


    void WriteNewSettingsFile(Dictionary<string, string> settingsDict)
    {
		Debug.Log("Saving new settings file: "+settingfile+"  version="+settingsDict["thisVersion"] );
        statusText = "Saving settings...";
        StreamWriter SW;
        SW = File.CreateText(settingfile);
        SW.WriteLine("universalPatchInfo=" + settingsDict["universalPatchInfo"]);
        SW.WriteLine("thisVersion=" + settingsDict["thisVersion"]);
        SW.WriteLine("BuildTarget=" + settingsDict["BuildTarget"]);        
        SW.Close();
    }

    string GetExecutableInDir(string currentDir)
    {
        DirectoryInfo di = new DirectoryInfo(currentDir);
        FileInfo[] rgFiles = di.GetFiles("*.exe");
        foreach (FileInfo fi in rgFiles)
        {
            if (!fi.Name.Contains("Patcher"))
                return currentDir + "/" + fi.Name;
        }
        return "";
    }
    string GetExecutable()
    {
        //Find first exe that isnt the M2HUpdater.exe
        string filename = "";
        string currentDir = Directory.GetCurrentDirectory();

        filename = GetExecutableInDir(currentDir);
        if (filename != "") return filename;

        DirectoryInfo m_dir = new DirectoryInfo(currentDir);
        foreach (DirectoryInfo dinfo in m_dir.GetDirectories("*.*"))
        {
            filename = GetExecutableInDir(dinfo.FullName);
            if (filename != "") return filename;
        }
        return filename;
    }

    string GetMacApp()
    {
        //Find first .app folder that isnt M2HPatcher
        string currentDir = Directory.GetCurrentDirectory();
        DirectoryInfo m_dir = new DirectoryInfo(currentDir);
        foreach (DirectoryInfo dinfo in m_dir.GetDirectories("*.app"))
        {
            if (!dinfo.Name.Contains("Patcher"))
                return GetMacApp2(dinfo.FullName + "/Contents/MacOS/");
        }
        return "";
    }

    string GetMacApp2(string currentDir)
    {
        //Find first file
        Debug.Log("Getfile for:" + currentDir);
        DirectoryInfo di = new DirectoryInfo(currentDir);
        FileInfo[] rgFiles = di.GetFiles("*");
        foreach (FileInfo fi in rgFiles)
        {
            Debug.Log("AMcfile: " + fi.FullName);
            return fi.FullName;
        }
        return "";
    }

    bool IsWindows()
    {
        return Application.platform == RuntimePlatform.WindowsEditor || Application.platform == RuntimePlatform.WindowsPlayer;
    }
    bool IsMac()
    {
        return Application.platform == RuntimePlatform.OSXEditor || Application.platform == RuntimePlatform.OSXPlayer;
    }

    private bool cannotFindGame = false;

    void StartGame()
    {
        statusText = "About to start game...";
        string filename = "";
        if (IsWindows())
            filename = GetExecutable();
        else if (IsMac())
            filename = GetMacApp();
        else
        {
            SetError("Unsupported platform!");
            return;
        }

        currentStatus = PatchStatus.startinggame;

        if (!System.IO.File.Exists(filename))
        {
            cannotFindGame = true;
            SetError("Could not find the application when trying to execute the game!");
            return;
        }
        System.Diagnostics.Process Proc = new System.Diagnostics.Process();
        Proc.StartInfo.FileName = filename;
        Proc.Start();

        Application.Quit();
    }

    string errorMessage = "";

    void SetError(string err)
    {
        Debug.LogError("SetError: " + err);
        currentStatus = PatchStatus.failed;
        errorMessage = err;
    }


    private bool IsNumeric(string strTextEntry)
    {
        Regex objNotWholePattern = new Regex("[^0-9]");
        return !objNotWholePattern.IsMatch(strTextEntry)
             && (strTextEntry != "");
    }

    public static bool DeleteDirectory(string target_dir)
    {
        bool result = false;

        string[] files = Directory.GetFiles(target_dir);
        string[] dirs = Directory.GetDirectories(target_dir);

        foreach (string file in files)
        {
            File.SetAttributes(file, FileAttributes.Normal);
            File.Delete(file);
        }

        foreach (string dir in dirs)
        {
            DeleteDirectory(dir);
        }

        Directory.Delete(target_dir, false);

        return result;
    }


    public static string MD5FromFile(string filename)
    {
        StringBuilder sb = new StringBuilder();
        FileStream fs = new FileStream(filename, FileMode.Open);
        MD5 md5 = new MD5CryptoServiceProvider();
        byte[] hash = md5.ComputeHash(fs);
        fs.Close();
        foreach (byte hex in hash)
            sb.Append(hex.ToString("x2"));
        return sb.ToString();
    }
}


#endif