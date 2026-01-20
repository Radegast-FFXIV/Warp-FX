#define ANIMATE_AP

#include "Include/WarpFX.Animate.fxh"
#include "Include/WarpFX.Depth.fxh"
#include "Include/WarpFX.Positional.fxh"
#include "Include/WarpFX.Radial.fxh"
#include "Include/WarpFX.AspectRatio.fxh"
#include "Include/WarpFX.Offsets.fxh"
#include "Include/WarpFX.Transforms.fxh"
#include "Include/WarpFX.BlendingModes.fxh"

uniform float angle <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_label = "Angle";
    ui_tooltip = "Serves as a multiplier for the phase and amplitude. Also affects the motion of the animation by phase based on whether the value is negative or positive.";
    ui_category = "Properties";
    ui_min = -999.0; 
    ui_max = 999.0; 
    ui_step = 1.0;
> = 180.0;

uniform float period <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_type = "Phase";
    ui_label = "Period";
    ui_tooltip = "Adjusts the rate of distortion.";
    ui_category = "Properties";
    ui_min = 0.1; 
    ui_max = 10.0;
> = 0.25;

uniform float amplitude <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_label = "Amplitude";
    ui_tooltip = "Increases how extreme the picture twists back and forth.";
    ui_category = "Properties";
    ui_min = -10.0; 
    ui_max = 10.0;
> = 1.0;

uniform float phase <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_label = "Phase";
    ui_tooltip = "The offset at which the pixels twist back and forth from the center.";
    ui_category = "Properties";
    ui_min = -5.0; 
    ui_max = 5.0;
> = 0.0;
