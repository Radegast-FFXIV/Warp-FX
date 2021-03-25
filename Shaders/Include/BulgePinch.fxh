uniform float radius <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_min = 0.0; ui_max = 1.0;
> = 0.5;

uniform float magnitude <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_min = -1.0; ui_max = 1.0;
> = -0.5;

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
> = 0.25;

uniform float center_y <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else 
        ui_type = "slider";
    #endif
    ui_min = 0.0; ui_max = 1.0;
> = 0.25;


uniform int animate <
    ui_type = "combo";
    ui_label = "Animate";
    ui_items = "No\0Yes\0";
    ui_tooltip = "Animates the effect.";
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
