# Summary

A suite of shaders that in no way make your game look any more appealing. Use them anyways.

# Changelog

## v1.0.0 (Baseline)

- Baseline release for already released shaders. This should provide more stability to end-users.

# Shaders

This list of shaders will grow as I figure out more ways of exploding peoples screens into some interesting effects.

### Swirl

Distorts the screen by twisting pixels around a certain point. There are two modes to Swirl:

- Normal (default): The typical distortion as stated above.
- Spliced Radial: Instead of a contiguous swirl, creates a number of concentric circles and rotates them according to the parameters in the shader.

### Wave

Distorts the screen in one of two ways: a sinesoidal distortion or a stretch/squeeze distortion.

### Zigzag

A more advanced version of the Swirl shader that twists pixels back and forth around a certain point. There are two modes to Zigzag:

- Around Center (default): The typical distortion as stated above.
- Out from Center: Pulls and pushes pixels around a center point, giving the illusion of a ripple on the surface of water.

### Bulge/Pinch

Stretches or squeezes pixels around a certain point.

### Tiny Planet

Emulates the projection of the screen onto a sphere. Can be used to create a tiny planet from a horizon.

### Slit Scan

Scans a column of pixels and outputs them to a sliding buffer to the side.
