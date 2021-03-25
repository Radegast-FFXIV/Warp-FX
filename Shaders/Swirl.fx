/*-----------------------------------------------------------------------------------------------------*/
/* Swirl Shader v4.0 - by Radegast Stravinsky of Ultros.                                               */
/* There are plenty of shaders that make your game look amazing. This isn't one of them.               */
/*-----------------------------------------------------------------------------------------------------*/
#include "Include/Swirl.fxh"
texture texColorBuffer : COLOR;
texture texDepthBuffer : DEPTH;

texture swirlTarget
{
    Width = BUFFER_WIDTH;
    Height = BUFFER_HEIGHT;

    
    AddressU = WRAP;
    AddressV = WRAP;
    AddressW = WRAP;

    Format = RGBA16;
};

sampler samplerColor
{
    Texture = texColorBuffer;
    
    AddressU = WRAP;
    AddressV = WRAP;
    AddressW = WRAP;

    Width = BUFFER_WIDTH;
    Height = BUFFER_HEIGHT;
    Format = RGBA16;
    
};

sampler result 
{
    Texture = swirlTarget;

    Width = BUFFER_WIDTH;
    Height = BUFFER_HEIGHT;
    Format = RGBA16;
};

sampler samplerDepth
{
    Texture = texDepthBuffer;
};

// Vertex Shader
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

void Swirl(float4 pos : SV_Position, float2 texcoord : TEXCOORD0, out float4 color : SV_TARGET)
{
    
    float ar = 1. * BUFFER_HEIGHT/BUFFER_WIDTH;
    float2 center = float2(center_x, center_y);
    float2 tc = texcoord - center;
    center.x /= ar;
    tc.x /= ar;

    float dist = distance(tc, center);
    
    if (dist < radius)
    {
        float tension_radius = lerp(radius-dist, radius, tension);
        float percent = (radius-dist) /tension_radius;
        percent = inverse == 0 ? percent : 1 - percent;
        float theta = percent * percent * radians(angle * (animate == 1 ? sin(anim_rate * 0.0005) : 1.0));
        float s =  sin(theta);
        float c =  cos(theta);
        tc = float2(dot(tc-center, float2(c,-s)), dot(tc-center, float2(s,c)));

        tc += (2*center);
        tc.x *= ar;
      
        color = tex2D(samplerColor, tc);
    }
    else
    {
        color = tex2D(samplerColor, texcoord);
    }
        
}

float4 ResultPS(float4 pos : SV_Position, float2 texcoord : TEXCOORD0) : SV_TARGET
{
    float4 color = tex2D(result, texcoord);
    float4 base = tex2D(samplerColor, texcoord);
    
    if(!additiveRender)
        return color;

    return additiveRender == 1 ? lerp(base, color, color.a) : lerp(color, base, color.a);
}

// Technique
technique Swirl< ui_label="Swirl";>
{
    pass p0
    {
        VertexShader = FullScreenVS;
        PixelShader = DoNothingPS;

        RenderTarget = swirlTarget;
    }

    pass p1
    {
        VertexShader = FullScreenVS;
        PixelShader = Swirl;

        RenderTarget = swirlTarget;
    }

    pass p2
    {
        VertexShader = FullScreenVS;
        PixelShader = ResultPS;
    }


};