uniform int blending_mode <
    ui_type = "combo";
    ui_label = "Blending Mode";
    ui_items = "Normal\0Add\0Multiply\0Subtract\0Divide\0Darker\0Lighter\0";
    ui_tooltip = "Choose a blending mode.";
> = 0;

float4 applyBlendingMode(float4 base, float4 color) { 
    switch(blending_mode) {
        case 1:
            return color + base;
        case 2:
            return color * base;
        case 3:
            return color - base;
        case 4:
            return color / base;
        case 5:
            if(length(color.rgb) > length(base.rgb)) return base;
            return color;
        case 6:
            if(length(color.rgb) < length(base.rgb)) return base;
            return color;
    }  
    return color;
}

float4 applyBlendingMode(float4 base, float4 color, float percent) {    
    switch(blending_mode) {
        case 1:
            return lerp(base, color + base, percent);
        case 2:
            return lerp(base, color * base, percent);
        case 3:
            return lerp(base, color - base, percent);
        case 4:
            return lerp(base, color / base, percent);
        case 5:
            if(length(color.rgb) > length(base.rgb)) return base;
            return color;
        case 6:
            if(length(color.rgb) < length(base.rgb)) return base;
            return color;
    }  
    return color;

}