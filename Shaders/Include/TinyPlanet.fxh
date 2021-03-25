#define PI 3.141592358

uniform float center_x <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_min = 0.0; ui_max = 360.0;
> = 0;

uniform float center_y <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else 
        ui_type = "slider";
    #endif
    ui_min = 0.0; ui_max = 360.0;
> =0;

uniform float offset_x <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_min = 0.0; ui_max = 1.0;
> = 0;

uniform float offset_y <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else 
        ui_type = "slider";
    #endif
    ui_min = 0.0; ui_max = .5;
> = 0;

uniform float scale <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_min = 0.0; ui_max = 10.0;
> = 10.0;

uniform float z_rotation <
    #if __RESHADE__ < 40000
        ui_type = "drag";
    #else
        ui_type = "slider";
    #endif
    ui_min = 0.0; ui_max = 360.0;
> = 0.5;


float3x3 getrot(float3 r)
{
    float cx = cos(radians(r.x));
    float sx = sin(radians(r.x));
    float cy = cos(radians(r.y));
    float sy = sin(radians(r.y));
    float cz = cos(radians(r.z));
    float sz = sin(radians(r.z));

    float m1,m2,m3,m4,m5,m6,m7,m8,m9;

    m1=cy*cz;
    m2=cx*sz+sx*sy*cz;
    m3=sx*sz-cx*sy*cz;
    m4=-cy*sz;
    m5=cx*cz-sx*sy*sz;
    m6=sx*cz+cx*sy*sz;
    m7=sy;
    m8=-sx*cy;
    m9=cx*cy;

    return float3x3
    (
        m1,m2,m3,
        m4,m5,m6,
        m7,m8,m9
    );
};