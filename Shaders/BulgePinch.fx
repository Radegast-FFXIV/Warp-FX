/*-----------------------------------------------------------------------------------------------------*/
/* PBDistort Shader v6.0 - by Radegast Stravinsky of Ultros.                                               */
/* There are plenty of shaders that make your game look amazing. This isn't one of them.               */
/*-----------------------------------------------------------------------------------------------------*/
#include "ReShade.fxh"
#include "Include/BulgePinch.fxh"

texture texColorBuffer : COLOR;

texture pbDistortTarget
{
    Width = BUFFER_WIDTH;
    Height = BUFFER_HEIGHT;
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

sampler result 
{
    Texture = pbDistortTarget;
};

// Vertex Shader
void FullScreenVS(uint id : SV_VertexID, out float4 position : SV_Position, out float2 texcoord : TEXCOORD0)
{
    texcoord.x = (id == 2) ? 2.0 : 0.0;
    texcoord.y = (id == 1) ? 2.0 : 0.0;
    
    position = float4( texcoord * float2(2, -2) + float2(-1, 1), 0, 1);
    //position /= BUFFER_HEIGHT/BUFFER_WIDTH;

}

// Pixel Shaders (in order of appearance in the technique)
float4 PBDistort(float4 pos : SV_Position, float2 texcoord : TEXCOORD0) : SV_TARGET
{
    const float ar_raw = 1.0 * (float)BUFFER_HEIGHT / (float)BUFFER_WIDTH;
    float ar = lerp(ar_raw, 1, aspect_ratio * 0.01);

    float2 center = coordinates;
    if (use_mouse_point) 
        center = float2(mouse_coordinates.x * BUFFER_RCP_WIDTH / 2.0, mouse_coordinates.y * BUFFER_RCP_HEIGHT / 2.0);

    float2 tc = texcoord - center;

    float4 color;
    const float4 base = tex2D(samplerColor, texcoord);
    const float depth = ReShade::GetLinearizedDepth(texcoord).r;

    center.x /= ar;
    tc.x /= ar;

    float dist = distance(tc, center);
    if (dist < radius && depth >= min_depth)
    {
        float anim_mag = (animate == 1 ? magnitude * sin(radians(anim_rate * 0.05)) : magnitude);
        float tension_radius = lerp(dist, radius, tension);
        float percent = (dist)/tension_radius;
        if(anim_mag > 0)
            tc = (tc-center) * lerp(1.0, smoothstep(0.0, radius/dist, percent), anim_mag * 0.75);
        else
            tc = (tc-center) * lerp(1.0, pow(percent, 1.0 + anim_mag * 0.75) * radius/dist, 1.0 - percent);

        tc += (2*center);
        tc.x *= ar;

        color = tex2D(samplerColor, tc);
    }
    else {
        color = tex2D(samplerColor, texcoord);
    }

    if(depth >= min_depth)
        color = applyBlendingMode(base, color);  

    return color;
}

// Technique
technique BulgePinch < ui_label="Bulge/Pinch";>
{
    pass p0
    {
        VertexShader = FullScreenVS;
        PixelShader = PBDistort;
    }
};