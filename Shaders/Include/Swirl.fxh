#include "Include/RadegastShaders.CommonPositional.fxh"
#include "Include/RadegastShaders.BlendingModes.fxh"
#include "Include/RadegastShaders.Transforms.fxh"

uniform int swirl_mode <
    ui_type="combo";
    ui_label="Mode";
    ui_items="Normal\0Spliced Radial\0";
    ui_tooltip="Selects which swirl mode to display.\nNormal Mode -- Contiguously twists pixels around a point.\nSpliced Radials -- Creates incrementally rotated circular splices.";
> = 0;

uniform float inner_radius <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_label = "Inner Radius";
    ui_tooltip = "Normal Mode -- Sets the inner radius at which the maximum angle is automatically set.\nSpliced Radial mode -- defines the innermost spliced circle's size.";
    ui_min = 0.0;
    ui_max = 1.0;
> = 0;

uniform int number_splices <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_label = "Number of Splices";
    ui_tooltip = "(Spliced Radial Mode Only) Sets the number of splices. A higher value makes the effect look closer to Normal mode by increasing the number of splices.";
    ui_min = 1;
    ui_max = 50;
> = 10;

uniform float angle <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_label="Angle";
    ui_min = -1800.0; 
    ui_max = 1800.0; 
    ui_step = 1.0;
> = 180.0;

uniform int inverse <
    ui_type = "combo";
    ui_label = "Inverse Angle";
    ui_items = "No\0Yes\0";
    ui_tooltip = "Inverts the angle of the swirl, making the edges the most distorted.";
> = 0;

uniform int animate <
    ui_type = "combo";
    ui_label = "Animate";
    ui_items = "No\0Yes\0";
    ui_tooltip = "Animates the swirl, moving it clockwise and counterclockwise.";
> = 0;
