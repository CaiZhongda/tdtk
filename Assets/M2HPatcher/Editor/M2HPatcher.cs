using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System;
using System.IO;


using System.Net;//FTP

[InitializeOnLoad]
public class M2HPatcher : EditorWindow
{

    static M2HPatcher()
    {
        LoadSettings();
    }

    // SETTINGS

    public static void LoadSettings()
    {
        ReloadSettingsFromFile();
        SaveSettings();
    }


    public static string GetBuildFolder()
    {
        if (settingsDev.buildFolder[settingsDev.buildFolder.Length - 1] == '/')
            settingsDev.buildFolder = settingsDev.buildFolder.Substring(0, settingsDev.buildFolder.Length - 1);

        if (settingsDev.buildFolder == "")
            return Application.dataPath.Replace("/Assets", "/Builds");
        return settingsDev.buildFolder;
    }


    public static bool VerifyPublishSettings()
    {
        string error = "";
        if (settingsDev.useFTP)
        {
            if (settingsDev.ftp_host == "" || settingsDev.ftp_port <= 0)
            {
                error = "Invalid FTP details, please verify the FTP settings and re-publish.";
            }
        }
        if (settingsDev.webversionURL == "")
        {
            error = "Invalid publish settings: The web version URL must be set.";
        }
        if (settingsDev.webPassphrase == "")
        {
            error = "Invalid publish settings: The web passphrase must be set.";
        } if (error != "")
        {
            EditorUtility.DisplayDialog("Error", error, "OK");
            EditorUtility.ClearProgressBar();
            return false;
        }
        return true;
    }

    public static void Publish()
    {
        if (!VerifyPublishSettings())
            return;

        int thisVersion = UtilsPatcher.GetGameVersion();
        EditorUtility.DisplayProgressBar("Publish", "Starting...", 0);

        EditorUtility.DisplayProgressBar("Publish", "Checking patchers...", 0.1f);
        M2HPatcher_CreatePatch.CheckPatchers();

        //BUILD
        EditorUtility.DisplayProgressBar("Publish", "Building...", 0.5f);
        bool buildOK =  CreateBuilds();
        if (!buildOK)
        {
            EditorUtility.ClearProgressBar();
            EditorUtility.DisplayDialog("Publish error", "Publishing has been aborted due to build errors, please see the console for more information.", "OK");
            return;//Abort: no patches could be made due to an error
        }

        //CREATE PATCHES
        EditorUtility.DisplayProgressBar("Publish", "Creating patches...", 0.5f);
        int result = M2HPatcher_CreatePatch.MakePatches(thisVersion - 1, thisVersion);
        if (result == -1)
        {
            EditorUtility.ClearProgressBar();
            return;//Abort: no patches could be made due to an error
        }

        //ZIP & UPLOAD
        if (settingsDev.useFTP)
        {
            EditorUtility.DisplayProgressBar("Publish", "Zipping & Uploading builds...", 0.5f);
            if (!UploadBuilds(thisVersion))
            {
                //Failed
                EditorUtility.ClearProgressBar();
                EditorUtility.DisplayDialog("Publish error", "Publishing has been aborted due to upload errors.", "OK");        
            }
        }

        EditorUtility.DisplayProgressBar("Publish", "Uploading current version...", 0.9f);
        UploadGameVersion();//Set current version live (e.g. 2)
        Debug.Log("Published version " + thisVersion + "!");


        SetNewGameVersion(UtilsPatcher.GetGameVersion() + 1);//Increase local development version  (e.g. 3)
        EditorUtility.ClearProgressBar();
    }

    static bool UploadBuilds(int newVersion)
    {
        List<string> uploadTargets = new List<string>();
        uploadTargets.Add("" + BuildTarget.StandaloneLinux);
        uploadTargets.Add("" + BuildTarget.StandaloneOSXIntel);
        uploadTargets.Add("" + BuildTarget.StandaloneWindows);
        uploadTargets.Add("" + BuildTarget.StandaloneWindows64);
        uploadTargets.Add("" + BuildTarget.WebPlayer);
        uploadTargets.Add("" + BuildTarget.WebPlayerStreamed);

        if (!settingsDev.uploadPatchesOnly)
        {
            //Zip & upload the builds
            string[] directories = Directory.GetDirectories(M2HPatcher.GetBuildFolder(newVersion), "*", SearchOption.TopDirectoryOnly);
            foreach (string str in directories)
            {
                DirectoryInfo dirInfo = new DirectoryInfo(str);
                string zipPath = M2HPatcher_CreatePatch.TMPFolder() + "/" + dirInfo.Name + ".zip";
                EditorUtility.DisplayProgressBar("Publish", "Zipping " + dirInfo.Name, 0.5f);
                ZipUtil.ZipFolder(str, zipPath, settingsDev.publishZipLevel);
                if (!Upload(zipPath))
                    return false;
            }
        }

        //Upload the patches
        string[] patches = Directory.GetFiles(M2HPatcher.GetBuildFolder(newVersion), "*", SearchOption.TopDirectoryOnly);
        foreach (string str in patches)
        {
            if (!Upload(str))
                return false;
        }
        return true;
    }

    static bool CreateBuilds()
    {
        if (M2HPatcher.settingsDev.doBuildWin)
        {
            if (!DoSimpleBuild(BuildTarget.StandaloneWindows)) return false;
        }
        if (M2HPatcher.settingsDev.doBuildMac)
        {
            if (!DoSimpleBuild(BuildTarget.StandaloneOSXIntel)) return false;
        }
        if (M2HPatcher.settingsDev.doBuildWebplayer) {
            if (!DoSimpleBuild(BuildTarget.WebPlayerStreamed)) return false;
        }
        return true;
    }


    public static void EnsureFolders(string path)
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




    //
    //  VERSION METHODS
    //

    static public void SetNewGameVersion(int newVersion)
    {
        settingsDeploy.buildVersion = newVersion;
        SaveSettings();
    }
    static public void SetPatchLink(string link)
    {
        settingsDeploy.patcherLink = link;
        SaveSettings();
    }

    public static bool UploadGameVersion()
    {
        WWWForm myForm = new WWWForm();
        myForm.AddField("action", "postGameVersion");
        myForm.AddField("gameversion", UtilsPatcher.GetGameVersion());
        bool res = UploadEditorData(myForm);
        if (res)
        {
            settingsDev.webVersion = UtilsPatcher.GetGameVersion();
        }
        return res;
    }

    public static bool UploadEditorData(WWWForm form)
    {
        if (settingsDev.webPassphrase == "")
        {
            EditorUtility.DisplayDialog("Error", "Could not upload editor data, no passphrase set!\nYou can edit this URL in M2HPatcher->Settings.", "OK");
            return false;
        }
        form.AddField("privateKey", settingsDev.webPassphrase); //You can use this for some additional security (check this variable in your PHP file!)
        string wwwURL = settingsDev.webversionURL;
        if (wwwURL == "")
        {
            EditorUtility.DisplayDialog("Error", "Could not upload editor data, invalid URL: " + wwwURL + ".\nYou can edit this URL in M2HPatcher->Settings.", "OK");
            return false;
        }
        wwwURL = wwwURL + "uploadEditorData.php";
        WWW download = new WWW(wwwURL, form);
        while (!download.isDone) { }
        if (download.error != null)
        {
            Debug.LogError("Error in UploadEditorData:  [URL=" + wwwURL + "] " + download.error);
        }
        else
        {
            //OK
            if (download.text == "1")
            {
                return true;
            }
            Debug.LogError("Possible error, webserver did not report OK(1) [URL=" + wwwURL + "] Output="+download.text);
        }
        return false;
    }


    // BUILD CODE
    public static string GetBuildFolder(int version2)
    {
        string version = version2 + "";
        int extraZero = 6 - version.Length;
        while (extraZero > 0)
        {
            version = "0" + version;
            extraZero--;
        }
        return GetBuildFolder() + "/" + version + "/";
    }

    public static bool DoSimpleBuild(BuildTarget target)
    {
        string path = GetBuildFolder(UtilsPatcher.GetGameVersion()) + target.ToString() + "/";
        string name = PlayerSettings.productName;
        return StartBuild(GetBuildScenes(), path, name, target);
    }

    static string[] GetBuildScenes()
    {
        List<string> scenes = new List<string>();
        foreach (EditorBuildSettingsScene scene in EditorBuildSettings.scenes)
        {
            if (scene.enabled)
                scenes.Add(scene.path);
        }
        return scenes.ToArray();
    }

    static bool StartBuild(string[] scenes, string path, string name, BuildTarget target)
    {
        path = path.Replace('\\', '/');
        if (scenes.Length == 0)
        {
            Debug.LogError("No levels selected to build!");
            return false;
        }

        //get right extensions
        Dictionary<BuildTarget, string> extensions = new Dictionary<BuildTarget, string>();
        extensions.Add(BuildTarget.StandaloneOSXIntel, ".app");
        extensions.Add(BuildTarget.StandaloneWindows, ".exe");
        extensions.Add(BuildTarget.StandaloneWindows64, ".exe");
        extensions.Add(BuildTarget.WebPlayer, "");
        extensions.Add(BuildTarget.WebPlayerStreamed, "");
        name = name + extensions[target];

        string outputFile = path + name;
        if (outputFile.Length <= 3)
        {
            Debug.LogError("StartBuild cancelled: Invalid build path:" + outputFile);
            return false;
        }

        string[] folders = path.Split('/');
        for (int i = 0; i < folders.Length - 1; i++)
        {
            string currentpath = folders[i];
            if (i > 0)
            {
                for (int j = i - 1; j >= 0; j--)
                    currentpath = folders[j] + '/' + currentpath;
            }
            if (!Directory.Exists(currentpath))
            {
                Directory.CreateDirectory(currentpath);
            }
        }

        //Only for standalone builds (Mac/Win/Linux)
        if ((target + "").Contains("Standalone"))
        {
            //Copy default documentation etc.
            string[] directories = Directory.GetDirectories("Assets/", "BundleWithGame", SearchOption.AllDirectories);
            foreach (string dir in directories)
            {
                copyDirectory(dir, path);
            }


            //Copy patch client next to build
            if ((target + "").Contains("Windows"))
            {
                copyDirectory(M2HPatcher.GetBuildFolder() + "/Patchers/Win/", path);
                M2HPatcher_CreatePatch.WritePatchFileContents(target, path + "Patcher_Data/patchsettings.txt");
            }
            else
            {
                copyDirectory(M2HPatcher.GetBuildFolder() + "/Patchers/Mac/", path);
                M2HPatcher_CreatePatch.WritePatchFileContents(target, path + "Patcher.app/Contents/Data/patchsettings.txt");
            }
        }

        bool autoRun = false;
        bool autoShow = false;
        BuildOptions bOptions = 0;
        if (autoRun || autoShow)
        {
            if (autoShow && autoShow)
            {
                bOptions = BuildOptions.AutoRunPlayer | BuildOptions.ShowBuiltPlayer;
            }
            else if (autoShow)
            {
                bOptions = BuildOptions.ShowBuiltPlayer;
            }
            else
            {
                bOptions = BuildOptions.AutoRunPlayer;
            }
        }
        string errorR = BuildPipeline.BuildPlayer(scenes, outputFile, target, bOptions);
        if (errorR != "")
        {
            Debug.LogError("Build error: " + errorR);
            return false;
        }
        return true;
    }

    //DIRECTORY HELPER METHODS

    public static void copyDirectory(string Src, string Dst)
    {
        String[] Files;

        if (Dst[Dst.Length - 1] != Path.DirectorySeparatorChar)
            Dst += Path.DirectorySeparatorChar;
        if (!Directory.Exists(Dst)) Directory.CreateDirectory(Dst);
        Files = Directory.GetFileSystemEntries(Src);
        foreach (string Element in Files)
        {
            // Sub directories
            if (Directory.Exists(Element))
                copyDirectory(Element, Dst + Path.GetFileName(Element));
            // Files in directory
            else
                File.Copy(Element, Dst + Path.GetFileName(Element), true);
        }
    }

    // UPLOADING

    static private bool Upload(string filename)
    {
        int ftp_port = settingsDev.ftp_port;
        string hostname = settingsDev.ftp_host;
        string ftpUserID = settingsDev.ftp_username;
        string ftpPassword = settingsDev.ftp_password;
        string ftp_folder = settingsDev.ftp_folder;

        if (hostname == "" || ftp_port <= 0)
        {
            EditorUtility.DisplayDialog("Error", "Invalid FTP details, please verify the FTP settings.", "OK");
            return false;
        }

        if (EditorUserBuildSettings.activeBuildTarget != BuildTarget.StandaloneWindows && EditorUserBuildSettings.activeBuildTarget != BuildTarget.StandaloneWindows64 && EditorUserBuildSettings.activeBuildTarget != BuildTarget.StandaloneOSXIntel)
            EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTarget.StandaloneWindows);

        FileInfo fileInf = new FileInfo(filename);
        FtpWebRequest reqFTP;

        reqFTP = (FtpWebRequest)FtpWebRequest.Create
                 (new Uri("ftp://" + hostname + ":" + ftp_port + "/" + ftp_folder + fileInf.Name));

        reqFTP.Credentials = new NetworkCredential(ftpUserID, ftpPassword);
        reqFTP.KeepAlive = false;
        reqFTP.Method = WebRequestMethods.Ftp.UploadFile;
        reqFTP.UseBinary = true;
        reqFTP.ContentLength = fileInf.Length;

        int buffLength = 2048 * 2;
        byte[] buff = new byte[buffLength];
        int contentLen;
        int bytesDone = 0;
        FileStream fs = fileInf.OpenRead();
        try
        {
            Stream strm = reqFTP.GetRequestStream();
            contentLen = fs.Read(buff, 0, buffLength);

            while (contentLen != 0)
            {
                if (bytesDone % (1024 * 512) == 0) //Per 0.5 MB
                {
                    float progress = bytesDone / (float)fileInf.Length;
                    EditorUtility.DisplayProgressBar("Publish", "Uploading " + fileInf.Name + "  " + (bytesDone / (1024 * 1024)) + " of " + (fileInf.Length / (1024 * 1024)) + " MB", progress);
                }
                strm.Write(buff, 0, contentLen);
                contentLen = fs.Read(buff, 0, buffLength);
                bytesDone += contentLen;
            }
            strm.Close();
            fs.Close();
        }
        catch (Exception ex)
        {
            EditorUtility.ClearProgressBar(); 
            EditorUtility.DisplayDialog("Upload error: ", ex.Message, "OK");
            Debug.LogError("Upload Error: " + ex.Message);
            return false;
        }
        return true;
    }

    public static void DownloadFTPBuildAsVersion(string platform, int oldVersion)
    {
        string fileName = platform + ".zip";

        int ftp_port = settingsDev.ftp_port;
        string hostname = settingsDev.ftp_host;
        string ftpUserID = settingsDev.ftp_username;
        string ftpPassword = settingsDev.ftp_password;
        string ftp_folder = settingsDev.ftp_folder;

        if (EditorUserBuildSettings.activeBuildTarget != BuildTarget.StandaloneWindows && EditorUserBuildSettings.activeBuildTarget != BuildTarget.StandaloneWindows64 && EditorUserBuildSettings.activeBuildTarget != BuildTarget.StandaloneOSXIntel)
            EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTarget.StandaloneWindows);


        EditorUtility.DisplayProgressBar("FTP", "Starting download for " + platform + ".zip.", 0.5f);

        string targetFile = GetBuildFolder(oldVersion) + "/" + platform + ".zip";

        bool foundFile = false;
        try
        {
            FileInfo fileInf = new FileInfo(fileName);
            FtpWebRequest reqFTP;


            string firstChar = ftp_folder.Replace("\\", "/").Substring(0, 1);
            if (firstChar == "/")
            {
                ftp_folder = "%2f" + ftp_folder.Substring(1); // Escape the slash to tell it its an absolute path
                ftp_folder = ftp_folder.Substring(1);
            }

            reqFTP = (FtpWebRequest)FtpWebRequest.Create
                     (new Uri("ftp://" + hostname + ":" + ftp_port + "/" + ftp_folder + fileInf.Name));

            reqFTP.Credentials = new NetworkCredential(ftpUserID, ftpPassword);
            reqFTP.KeepAlive = false;
            reqFTP.Method = WebRequestMethods.Ftp.DownloadFile;
            reqFTP.UseBinary = true;

            FtpWebResponse response = (FtpWebResponse)reqFTP.GetResponse();

            Stream responseStream = response.GetResponseStream();

            M2HPatcher.EnsureFolders(targetFile);
            FileStream writeStream = new FileStream(targetFile, FileMode.Create);
            int Length = 2048;
            Byte[] buffer = new Byte[Length];
            int bytesRead = responseStream.Read(buffer, 0, Length);
            int bytesDone = 0;
            while (bytesRead > 0)
            {
                EditorUtility.DisplayProgressBar("FTP", "Downloading " + fileInf.Name + "." + (bytesDone / (1024 * 1024)) + " MB done.", 0.0f);
                bytesDone += bytesRead;
                writeStream.Write(buffer, 0, bytesRead);
                bytesRead = responseStream.Read(buffer, 0, Length);
            }
            EditorUtility.ClearProgressBar();
            writeStream.Close();
            responseStream.Close();

            foundFile = true;

        }
        catch (Exception ex)
        {
            EditorUtility.ClearProgressBar();
            EditorUtility.DisplayDialog("Download error", "Could not find the requested file.\n\n" + ex.ToString(), "OK");
        }

        if (foundFile)
        {
            string outP = GetBuildFolder(oldVersion) + platform + "/";
            ZipUtil.UnZip(targetFile, outP);
            File.Delete(targetFile);
        }
        else
        {
            //We cant find this file.. we fire an error later.
        }

    }


    #region settings files

    public static string devSettingsAssetPath = "Assets/M2HPatcher/SettingsDev.asset";
    public static string deploySettingsAssetPath = "Assets/M2HPatcher/Resources/SettingsDeploy.asset";
    public static SettingsDev settingsDev;
    public static SettingsDeploy settingsDeploy;

    private static void SaveSettings()
    {
        EditorUtility.SetDirty(settingsDev);
        EditorUtility.SetDirty(settingsDeploy);
    }

    static void ReloadSettingsFromFile()
    {
        settingsDev = (SettingsDev)AssetDatabase.LoadAssetAtPath(devSettingsAssetPath, typeof(SettingsDev));
        settingsDeploy = (SettingsDeploy)AssetDatabase.LoadAssetAtPath(deploySettingsAssetPath, typeof(SettingsDeploy));
        if (settingsDev == null)
        {
            settingsDev = (SettingsDev)ScriptableObject.CreateInstance(typeof(SettingsDev));
            VerifySettingsPath(devSettingsAssetPath);
            AssetDatabase.CreateAsset(settingsDev, devSettingsAssetPath);
        }
        if (settingsDeploy == null)
        {
            settingsDeploy = (SettingsDeploy)ScriptableObject.CreateInstance(typeof(SettingsDeploy));
            VerifySettingsPath(deploySettingsAssetPath);
            AssetDatabase.CreateAsset(settingsDeploy, deploySettingsAssetPath);
        }
    }

    static void VerifySettingsPath(string bla)
    {
        string settingsPath = Path.GetDirectoryName(bla);
        if (!Directory.Exists(settingsPath))
        {
            Directory.CreateDirectory(settingsPath);
            AssetDatabase.ImportAsset(settingsPath);
        }
    }

    #endregion

}

