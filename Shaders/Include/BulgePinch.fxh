#define ANIMATE_NY

#include "Include/WarpFX.Animate.fxh"
#include "Include/WarpFX.Depth.fxh"
#include "Include/WarpFX.Positional.fxh"
#include "Include/WarpFX.Radial.fxh"
#include "Include/WarpFX.AspectRatio.fxh"
#include "Include/WarpFX.Offsets.fxh"
#include "Include/WarpFX.Transforms.fxh"
#include "Include/WarpFX.BlendingModes.fxh"

uniform float magnitude <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_label = "Magnitude";
    ui_min = -1.0; 
    ui_max = 1.0;
    ui_tooltip = "The magnitude of the distortion. Positive values cause the image to bulge out. Negative values cause the image to pinch in.";    
    ui_category = "Properties";
> = -0.5;

