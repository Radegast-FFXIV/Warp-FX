/*-----------------------------------------------------------------------------------------------------*/
/* Swirl Shader v3.0 - by Radegast Stravinsky of Ultros.                                               */
/* There are plenty of shaders that make your game look amazing. This isn't one of them.               */
/*-----------------------------------------------------------------------------------------------------*/
uniform float radius <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_min = 0.0; ui_max = 1.0;
> = 0.0;

uniform float angle <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_min = -1800.0; ui_max = 1800.0; ui_step = 1.0;
> = 0.0;

uniform float tension <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_min = 0.; ui_max = 10.; ui_step = 0.001;
> = 1.0;

uniform float center_x <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_min = 0.0; ui_max = 1.0;
> = 0.5;

uniform float center_y <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else 
        ui_type = "slider";
    #endif
    ui_min = 0.0; ui_max = .5;
> = 0.25;

uniform int animate <
    ui_type = "combo";
    ui_label = "Animate";
    ui_items = "No\0Yes\0";
    ui_tooltip = "Animates the swirl, moving it clockwise and counterclockwise.";
> = 0;

uniform float anim_rate <
    source = "timer";
>;

uniform int inverse <
    ui_type = "combo";
    ui_label = "Inverse Angle";
    ui_items = "No\0Yes\0";
    ui_tooltip = "Inverts the angle of the swirl, making the edges the most distorted.";
> = 0;

texture texColorBuffer : COLOR;
texture texDepthBuffer : DEPTH;

texture swirlTarget
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

    Width = BUFFER_WIDTH;
    Height = BUFFER_HEIGHT;
    MipLevels = LINEAR;
    Format = RGBA8;
    
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

sampler samplerTarget
{
    Texture = swirlTarget;
};

//TODO: Learn what this vertex shader really does.
void FullScreenVS(uint id : SV_VertexID, out float4 position : SV_Position, out float2 texcoord : TEXCOORD0)
{
    texcoord.x = (id == 2) ? 2.0 : 0.0;
    texcoord.y = (id == 1) ? 2.0 : 0.0;
    
    position = float4( texcoord * float2(2, -2) + float2(-1, 1), 0, 1);
}

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
        float percent = (radius-dist)/tension_radius;
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

technique Swirl
{
    pass p0
    {
       
        VertexShader = FullScreenVS;
        PixelShader = DoNothingPS;

        RenderTarget = swirlTarget;
        ClearRenderTargets = true;

        RenderTargetWriteMask = 0xF;

        SRGBWriteEnable = false;

        BlendEnable = false;

        BlendOp = ADD;
        BlendOpAlpha = ADD;

        SrcBlend = ONE;
        //SrcBlendAlpha = ONE;
        DestBlend = ZERO;

        StencilEnable = false;

        StencilReadMask = 0xFF; // or StencilMask
        StencilWriteMask = 0xFF;

        StencilFunc = ALWAYS;

        StencilRef = 0;

        StencilPassOp = KEEP; 
        StencilFailOp = KEEP; 
        StencilDepthFailOp = KEEP; 

    }

    pass p1
    {
        VertexShader = FullScreenVS;
        PixelShader = Swirl;
    }
};