#define ANIMATE_NY

#include "Include/WarpFX.Animate.fxh"
#include "Include/WarpFX.Depth.fxh"
#include "Include/WarpFX.Positional.fxh"
#include "Include/WarpFX.Radial.fxh"
#include "Include/WarpFX.AspectRatio.fxh"
#include "Include/WarpFX.Offsets.fxh"
#include "Include/WarpFX.Transforms.fxh"
#include "Include/WarpFX.BlendingModes.fxh"

uniform float inner_radius <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_label = "Inner Radius";
    ui_tooltip = "Normal Mode -- Sets the inner radius at which the maximum angle is automatically set.\nSpliced Radial mode -- defines the innermost spliced circle's size.";
    ui_category = "Properties";
    ui_min = 0.0;
    ui_max = 1.0;
> = 0;

uniform float angle <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_label="Angle";
    ui_category = "Properties";
    ui_min = -1800.0; 
    ui_max = 1800.0; 
    ui_step = 30.0;
> = 180.0;

uniform int inverse <
    ui_type = "combo";
    ui_label = "Inverse Angle";
    ui_items = "No\0Yes\0";
    ui_tooltip = "Inverts the angle of the swirl, making the edges the most distorted.";
    ui_category = "Properties";
> = 0;
