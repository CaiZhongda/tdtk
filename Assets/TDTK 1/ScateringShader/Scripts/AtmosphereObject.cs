using System;
using UnityEngine;

public class AtmosphereObject : MonoBehaviour
{
    private bool constantMaterialPropertyChanged = true;
    internal float eSun;
    internal float gValue;
    internal float innerRadius;
    internal float km;
    internal float kr;
    internal Vector3 lightDir = new Vector3(0f, 1f, 0f);
    public Material materialFromAtmosphere;
    public Material materialFromSpace;
    internal float outerRadius;
    internal Texture planetNightTexture;
    internal Texture planetTexture;
    internal float rayleighScaleDepth;
    internal float wavelengthBlue;
    internal float wavelengthGreen;
    internal float wavelengthRed;

    private void SetConstantMaterialProperties(Material material)
    {
        material.SetVector("_InvWavelength", new Vector3(1f / Mathf.Pow(this.wavelengthRed, 4f), 1f / Mathf.Pow(this.wavelengthGreen, 4f), 1f / Mathf.Pow(this.wavelengthBlue, 4f)));
        material.SetFloat("_InnerRadius", this.innerRadius);
        material.SetFloat("_InnerRadius2", this.innerRadius * this.innerRadius);
        material.SetFloat("_OuterRadius", this.outerRadius);
        material.SetFloat("_OuterRadius2", this.outerRadius * this.outerRadius);
        material.SetFloat("_KrESun", this.kr * this.eSun);
        material.SetFloat("_KmESun", this.km * this.eSun);
        material.SetFloat("_Km4PI", (this.km * 4f) * 3.141593f);
        material.SetFloat("_Kr4PI", (this.kr * 4f) * 3.141593f);
        material.SetFloat("_Scale", 1f / (this.outerRadius - this.innerRadius));
        material.SetFloat("_ScaleDepth", this.rayleighScaleDepth);
        material.SetFloat("_InvScaleDepth", 1f / this.rayleighScaleDepth);
        material.SetFloat("_ScaleOverScaleDepth", 1f / ((this.outerRadius - this.innerRadius) * this.rayleighScaleDepth));
        material.SetFloat("_GValue", this.gValue);
        material.SetFloat("_GValue2", this.gValue * this.gValue);
    }

    public void SetGValue(float g)
    {
        if (this.gValue != g)
        {
            this.gValue = g;
            this.constantMaterialPropertyChanged = true;
        }
    }

    public void SetInnerRadius(float radius)
    {
        if (this.innerRadius != radius)
        {
            this.innerRadius = radius;
            this.constantMaterialPropertyChanged = true;
        }
    }

    public void SetLightDirection(Vector3 lightDirection)
    {
        if (this.lightDir != lightDirection)
        {
            this.lightDir = lightDirection;
        }
    }

    public void SetLightWavelength(float waveRed, float waveGreen, float waveBlue)
    {
        if (((this.wavelengthRed != waveRed) || (this.wavelengthGreen != waveGreen)) || (this.wavelengthBlue != waveBlue))
        {
            this.wavelengthRed = waveRed;
            this.wavelengthGreen = waveGreen;
            this.wavelengthBlue = waveBlue;
            this.constantMaterialPropertyChanged = true;
        }
    }

    private void SetMaterialProperties(Material material)
    {
        Vector3 position = Camera.mainCamera.transform.position;
        Vector3 vector2 = base.transform.position - position;
        material.SetVector("_CameraPos", position);
        material.SetVector("_SpherePos", base.transform.position);
        material.SetFloat("_CameraHeight", vector2.magnitude);
        material.SetFloat("_CameraHeight2", vector2.sqrMagnitude);
        material.SetVector("_LightDir", this.lightDir.normalized);
    }

    public void SetMieScatteringConstant(float constant)
    {
        if (this.km != constant)
        {
            this.km = constant;
            this.constantMaterialPropertyChanged = true;
        }
    }

    public void SetOuterRadius(float radius)
    {
        if (this.outerRadius != radius)
        {
            this.outerRadius = radius;
            this.constantMaterialPropertyChanged = true;
        }
    }

    public void SetPlanetDayTexture(Texture texture)
    {
        if (this.planetTexture != texture)
        {
            this.planetTexture = texture;
            this.materialFromSpace.mainTexture = this.planetTexture;
            this.materialFromAtmosphere.mainTexture = this.planetTexture;
        }
    }

    public void SetPlanetNightTexture(Texture texture)
    {
        if (this.planetNightTexture != texture)
        {
            this.planetNightTexture = texture;
            this.materialFromSpace.SetTexture("_NightTex", this.planetNightTexture);
            this.materialFromAtmosphere.SetTexture("_NightTex", this.planetNightTexture);
        }
    }

    public void SetRayleighScaleDepth(float scaleDepth)
    {
        if (this.rayleighScaleDepth != scaleDepth)
        {
            this.rayleighScaleDepth = scaleDepth;
            this.constantMaterialPropertyChanged = true;
        }
    }

    public void SetRayleighScatteringConstant(float constant)
    {
        if (this.kr != constant)
        {
            this.kr = constant;
            this.constantMaterialPropertyChanged = true;
        }
    }

    public void SetSunIntensity(float sun)
    {
        if (this.eSun != sun)
        {
            this.eSun = sun;
            this.constantMaterialPropertyChanged = true;
        }
    }

    private void Start()
    {
        this.SetMaterialProperties(this.materialFromSpace);
        this.SetMaterialProperties(this.materialFromAtmosphere);
        if (this.planetTexture != null)
        {
            this.materialFromSpace.mainTexture = this.planetTexture;
            this.materialFromAtmosphere.mainTexture = this.planetTexture;
        }
        if (this.planetNightTexture != null)
        {
            this.materialFromSpace.SetTexture("_NightTex", this.planetNightTexture);
            this.materialFromAtmosphere.SetTexture("_NightTex", this.planetNightTexture);
        }
    }

    private void Update()
    {
        Vector3 position = Camera.mainCamera.transform.position;
        Vector3 vector2 = base.transform.position - position;
        bool flag = false;
        Material material = base.renderer.material;
        if (vector2.magnitude < this.outerRadius)
        {
            base.renderer.material = this.materialFromAtmosphere;
        }
        else
        {
            base.renderer.material = this.materialFromSpace;
        }
        if (material != base.renderer.material)
        {
            flag = true;
        }
        this.SetMaterialProperties(base.renderer.material);
        if (this.constantMaterialPropertyChanged || flag)
        {
            this.SetConstantMaterialProperties(base.renderer.material);
        }
        this.constantMaterialPropertyChanged = false;
    }
}

