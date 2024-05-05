/*-----------------------------------------------------------------------------------------------------*/
/* Swirl Shader - by Radegast Stravinsky of Ultros.                                               */
/* There are plenty of shaders that make your game look amazing. This isn't one of them.               */
/*-----------------------------------------------------------------------------------------------------*/
#include "Include/Swirl.fxh"
#include "../ReShade.fxh"

texture texColorBuffer : COLOR;

sampler samplerColor
{
    Texture = texColorBuffer;

    AddressU = MIRROR;
    AddressV = MIRROR;
    AddressW = MIRROR;
};

// Pixel Shaders (in order of appearance in the technique)
float4 Swirl(float4 pos : SV_Position, float2 texcoord : TEXCOORD0) : SV_TARGET
{
    float4 color;
    const float ar_raw =  (float)BUFFER_HEIGHT / (float)BUFFER_WIDTH;
    const float depth = ReShade::GetLinearizedDepth(texcoord).r;
    float2 tc = texcoord;
    float4 base = tex2D(samplerColor, texcoord);
    float ar  = lerp(ar_raw, 1, aspect_ratio * 0.01);

    float2 center = float2(x_coord, y_coord);
    float2 offset_center = float2(offset_x, offset_y);

    if (use_mouse_point)
        center = float2(mouse_coordinates.x * BUFFER_RCP_WIDTH, mouse_coordinates.y * BUFFER_RCP_HEIGHT);

    if(aspect_ratio_angle) {
        center = mul(swirlTransform(radians(aspect_ratio_angle)), center);

        tc = mul(swirlTransform(radians(aspect_ratio_angle)), tc - center);
        tc += mul(swirlTransform(radians(aspect_ratio_angle)), center);
    }

    center.x /= ar;
    offset_center.x /= ar;

    tc.x /= ar;

    const float dist = distance(center, tc);
    const float dist_radius = radius-dist;
    const float tension_radius = lerp(radius-dist, radius, tension);
    const float tension_dist = lerp(dist_radius, tension_radius, tension);
    float percent;
    float theta;

    percent = max(dist_radius, 0) / tension_radius;
    if(inverse && dist < radius)
        percent = 1 - percent;

    if(dist_radius > radius-inner_radius)
        percent = 1;

    theta = percent * percent;

    if(!animate) {
        theta *= radians(angle);
    }
    else {
        theta *= radians(angle * sin(anim_rate * 0.0005));
    }
    tc = mul(swirlTransform(theta), tc - center);

    if(use_offset_coords) {
        tc += offset_center;
    }
    else
       tc += center;
    tc.x *= ar;

    if(aspect_ratio_angle) {
        center.x *= ar;
        center = mul(swirlTransform(radians(-aspect_ratio_angle)), center);

        tc = mul(swirlTransform(radians(-aspect_ratio_angle)), tc - center);
        tc += mul(swirlTransform(radians(-aspect_ratio_angle)), center);
    }


    float out_depth = ReShade::GetLinearizedDepth(tc).r;
    bool inDepthBounds = out_depth >= depth_bounds.x && out_depth <= depth_bounds.y;

    if (inDepthBounds)
    {
        if(use_offset_coords)
        {
            if(percent)
                color = tex2D(samplerColor, tc);
            else
                color = tex2D(samplerColor, texcoord);
        } else
            color = tex2D(samplerColor, tc);

        float blending_factor;

        if(render_type)
            blending_factor = lerp(0, dist_radius * tension_radius * 10, blending_amount);
        else
            blending_factor = blending_amount;

        if(percent)
            color.rgb = ComHeaders::Blending::Blend(render_type, base.rgb, color.rgb, blending_factor);
    }
    else
    {
        color = base;
    }

    if(depth < min_depth)
        color = tex2D(samplerColor, texcoord);

    return color;
}

// Technique
technique Swirl <ui_label="Swirl";>
{
    pass p0
    {
        VertexShader = PostProcessVS;
        PixelShader = Swirl;
    }
};