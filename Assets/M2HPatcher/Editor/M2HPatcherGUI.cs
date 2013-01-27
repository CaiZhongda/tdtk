using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System;
using System.IO;
using System.Xml;

public class M2HPatcherGUI : EditorWindow
{
    enum GUIState
    {
        main,
        //editFTP,
        customPatch
    }

    [MenuItem("M2HPatcher/Settings")]
    static void Init()
    {
        M2HPatcher.LoadSettings();
        M2HPatcherGUI window = (M2HPatcherGUI)EditorWindow.GetWindow(typeof(M2HPatcherGUI));
        if (window != null) { }
    }

    private GUIState menuState = GUIState.main;
    Texture2D patcherLogo;

    void Awake()
    {
        patcherLogo = (Texture2D)AssetDatabase.LoadAssetAtPath("Assets/M2HPatcher/Editor/PatcherLogo.png", typeof(Texture2D));
    }

    
    void OnGUI()
    {
        GUILayout.Space(3);
        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        if (GUILayout.Button(patcherLogo, new GUIStyle()))
            Application.OpenURL("http://www.M2H.nl/unity");
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();

        switch (menuState)
        {
            //case GUIState.editFTP:
            //    EditFTP();
            //    break;
            case GUIState.customPatch:
                CustomPatch();
                break;
            default:
                MainScreen();
                break;
        }
    }


    void SwitchMenu(GUIState state)
    {
        menuState = state;
    }


    bool editVersion = false;
    bool editFTP = false;
    bool editGeneral = false;

    void MainScreen()
    {

        GUILayout.Label("Settings:", "boldLabel");
        editGeneral = EditorGUILayout.Foldout(editGeneral, "General settings");
        if (editGeneral)
        {
            EditorGUI.indentLevel++;

            //BUILD FOLDER       
            GUILayout.BeginHorizontal();
            GUILayout.Label("Build folder: " + M2HPatcher.settingsDev.buildFolder);
            if (GUILayout.Button("Select folder"))
            {
                string folder = EditorUtility.OpenFolderPanel("Select a build output folder", M2HPatcher.settingsDev.buildFolder, M2HPatcher.settingsDev.buildFolder);
                if (Directory.Exists(folder))
                {
                    folder = folder.Replace(Application.dataPath.Substring(0, Application.dataPath.Length - 6), "");
                    M2HPatcher.settingsDev.buildFolder = folder;
                }
                else if (folder != "")
                {
                    EditorUtility.DisplayDialog("Error", "The folder you selected does not exist!", "Ok");
                }
            }
            GUILayout.EndHorizontal();

            M2HPatcher.settingsDev.doBuildMac = EditorGUILayout.Toggle("Build for Mac:", M2HPatcher.settingsDev.doBuildMac);
            M2HPatcher.settingsDev.doBuildWin = EditorGUILayout.Toggle("Build for Win:", M2HPatcher.settingsDev.doBuildWin);
            M2HPatcher.settingsDev.doBuildWebplayer = EditorGUILayout.Toggle("Build for Webplayer:", M2HPatcher.settingsDev.doBuildWebplayer);
            
            EditorGUILayout.Separator();
            EditorGUI.indentLevel--;
        }


        //VERSION MANAGEMENT
        editVersion = EditorGUILayout.Foldout(editVersion, "Edit build version: " + UtilsPatcher.GetGameVersion());
        if (editVersion)
        {
            EditorGUI.indentLevel++;
            
            string webURL = EditorGUILayout.TextField("URL:", M2HPatcher.settingsDev.webversionURL);
            if (GUI.changed)
            {
                if (webURL.Length>1 && webURL[webURL.Length - 1] != '/')
                    webURL = webURL + "/";
                M2HPatcher.settingsDev.webversionURL = webURL;
                M2HPatcher.SetPatchLink(webURL + "patcher.php");
            }
            M2HPatcher.settingsDev.webPassphrase = EditorGUILayout.TextField("Passphrase:", M2HPatcher.settingsDev.webPassphrase);

            int newVersion = EditorGUILayout.IntField("Version:", UtilsPatcher.GetGameVersion());
            if (newVersion != UtilsPatcher.GetGameVersion())
            {
                M2HPatcher.SetNewGameVersion(newVersion);
            }

            GUILayout.BeginHorizontal();
            GUILayout.Space(105);
            if (GUILayout.Button("Override web version (Now: " + M2HPatcher.settingsDev.webVersion+")", GUILayout.Width(250)))
            {
                if (M2HPatcher.UploadGameVersion())
                {
                    EditorUtility.DisplayDialog("Success", "Set version to " + UtilsPatcher.GetGameVersion(), "Ok");
                }
            }
            GUILayout.EndHorizontal();

            EditorGUILayout.Separator();
            EditorGUI.indentLevel--;
        }


        //EDIT FTP
         editFTP = EditorGUILayout.Foldout(editFTP, "FTP: " + (M2HPatcher.settingsDev.useFTP?"enabled":"disabled"));
         if (editFTP)
         {
             //USER/HOST/PASS..TEST
             //USE FTP
             EditorGUI.indentLevel++;

             M2HPatcher.settingsDev.ftp_port = EditorGUILayout.IntField("Port:", M2HPatcher.settingsDev.ftp_port);
             M2HPatcher.settingsDev.ftp_host = EditorGUILayout.TextField("Host/IP:", M2HPatcher.settingsDev.ftp_host);
             M2HPatcher.settingsDev.ftp_username = EditorGUILayout.TextField("Username:", M2HPatcher.settingsDev.ftp_username);
             M2HPatcher.settingsDev.ftp_password = EditorGUILayout.TextField("Password:", M2HPatcher.settingsDev.ftp_password);
             M2HPatcher.settingsDev.ftp_folder = EditorGUILayout.TextField("Folder:", M2HPatcher.settingsDev.ftp_folder);
             M2HPatcher.settingsDev.useFTP = EditorGUILayout.Toggle("Use FTP:", M2HPatcher.settingsDev.useFTP);
             M2HPatcher.settingsDev.uploadPatchesOnly = EditorGUILayout.Toggle(new GUIContent("Patches only", "Upload patches only (skips full builds)"), M2HPatcher.settingsDev.uploadPatchesOnly);
             
             M2HPatcher.settingsDev.publishZipLevel = (Ionic.Zlib.CompressionLevel)EditorGUILayout.EnumPopup(new GUIContent("Zip level (0-9)", "0= no compression, 1=quickest but worst compression, 9=best(smallest filesize) but slowest compression"), M2HPatcher.settingsDev.publishZipLevel);
             
            
             EditorGUILayout.Separator();
             EditorGUI.indentLevel--;
         }

        GUI.color = Color.white;
        GUILayout.Space(15);
        GUILayout.Label("Other options:", "boldLabel");
        if (GUILayout.Button("Rebuild patcher clients"))
        {
            M2HPatcher_CreatePatch.RebuildPatchers();
        }
        if (GUILayout.Button("Create custom patch"))
        {
            SwitchMenu(GUIState.customPatch);
        }
        if (GUILayout.Button("Documentation"))
        {
            Application.OpenURL("http://www.M2H.nl/files/M2HPatcher.pdf");
        }
        if (GUILayout.Button("Visit M2H.nl/unity"))
        {
            Application.OpenURL("http://www.M2H.nl/unity");
        }
    }

 

    int fromVersion = -1;
    int toVersion = -1;

    void CustomPatch()
    {

       

        if (GUILayout.Button("BACK"))
        {					
            SwitchMenu(GUIState.main);
        }
        GUILayout.Space(15);

        if (toVersion == -1)
        {
            toVersion = UtilsPatcher.GetGameVersion();
            fromVersion = toVersion - 1;
        }


        fromVersion = EditorGUILayout.IntField("From version:", fromVersion);
        toVersion = EditorGUILayout.IntField("To version:", toVersion);

        if(GUILayout.Button("Create patch")){
            int patches = M2HPatcher_CreatePatch.MakePatches(fromVersion, toVersion);
            EditorUtility.DisplayDialog("Created patches", patches + " patches have been made.", "OK");
        }


    }





    [MenuItem("M2HPatcher/Publish")]
    static void Publish()
    {
        M2HPatcher.LoadSettings(); 
        M2HPatcher.Publish();
    }



    [MenuItem("M2HPatcher/SingleBuild/Webplayer")]
    static void Webplayer()
    {
        M2HPatcher.DoSimpleBuild(BuildTarget.WebPlayerStreamed);

        string path = M2HPatcher.GetBuildFolder(UtilsPatcher.GetGameVersion()) + BuildTarget.WebPlayerStreamed.ToString() + "/";
        EditorUtility.DisplayDialog("SingleBuild", "A dev version was built at: " + path + ".\n No version has been increased and no patches were generated. This should be used for dev only. When publishing this build will be overwritten.", "OK");
    }

    [MenuItem("M2HPatcher/SingleBuild/Mac")]
    static void Mac()
    {
        M2HPatcher.DoSimpleBuild(BuildTarget.StandaloneOSXIntel);

        string path = M2HPatcher.GetBuildFolder(UtilsPatcher.GetGameVersion()) + BuildTarget.StandaloneOSXIntel.ToString() + "/";
        EditorUtility.DisplayDialog("SingleBuild", "A dev version was built at: " + path + ".\n No version has been increased and no patches were generated. This should be used for dev only. When publishing this build will be overwritten.", "OK");
    
    }
    [MenuItem("M2HPatcher/SingleBuild/Windows")]
    static void Windows()
    {
        M2HPatcher.DoSimpleBuild(BuildTarget.StandaloneWindows);

        string path = M2HPatcher.GetBuildFolder(UtilsPatcher.GetGameVersion()) + BuildTarget.StandaloneWindows.ToString() + "/";
        EditorUtility.DisplayDialog("SingleBuild", "A dev version was built at: " + path + ".\n No version has been increased and no patches were generated. This should be used for dev only. When publishing this build will be overwritten.", "OK");
    
    }

    [MenuItem("M2HPatcher/SingleBuild/Web+Win+Mac")]
    static void BuildAll()
    {
        Webplayer();
        Windows();
        Mac();

    }


}

