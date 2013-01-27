using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System;
using System.IO;


using System.Net;//FTP

[InitializeOnLoad]
public class M2HPatcher_CreatePatch : EditorWindow
{

    /*
     * The patcher compares two folder.
     * It checks the NEW folder for all files..it will compare against the old folder.
     * 
     * - New files ('N') will be stored completely and zipped.
     * - OTHER files will be marked as (possibly) edited. These will all be parsed by the patcher
     * Only files that have changed will be added to the patch, but they will be listed in the PATCHDATA file under E (edited).
     * - Finally, the old folder is compared against the new folder to see if files have been removed ('R') These files will be removed by the patcher.
     */

    public static string TMPFolder()
    {
        string pat = Path.GetTempPath() + "M2HPatcherTMP/";
        M2HPatcher.EnsureFolders(pat);
        return pat;
    }

    public static int MakePatches(int oldVersion, int newVersion)
    {
        if (oldVersion == 0)
        {
            return 0; //NO PATCH NEEDED FOR FIRST VERSION
        }
        //Update patcher info        
        List<string> patchTargets = new List<string>();
        patchTargets.Add("" + BuildTarget.StandaloneLinux);
        patchTargets.Add("" + BuildTarget.StandaloneOSXIntel);
        patchTargets.Add("" + BuildTarget.StandaloneWindows);
        patchTargets.Add("" + BuildTarget.StandaloneWindows64);

        int patches = 0;

        string outputFolder = M2HPatcher.GetBuildFolder(newVersion);

        foreach (string str in patchTargets)
        {
            string patchTitle = str + "_" + oldVersion + "_" + newVersion;
            string oldDir = M2HPatcher.GetBuildFolder(oldVersion) + str;
            string newDir = M2HPatcher.GetBuildFolder(newVersion) + str;
            if (Directory.Exists(newDir))
            {
                if (!Directory.Exists(oldDir))
                {
                    if (oldVersion == M2HPatcher.settingsDev.webVersion)
                    {
                        if (EditorUtility.DisplayDialog("Patch missing", "There is no build for version " + oldVersion + " on platform " + str + ". Do you want to try downloading the latest version from the FTP server? You must be sure that that is version " + oldVersion + ". if you abort, you can manually transfer the right source files and try publishing again.", "OK", "Abort"))
                        {
                            M2HPatcher.DownloadFTPBuildAsVersion(str, oldVersion);
                        }
                        else
                        {
                            return -1;
                        }
                    }
                    else
                    {
                        //No old version available for this platform, but we also cant download from FTP as its not the live version.
                    }
                }
                if (Directory.Exists(oldDir))
                {
                    MakePatchForDir(oldDir, newDir, outputFolder, patchTitle);
                    patches++;
                }
                else
                {
                    EditorUtility.DisplayDialog("Patch missing", "Error: There is no build for version " + oldVersion + " on platform! Patch " + oldVersion + " -> " + newVersion + " could not be made.", "OK");
                }
            }
        }

        return patches;
    }

    static void MakePatchForDir(string from, string to, string outputFolder, string patchTitle)
    {
        string patchFile = "";


        // Files
        ///////

        List<string> filesFrom = new List<string>();
        List<string> filesTo = new List<string>();
        filesFrom.AddRange(Directory.GetFiles(from, "*", SearchOption.AllDirectories));
        filesTo.AddRange(Directory.GetFiles(to, "*", SearchOption.AllDirectories));

        //Tmp folder for patch contents
        string tmpFolder = TMPFolder() + patchTitle + "__" + UnityEngine.Random.Range(0, 99999) + "/";
        M2HPatcher.EnsureFolders(tmpFolder);

        List<string> createPatchesFrom = new List<string>();
        List<string> createPatchesTo = new List<string>();
        List<string> createPatchesOutput = new List<string>();

        //FILE LISTING
        
        foreach (string file in filesTo)
        {
            if (IgnoreFile(file.Replace(to, ""))) continue;
            string fileNameInFrom = from + file.Replace(to, "");
            if (filesFrom.Contains(fileNameInFrom))
            {//EDITFILE               
                patchFile += "E" + file.Replace(to, "").Substring(1) + "\n";
                createPatchesFrom.Add(fileNameInFrom);
                createPatchesTo.Add(file);
                createPatchesOutput.Add(tmpFolder + file.Replace(to, ""));
            }
            else
            {//NEWFILE
                patchFile += "N" + file.Replace(to, "").Substring(1) + "\n";
                string toFilePath = tmpFolder + file.Replace(to, "");
                M2HPatcher.EnsureFolders(toFilePath);
                File.Copy(file, toFilePath, true);
            }
        }

        //Create patches in one loop
        CreatePatches(createPatchesFrom.ToArray(), createPatchesTo.ToArray(), createPatchesOutput.ToArray());

        foreach (string file in filesFrom)
        {
            if (IgnoreFile(file.Replace(from, ""))) continue;
            string path = to + file.Replace(from, "");
            if (!filesTo.Contains(path))
                patchFile += "R" + file.Replace(from, "").Substring(1) + "\n";
        }


        // Directories
        // ADD NEW & REMOVED FOLDERS TO THE PATCHFILE CONTENT
        ////////
        List<string> dirsFrom = new List<string>();
        List<string> dirsTo = new List<string>();
        dirsFrom.AddRange(Directory.GetDirectories(from, "*", SearchOption.AllDirectories));
        dirsTo.AddRange(Directory.GetDirectories(to, "*", SearchOption.AllDirectories));

        foreach (string dir in dirsTo)
        {
            if (IgnoreFile(dir.Replace(to, ""))) continue;
            string fileNameInFrom = from + dir.Replace(to, "");
            if (dirsFrom.Contains(fileNameInFrom))
            {//SAME DIR               
            }
            else
            {//NEWDIR
                patchFile += "C" + dir.Replace(to, "").Substring(1) + "/\n";
            }
        }
        foreach (string dir in dirsFrom)
        {
            if (IgnoreFile(dir.Replace(from, ""))) continue;
            string path = to + dir.Replace(from, "");
            if (!dirsTo.Contains(path))
                patchFile += "R" + dir.Replace(from, "").Substring(1) + "\n";
        }

        //CREATE THE PATCHDATA.M2H FILE
        using (StreamWriter outfile = new StreamWriter(tmpFolder + "PATCHDATA.M2H"))
        {
            outfile.Write(patchFile);
        }

        ZipUtil.ZipFolder(tmpFolder, outputFolder + patchTitle + ".m2hpatch", Ionic.Zlib.CompressionLevel.Level0); //Compression 0 since its already patched
    }

    void CleanTMPFolder()
    {
        try
        {
            Directory.Delete(TMPFolder(), true);
        }
        catch { }


        string[] files = Directory.GetFiles(TMPFolder(), "*", SearchOption.AllDirectories);
        foreach (string file in files)
        {
            try
            {
                File.Delete(file);
            }
            catch { }
        }
    }

    /// <summary>
    /// Used to filter patch specific files that don't need any patching
    /// </summary>
    /// <param name="file"></param>
    /// <returns></returns>
    static bool IgnoreFile(string file)
    {
        if (file.Contains("Patcher_Data")) return true;
        if (file.Contains("Patcher.exe")) return true;
        if (file.Contains("Patcher.app")) return true;
        if (file.Contains("patchsettings.txt")) return true;
        return false;
    }


    public static void WritePatchFileContents(BuildTarget target, string path)
    {
        M2HPatcher.EnsureFolders(path);
        using (StreamWriter outfile = new StreamWriter(path))
        {
            string url = M2HPatcher.settingsDev.webversionURL + "patcher.php";
            outfile.Write("universalPatchInfo=" + url + "\n");
            outfile.Write("thisVersion=" + UtilsPatcher.GetGameVersion() + "\n");
            outfile.Write("BuildTarget=" + target + "\n");
        }
    }


    //
    // CREATE PATCHER APPLICATION
    //

    public static void RebuildPatchers()
    {
        //Copy settings
        bool fullS = PlayerSettings.defaultIsFullScreen;
        int sH = PlayerSettings.defaultScreenHeight;
        int sW = PlayerSettings.defaultScreenWidth;
        ResolutionDialogSetting disReso = PlayerSettings.displayResolutionDialog;
        string prodName = PlayerSettings.productName;
        bool runInBG = PlayerSettings.runInBackground;
        int firstStreamedLevel = PlayerSettings.firstStreamedLevelWithResources;
        Texture2D[] iconsUnknown = PlayerSettings.GetIconsForTargetGroup(BuildTargetGroup.Unknown);
        Texture2D[] iconsSA = PlayerSettings.GetIconsForTargetGroup(BuildTargetGroup.Standalone);
        bool useMacAppStore = PlayerSettings.useMacAppStoreValidation;
        bool overrideForStandaloneIcon = !(iconsSA[0] + "" == ""); //Hacky, but works!




        //Set patcher settings
        Texture2D[] patcherIcons = new Texture2D[1];
        patcherIcons[0] = (Texture2D)AssetDatabase.LoadAssetAtPath("Assets/M2HPatcher/PatchClient/PatchApplication/Art/Icon.png", typeof(Texture2D));
        PlayerSettings.SetIconsForTargetGroup(BuildTargetGroup.Unknown, patcherIcons);
        if (overrideForStandaloneIcon) PlayerSettings.SetIconsForTargetGroup(BuildTargetGroup.Standalone, patcherIcons);

        //Set other settings
        PlayerSettings.defaultIsFullScreen = false;
        PlayerSettings.defaultScreenHeight = 120;
        PlayerSettings.defaultScreenWidth = 410;
        PlayerSettings.displayResolutionDialog = ResolutionDialogSetting.Disabled;
        PlayerSettings.productName = "Patcher";
        PlayerSettings.runInBackground = false;
        PlayerSettings.firstStreamedLevelWithResources = 1;
        PlayerSettings.useMacAppStoreValidation = false;

        // patcher
        string macFile = M2HPatcher.GetBuildFolder() + "/Patchers/Mac/Patcher.app";
        string winFile = M2HPatcher.GetBuildFolder() + "/Patchers/Win/Patcher.exe";
        EnsureFolders(winFile);
        EnsureFolders(macFile);

        try
        {
            //Pro
            string[] levels = new string[1];
            levels[0] = "Assets/M2HPatcher/PatchClient/PatchApplication/patchscene.unity";
            BuildPipeline.BuildPlayer(levels, winFile, BuildTarget.StandaloneWindows, BuildOptions.None);
            BuildPipeline.BuildPlayer(levels, macFile, BuildTarget.StandaloneOSXIntel, BuildOptions.None);
            EditorUtility.DisplayDialog("Patchers rebuild", "The patchers have been rebuilt (In your projects \"Builds\" folder)", "OK");
        }
        catch (Exception)
        {
            //Indie Unity license
            EditorUtility.DisplayDialog("ERROR: Unity Free/Indie", "You need Unity PRO to use M2HPatcher to automatically build patchers and your game builds.", "OK");

            //unzip default patchers
            //EditorUtility.DisplayDialog("ERROR: Unity Free/Indie", "The patchers can only be automatically build from script in Unity Pro. The default patch clients have been unzipped. You can also manually build the patchers instead.", "OK");
            //ZipUtil.UnZip("Assets/M2HPatcher/PatchClient/PatchClient_Mac.zip", "Builds/Patchers/");
            //ZipUtil.UnZip("Assets/M2HPatcher/PatchClient/PatchClient_Win.zip", "Builds/Patchers/");
        }
        string winPath = "Assets/M2HPatcher/PatchClient/bspatch.exe";
        if(File.Exists(winPath))
            File.Copy(winPath, "Builds/Patchers/Win/Patcher_Data/bspatch.exe", true);
        else
            EditorUtility.DisplayDialog("ERROR: patchlients not found", "Patch client could not be found: "+winPath, "OK");

        string macPath = "Assets/M2HPatcher/PatchClient/bspatch";
        if (File.Exists(macPath))
            File.Copy(macPath, "Builds/Patchers/Mac/Patcher.app/Contents/Data/bspatch", true);
        else
            EditorUtility.DisplayDialog("ERROR: patchlients not found", "Patch client could not be found: " + macPath, "OK");      

        //Reset settings
        PlayerSettings.useMacAppStoreValidation = useMacAppStore;
        PlayerSettings.SetIconsForTargetGroup(BuildTargetGroup.Unknown, iconsUnknown);
        if (overrideForStandaloneIcon)
            PlayerSettings.SetIconsForTargetGroup(BuildTargetGroup.Standalone, iconsSA);

        PlayerSettings.defaultIsFullScreen = fullS;
        PlayerSettings.defaultScreenHeight = sH;
        PlayerSettings.defaultScreenWidth = sW;
        PlayerSettings.displayResolutionDialog = disReso;
        PlayerSettings.productName = prodName;
        PlayerSettings.runInBackground = runInBG;
        PlayerSettings.firstStreamedLevelWithResources = firstStreamedLevel;
    }

    //Ensure that the patchers are available to copy
    public static void CheckPatchers()
    {
        if (!File.Exists(M2HPatcher.GetBuildFolder() + "/Patchers/Win/Patcher.exe") || !Directory.Exists(M2HPatcher.GetBuildFolder() + "/Patchers/Mac/Patcher.app"))
        {
            RebuildPatchers();
        }
    }


    static void CreatePatches(string[] filesFrom, string[] filesTo, string[] fileOutput)
    {
        float startTime = GetTime(0);

        int sameFiles = 0;
        int patchFiles = 0;

        float totalOrgBytes = 0;
        float totalPatchBytes = 0;


        for (int i = 0; i < filesTo.Length; i++)
        {
            GC.Collect();

            EditorUtility.DisplayProgressBar(" " + filesFrom[i], Mathf.Round((totalOrgBytes / (1024 * 1024))) + " MB processed", ((float)i) / filesTo.Length);

            FileInfo fileFrom = new FileInfo(filesFrom[i]);
            FileInfo fileTo = new FileInfo(filesTo[i]);
            string patchOutput = fileOutput[i].Replace('\\', '/');
            patchOutput = patchOutput.Replace("//", "/");

            if (File.Exists(fileTo.FullName))
                totalOrgBytes += FileBytes(fileTo.FullName);

            if (!File.Exists(fileTo.FullName) || FilesContentsAreEqual(fileTo, fileFrom))
            {
                sameFiles++;
                continue;
            }
            M2HPatcher.EnsureFolders(patchOutput);

            string fileC = Application.dataPath + "/M2HPatcher/PatchClient/bsdiff.exe";
            string arg = "\"" + fileFrom.FullName + "\" \"" + fileTo.FullName + "\" \"" + patchOutput + "\"";

            EnsureFolders(patchOutput);

            if (Application.platform == RuntimePlatform.OSXEditor || Application.platform == RuntimePlatform.OSXPlayer)
            {
                fileC = Application.dataPath + "/M2HPatcher/PatchClient/bsdiff";
            }

            try
            {
                System.Diagnostics.ProcessStartInfo bla = new System.Diagnostics.ProcessStartInfo(fileC, arg);
                bla.CreateNoWindow = true;
                bla.UseShellExecute = false;
                System.Diagnostics.Process proc = System.Diagnostics.Process.Start(bla);

                proc.WaitForExit();
            }catch(Exception e){
                EditorUtility.ClearProgressBar();
                EditorUtility.DisplayDialog("Error", "CreatePatch could not run the patch application "+fileC+". Make sure it has execution permission (chmod +x)", "Ok");
                Debug.LogError("CreatePatches: Could not run: " + fileC + " " + arg+".\n\n"+e);
            }

            if (File.Exists(patchOutput))
            {
                totalPatchBytes += FileBytes(patchOutput);
                patchFiles++;
            }
            else
                Debug.LogWarning(patchOutput + "  does not exist..");

            EditorUtility.ClearProgressBar();
        }

        EditorUtility.ClearProgressBar();

        totalOrgBytes /= (1024 * 1024);
        totalPatchBytes /= (1024 * 1024);

        Debug.Log("---- PATCH DONE IN " + GetTime(startTime) + " ----\n" +
            "Files:   Same=" + sameFiles + " PatchMade=" + patchFiles + "\n" +
            "Uncompressed size of new target [MB] = " + (totalOrgBytes) + "\n" +
            "Patch size [MB]= " + (totalPatchBytes) + "\n" +
            "Size saved [MB] = " + (totalOrgBytes - totalPatchBytes));

    }


    static int FileBytes(string fileName)
    {
        return File.ReadAllBytes(fileName).Length;
    }
    static byte[] GetFileBytes(string fileName)
    {
        if (!File.Exists(fileName)) return null;
        return File.ReadAllBytes(fileName);
    }

   /* static void SameFile(string fileName)
    {
         fileName = fileName.Replace('\\', '/');
        
         byte[] bytes = File.ReadAllBytes(fileName);        
         fileName = fileName.Replace("C:/Users/Leepo/Desktop/Patched/New/", "");
         string targetFolder = "C:/Users/Leepo/Desktop/Patched/Output/";

         string targetFile = targetFolder + fileName;
         EnsureFolders(targetFile);

         if (File.Exists(targetFile)) {
             File.Delete(targetFile); 
         }
         FileStream fs = File.Create(targetFile);
         fs.Write(bytes, 0, bytes.Length);
         fs.Close();

    }
    */

    public static void EnsureFolders(string path)
    {
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

    public static float GetTime(float startTime)
    {
        return Mathf.Round(((float)UnityEditor.EditorApplication.timeSinceStartup - startTime) * 100) / 100;
    }

    public static byte[] StringToBytes(string str)
    {
        return System.Text.Encoding.UTF8.GetBytes(str);
    }
    public static string BytesToString(byte[] by)
    {
        return System.Text.Encoding.UTF8.GetString(by);
    }



    public static string ReadStringFromFile(string fileName)
    {
        if (!File.Exists(fileName)) return "";

        byte[] _byteList;
        FileStream fs = null;
        BinaryReader br = null;
        try
        {
            fs = new FileStream(fileName, FileMode.Open, FileAccess.Read);
            int len = (int)fs.Length;
            br = new BinaryReader(fs);

            _byteList = br.ReadBytes(len);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            if (br != null) br.Close();
            if (fs != null) fs.Close();
        }

        return (System.BitConverter.ToString(_byteList));
    }


    public static bool FilesContentsAreEqual(FileInfo fileInfo1, FileInfo fileInfo2)
    {
        bool result;

        if (fileInfo1.Length != fileInfo2.Length)
        {
            result = false;
        }
        else
        {
            using (var file1 = fileInfo1.OpenRead())
            {
                using (var file2 = fileInfo2.OpenRead())
                {
                    result = StreamsContentsAreEqual(file1, file2);
                }
            }
        }

        return result;
    }

    private static bool StreamsContentsAreEqual(Stream stream1, Stream stream2)
    {
        const int bufferSize = 2048 * 2;
        var buffer1 = new byte[bufferSize];
        var buffer2 = new byte[bufferSize];

        while (true)
        {
            int count1 = stream1.Read(buffer1, 0, bufferSize);
            int count2 = stream2.Read(buffer2, 0, bufferSize);
            if (count1 != count2)
                return false;
            if (count1 == 0 && count2 == 0)   //added "&& count2==0"         
                return true;

            int iterations = (int)Math.Ceiling((double)count1 / sizeof(Int64));
            for (int i = 0; i < iterations; i++)
            {
                if (BitConverter.ToInt64(buffer1, i * sizeof(Int64)) != BitConverter.ToInt64(buffer2, i * sizeof(Int64)))
                {
                    return false;
                }
            }
        }
    }








}

