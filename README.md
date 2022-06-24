# Summary

A suite of shaders that in no way make your game look any more appealing. Use them anyways.

# Changelog
## 1.3.0
- Major Changes
  - Added a new shader: Radial Slit Scan.
    - Behaves similar to the animated version of Slit Scan, but by scanning a circle instead of a column of pixels.
  - Added Blending modes to Slit Scan.
    - Reminder: You will still need Blending.fxh from the crosire ReShade repo found [here](https://github.com/crosire/reshade-shaders/blob/slim/Shaders/Blending.fxh).
  - Reworked Depth handling by replacing the "Depth Mode" and "Depth Threshold" parameters with "Depth Bounds" and "Minimum Depth". This should make for much more versatile depth masking for the following shaders:
    - Swirl
    - Wave
    - Bulge/Pinch
    - Zigzag
    - Drunk
    - Slit Scan (Minimum Depth only)
    - Radial Slit Scan (Minimum Depth only)
    - Spliced Radials
## V1.2.4
- Minor Changes
  - Updated README
## V1.2.3
- Minor Changes
  - We've split out Spliced Radials from Swirl. They are now in separate files. This is to reduce the number of instructions per shader to make it a bit easier to debug.
- Bug Fixes:
  - The default position for the center of most positional shaders is now (0.5, 0.5) instead of (0.25, 0.25).
  - There was an issue where adjusting the angle for Wave was causing the effect to display incorrectly.
## V1.2.2
- Bug Fixes:
  - Drunk Shader should now work on DX9 and should also be a bit faster.
- Misc:
  - TinyPlanet now displays as "Tiny Planet" in the effects list.
  - Minor syntactical changes to Swirl, TinyPlanet, 
## V1.2.1
- Updated Drunk shader:
  - Added two new params: Bending Angle and Bending Speed
    - Bending Angle: Controls the amount of bending the distortion creates.
    - Bending Speed: Controls the speed of the bending distortion.
## v1.2.0 
- Added a new Shader: Drunk
  - Ported from [Xaymar](https://github.com/Xaymar)'s Drunk shader for StreamFX.
  - Distorts the screen in vertical and horizontal stretching/squishing motions.
- Changes to the LICENSE in this repo:
  - The following shader is licensed under GNU GPL v2:
    - Drunk.fx
  - All other shaders remain licensed under MIT.
- Bug Fixes:
  - Fixed "Bulge/Pinch" Magnitude parameter not being capitalized.


## V1.1.0
- Added foreground depth processing for the following shaders:
  - Swirl
  - Zigzag
  - Wave
  - Bulge/Pinch

## v1.0.0 (Baseline)

- Baseline release for already released shaders. This should provide more stability to end-users.

# Installation
## Prerequisites
In order to use these Shaders by downloading it from the page, you will need to do the following steps first. This guide assumes that you have a centralized ReShade distribution or an already existing ReShade Shaders folder that may not have been updated via the ReShade application in some time:
1. Download the Blending.fxh file. This file is normally included when adding ReShade to a game, but is not included in this repository to reduce version diffences. You can download Blending.fxh directly [here](https://github.com/crosire/reshade-shaders/blob/slim/Shaders/Blending.fxh).

2. Place the downloaded Blending.fxh in your Shaders folder where all other ReShade shaders are located.

## Installing WarpFX shaders
1. Download the repository either as a ZIP file from the "Code" tab or the Releases page.
2. Extract the ZIP file to your Shaders folder that was created by ReShade, or a centralized Shaders folder if you've chosen to centralize your shaders in a specific location. You should now be able to access the shaders from your ReShade menu. You may need to reload your shaders if you are already in-game.

# Shaders

This list of shaders will grow as I figure out more ways of exploding peoples screens into some interesting effects.

## Spliced Radials
Creates rotated concentric circles at a set location, similar to Jean Fraucher's photography.

## Swirl
Distorts the screen by twisting pixels around a certain point. You can adjust the radius, angle, and many other parameters of the distortion.


## Wave

Distorts the screen in one of two ways: a sinesoidal distortion or a stretch/squeeze distortion.

## Zigzag

A more advanced version of the Swirl shader that twists pixels back and forth around a certain point. There are two modes to Zigzag:

- Around Center (default): The typical distortion as stated above.
- Out from Center: Pulls and pushes pixels around a center point, giving the illusion of a ripple on the surface of water.

## Bulge/Pinch

Stretches or squeezes pixels around a certain point.

## Tiny Planet

Emulates the projection of the screen onto a sphere. Can be used to create a tiny planet from a horizon.

## Slit Scan

Scans a column of pixels and outputs them to a sliding buffer to the side.


## Drunk

A port of the OBS StreamFX filter with the same name. This shader behaves similarly to the
original version of the Drunk shader. The newer version will be implemented in the future.