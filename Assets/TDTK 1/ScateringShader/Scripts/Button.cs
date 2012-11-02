using System;
using System.Runtime.InteropServices;
using UnityEngine;

[StructLayout(LayoutKind.Sequential)]
public struct Button
{
    public Rect rect;
    public string url;
    public string skin;
    public Button(Rect rect, string url, string skin)
    {
        this.rect = rect;
        this.url = url;
        this.skin = skin;
    }
}

