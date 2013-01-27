using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using Ionic.Zip;
using I18N;
using I18N.CJK;
using I18N.MidEast;
using I18N.Other;
using I18N.Rare;
using I18N.West;

using UnityEngine;

public static class ZipUtil
{


    private static List<string> GenerateFileList(string Dir)
    {
        List<string> fils = new List<string>();
        bool Empty = true;
        foreach (string file in Directory.GetFiles(Dir)) // add each file in directory
        {
            fils.Add(file);
            Empty = false;
        }

        if (Empty)
        {
            if (Directory.GetDirectories(Dir).Length == 0)
            // if directory is completely empty, add it
            {
                fils.Add(Dir + @"/");
            }
        }

        foreach (string dirs in Directory.GetDirectories(Dir)) // recursive
        {
            foreach (object obj in GenerateFileList(dirs))
            {
                fils.Add((string)obj);
            }
        }
        return fils; // return file list
    }


    public static void UnZip(string file, string outputFolder)
    {

        using (ZipFile zip = ZipFile.Read(file))
        {
            foreach (ZipEntry e in zip)
            {
                string fullPad = outputFolder + e.FileName;

                EnsureFolders(fullPad);
                
                if (!Directory.Exists(fullPad))
                {
                    FileStream fs = new FileStream(fullPad, FileMode.Create);
                    e.Extract(fs);
                    fs.Close();
                }
            }
        }
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

    public static void UnZipBytes(byte[] bytess, string outputFolder)
    {
        Stream ss = new MemoryStream(bytess);
        using (ZipFile zip = ZipFile.Read(ss))
        {
            foreach (ZipEntry e in zip)
            {
                string fullPad = outputFolder + e.FileName;
                EnsureFolders(fullPad);
                if (!Directory.Exists(fullPad))
                {
                    FileStream fs = new FileStream(fullPad, FileMode.Create);
                    e.Extract(fs);
                    fs.Close();
                }


                //e.Extract(outputFolder, ExtractExistingFileAction.OverwriteSilently);
            }
        }
    }

    public static void ZipFolder(string inputFolder, string outputFile, Ionic.Zlib.CompressionLevel level)
    {
        using (ZipFile zip = new ZipFile())
        {
            zip.CompressionLevel = level;
            zip.AddDirectory(inputFolder, "");
            //zip.AddFiles(GenerateFileList(inputFolder)); 
            //zip.AddDirectory(inputFolder);
            zip.Save(outputFile);
        }
    }


}