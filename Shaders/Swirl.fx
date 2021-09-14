/*-----------------------------------------------------------------------------------------------------*/
/* Swirl Shader - by Radegast Stravinsky of Ultros.                                               */
/* There are plenty of shaders that make your game look amazing. This isn't one of them.               */
/*-----------------------------------------------------------------------------------------------------*/
#include "Include/Swirl.fxh"
#include "ReShade.fxh"

texture texColorBuffer : COLOR;

sampler samplerColor
{
    Texture = texColorBuffer;
    
    AddressU = MIRROR;
    AddressV = MIRROR;
    AddressW = MIRROR;

    Width = BUFFER_WIDTH;
    Height = BUFFER_HEIGHT;
    Format = RGBA16;
    
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

// Pixel Shaders (in order of appearance in the technique)
float4 Swirl(float4 pos : SV_Position, float2 texcoord : TEXCOORD0) : SV_TARGET
{
    float4 base = tex2D(samplerColor, texcoord);
    const float ar_raw = 1.0 * (float)BUFFER_HEIGHT / (float)BUFFER_WIDTH;
    float ar = lerp(ar_raw, 1, aspect_ratio * 0.01);
    const float depth = ReShade::GetLinearizedDepth(texcoord).r;
    float2 center = coordinates  / 2.0;

    if (use_mouse_point) 
        center = float2(mouse_coordinates.x * BUFFER_RCP_WIDTH / 2.0, mouse_coordinates.y * BUFFER_RCP_HEIGHT / 2.0);

    float2 tc = texcoord - center;
    float4 color;

    center.x /= ar;
    tc.x /= ar;

    const float dist = distance(tc, center);
    if (depth >= min_depth)
    {
        const float dist_radius = radius-dist;
        const float tension_radius = lerp(radius-dist, radius, tension);
        float percent; 
        float theta; 

        if(swirl_mode == 0){
            percent = max(dist_radius, 0) / tension_radius;   
            if(inverse && dist < radius)
                percent = 1 - percent;     
        
            if(dist_radius > radius-inner_radius)
                percent = 1;
            theta = percent * percent * radians(angle * (animate == 1 ? sin(anim_rate * 0.0005) : 1.0));
        }
        else
        {
            float splice_width = (tension_radius-inner_radius) / number_splices;
            splice_width = frac(splice_width);
            float cur_splice = max(dist_radius,0)/splice_width;
            cur_splice = cur_splice - frac(cur_splice);
            float splice_angle = (angle / number_splices) * cur_splice;
            if(dist_radius > radius-inner_radius)
                splice_angle = angle;
            theta = radians(splice_angle * (animate == 1 ? sin(anim_rate * 0.0005) : 1.0));
        }

        tc = mul(swirlTransform(theta), tc-center);
        tc += (2 * center);
        tc.x *= ar;    
      
        color = tex2D(samplerColor, tc);
        color = applyBlendingMode(base, color, percent * percent);
    }
    else
    {
        color = base;
    }

    

    return color;
   
}


// Technique
technique Swirl< ui_label="Swirl";>
{
    pass p0
    {
        VertexShader = FullScreenVS;
        PixelShader = Swirl;
    }
};