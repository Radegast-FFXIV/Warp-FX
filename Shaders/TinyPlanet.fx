/*-----------------------------------------------------------------------------------------------------*/
/* Tiny Planet Shader v1.0 - by Radegast Stravinsky of Ultros.                                         */
/* There are plenty of shaders that make your game look amazing. This isn't one of them.               */
/*-----------------------------------------------------------------------------------------------------*/

#include "Include/TinyPlanet.fxh"
texture texColorBuffer : COLOR;
texture texDepthBuffer : DEPTH;


texture TinyPlanetTarget
{
    Width = BUFFER_WIDTH;
    Height = BUFFER_HEIGHT;
    MipLevels = LINEAR;
    Format = RGBA8;
};


sampler samplerColor
{
    Texture = texColorBuffer;

    AddressU = WRAP;
    AddressV = WRAP;
    AddressW = WRAP;

    MagFilter = LINEAR;
    MinFilter = LINEAR;
    MipFilter = LINEAR;

    MinLOD = 0.0f;
    MaxLOD = 1000.0f;

    MipLODBias = 0.0f;

    SRGBTexture = false;
};

sampler samplerDepth
{
    Texture = texDepthBuffer;
    Width = BUFFER_WIDTH;
    Height = BUFFER_HEIGHT;
};

sampler samplerTarget
{
    Texture = TinyPlanetTarget;
    AddressU = WRAP;
    AddressV = WRAP;
    AddressW = WRAP;

    MagFilter = LINEAR;
    MinFilter = LINEAR;
    MipFilter = LINEAR;

    MinLOD = 0.0f;
    MaxLOD = 1000.0f;

    MipLODBias = 0.0f;

    SRGBTexture = false;
};


// Vertex Shaders
void FullScreenVS(uint id : SV_VertexID, out float4 position : SV_Position, out float2 texcoord : TEXCOORD0)
{
    texcoord.x = (id == 2) ? 2.0 : 0.0;
    texcoord.y = (id == 1) ? 2.0 : 0.0;
    
    position = float4( texcoord * float2(2, -2) + float2(-1, 1), 0, 1);
}

// Pixel Shaders (in order of appearance in the technique)
void DoNothingPS(float4 pos : SV_Position, float2 texcoord : TEXCOORD0, out float4 color : SV_TARGET)
{
    color = tex2D(samplerColor, texcoord);
}

float4 TinyPlanet(float4 pos : SV_Position, float2 texcoord : TEXCOORD0) : SV_TARGET
{
    float ar = 1.0f * (float)BUFFER_HEIGHT/(float)BUFFER_WIDTH;
    
    float3 rot = float3(center_x,center_y, z_rotation);
    float3x3 t=getrot(rot);

    float2 rads = float2(PI*2.0 , PI);
    float2 offset=float2(offset_x,offset_y);
    float2 pnt = (texcoord - .5-offset).xy * float2(scale, scale*ar);

    // Project to Sphere
    float x2y2 = pnt.x * pnt.x + pnt.y * pnt.y;
    float3 sphere_pnt = float3(2. * pnt, x2y2 - 1.0) / (x2y2 + 1.0);
    
    sphere_pnt = mul(sphere_pnt, t);

    // Convert to Spherical Coordinates
    float r = length(sphere_pnt);
    float lon = atan2(sphere_pnt.y, sphere_pnt.x);
    float lat = acos(sphere_pnt.z / r);

    return tex2D(samplerTarget, float2(lon, lat)/rads);
}

// Technique
technique TinyPlanet
{
    pass p0
    {
       
        VertexShader = FullScreenVS;
        PixelShader = DoNothingPS;

        RenderTarget = TinyPlanetTarget;
    }

    pass p1
    {
        VertexShader = FullScreenVS;
        PixelShader = TinyPlanet;
    }
};