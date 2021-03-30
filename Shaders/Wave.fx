/*-----------------------------------------------------------------------------------------------------*/
/* Wave Shader v3.0 - by Radegast Stravinsky of Ultros.                                                */
/* There are plenty of shaders that make your game look amazing. This isn't one of them.               */
/*-----------------------------------------------------------------------------------------------------*/
#include "Include/Wave.fxh"

texture texColorBuffer : COLOR;
texture texDepthBuffer : DEPTH;

texture waveTarget
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
};

sampler result
{
    Texture = waveTarget;
};


// Vertex Shader
void FullScreenVS(uint id : SV_VertexID, out float4 position : SV_Position, out float2 texcoord : TEXCOORD0)
{
    if (id == 2)
        texcoord.x = 2.0;
    else
        texcoord.x = 0.0;

    if (id == 1)
        texcoord.y  = 2.0;
    else
        texcoord.y = 0.0;

    position = float4( texcoord * float2(2, -2) + float2(-1, 1), 0, 1);

}

void DoNothingPS(float4 pos : SV_Position, float2 texcoord : TEXCOORD0, out float4 color : SV_TARGET)
{
    color = tex2D(samplerColor, texcoord);
}

float4 Wave(float4 pos : SV_Position, float2 texcoord : TEXCOORD0) : SV_TARGET 
{
    
    const float ar = 1.0 * (float)BUFFER_HEIGHT / (float)BUFFER_WIDTH;
    const float2 center = float2(0.5 / ar, 0.5);

    texcoord.x /= ar;

    const float theta = radians(animate == 3 ? (anim_rate * 0.01 % 360.0) : angle);
    const float s =  sin(theta);
    const float _s = sin(-theta);
    const float c =  cos(theta);
    const float _c = cos(-theta);

    texcoord = float2(dot(texcoord - center, float2(c, -s)), dot(texcoord - center, float2(s, c)));
    if(wave_type == 0)
    {
        if (animate == 1)
        {
            texcoord.x += (sin(anim_rate * 0.001) * amplitude)* sin((texcoord.x * period * 10) + phase);
        }
        else
        {
            texcoord.x += amplitude * sin((texcoord.x * period * 10)  + (anim_rate * 0.001));
        }
    }
    else
    {
        if (animate == 1)
        {
            texcoord.x += (sin(anim_rate * 0.001) * amplitude)* sin(( texcoord.y * period * 10) + phase);
        }
        else
        {
            texcoord.x += amplitude * sin((texcoord.y * period * 10)  + (anim_rate * 0.001));
        }
    }
    texcoord = float2(dot(texcoord, float2(_c, -_s)), dot(texcoord, float2(_s, _c))) + center;

    texcoord.x *= ar;

    return tex2D(samplerColor, texcoord);

}


float4 ResultPS(float4 pos : SV_Position, float2 texcoord : TEXCOORD0) : SV_TARGET
{
    const float4 color = tex2D(result, texcoord);

    switch(additiveRender)
    {
        case 0:
            return color;
        case 1:
            return lerp(tex2D(samplerColor, texcoord), color, color.a);
        default:
            return lerp(color, tex2D(samplerColor, texcoord), color.a);
    }
}


technique Wave
{
    pass p0
    {
       
        VertexShader = FullScreenVS;
        PixelShader = DoNothingPS;

        RenderTarget = waveTarget;
    }

    pass p1
    {
        VertexShader = FullScreenVS;
        PixelShader = Wave;

        RenderTarget = waveTarget;
    }

    pass p2 
    {
        VertexShader = FullScreenVS;
        PixelShader = ResultPS;
    }
}