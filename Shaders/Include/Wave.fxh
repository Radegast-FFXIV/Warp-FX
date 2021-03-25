uniform int wave_type <
    ui_type = "combo";
    ui_label = "Wave Type";
    ui_items = "X/X\0X/Y\0";
    ui_tooltip = "Which axis the distortion should be performed against.";
> = 1;

uniform float angle <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_min = -360.0; ui_max = 360.0; ui_step = 1.0;
> = 180.0;

uniform float period <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_min = 0.1; ui_max = 10.0;
    ui_tooltip = "The wavelength of the distortion. Smaller values make for a longer wavelength.";
> = 0.5;

uniform float amplitude <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_min = -1.0; ui_max = 1.0;
    ui_tooltip = "The amplitude of the distortion in each direction.";
> = 0.0;

uniform float phase <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_min = -5.0; ui_max = 5.0;
    ui_tooltip = "The offset being applied to the distortion's waves. Smaller is longer.";
> = 0.0;

uniform int animate <
    ui_type = "combo";
    ui_label = "Animate";
    ui_items = "No\0Amplitude\0Phase\0Angle\0";
    ui_tooltip = "Enable or disable the animation. Animates the wave effect by phase, amplitude, or angle.";
> = 0;

uniform float anim_rate <
    source = "timer";
>;

uniform int additiveRender <
    ui_type = "combo";
    ui_label = "Additively Render";
    ui_items = "No\0Base -> Result\0Result -> Base\0";
    ui_tooltip = "Additively render the effect.";
> = 0;