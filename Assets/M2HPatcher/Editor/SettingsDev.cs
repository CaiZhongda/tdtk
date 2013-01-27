using System;

using UnityEditor;
using UnityEngine;
using System.Collections;

[System.Serializable]
public class SettingsDev : ScriptableObject
{

    public string buildFolder = "builds";

    public string webPassphrase = "";
    public string webversionURL = "";
    public int webVersion = 1;

    public Ionic.Zlib.CompressionLevel publishZipLevel = Ionic.Zlib.CompressionLevel.Level6;

    public bool doBuildMac = true;
    public bool doBuildWin = true;
    public bool doBuildWebplayer = true;

    public bool uploadPatchesOnly = false; 
    public bool useFTP = true;
    public string ftp_folder = "files/";
    public string ftp_host = "";
    public int ftp_port = 21;
    public string ftp_username = "";
    public string ftp_password = "";

    //public bool useUnityBuildScenes = true;
}