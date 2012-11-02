using System;
using UnityEngine;

public class PlanetWithAtmosphereScript : MonoBehaviour
{
    public AtmosphereObject atmosphere;
    public float gValue;
    private float innerRadius;
    public Vector3 lightDirection = new Vector3(0f, 1f, 0f);
    public float mieScatteringConstant;
    private float outerRadius;
    public AtmosphereObject planet;
    public Texture planetDayTexture;
    public Texture planetNightTexture;
    public float rayleighScaleDepth;
    public float rayleighScatteringConstant;
    public float sunIntensity;
    public float wavelengthBlue;
    public float wavelengthGreen;
    public float wavelengthRed;

    private void SetAtmosphereObjectValues()
    {
        this.planet.SetPlanetDayTexture(this.planetDayTexture);
        this.planet.SetPlanetNightTexture(this.planetNightTexture);
        this.planet.SetLightDirection(this.lightDirection);
        this.planet.SetLightWavelength(this.wavelengthRed, this.wavelengthGreen, this.wavelengthBlue);
        this.planet.SetInnerRadius(this.innerRadius);
        this.planet.SetOuterRadius(this.outerRadius);
        this.planet.SetRayleighScatteringConstant(this.rayleighScatteringConstant);
        this.planet.SetMieScatteringConstant(this.mieScatteringConstant);
        this.planet.SetSunIntensity(this.sunIntensity);
        this.planet.SetGValue(this.gValue);
        this.planet.SetRayleighScaleDepth(this.rayleighScaleDepth);
        this.atmosphere.SetLightDirection(this.lightDirection);
        this.atmosphere.SetLightWavelength(this.wavelengthRed, this.wavelengthGreen, this.wavelengthBlue);
        this.atmosphere.SetInnerRadius(this.innerRadius);
        this.atmosphere.SetOuterRadius(this.outerRadius);
        this.atmosphere.SetRayleighScatteringConstant(this.rayleighScatteringConstant);
        this.atmosphere.SetMieScatteringConstant(this.mieScatteringConstant);
        this.atmosphere.SetSunIntensity(this.sunIntensity);
        this.atmosphere.SetGValue(this.gValue);
        this.atmosphere.SetRayleighScaleDepth(this.rayleighScaleDepth);
    }

    private void Start()
    {
        this.SetAtmosphereObjectValues();
    }

    private void Update()
    {
        this.innerRadius = 49.2126f * base.transform.localScale.x;
        this.outerRadius = 50.44292f * base.transform.localScale.x;
        this.SetAtmosphereObjectValues();
    }
}

