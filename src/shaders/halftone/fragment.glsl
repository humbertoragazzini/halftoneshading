uniform vec3 uColor;
uniform vec2 uResolution;

varying vec3 vNormal;
varying vec3 vPosition;

#include ../includes/ambientLight.glsl;
#include ../includes/directionalLight.glsl;

void main()
{
    vec3 viewDirection = normalize(vPosition - cameraPosition);
    vec3 normal = normalize(vNormal);
    vec3 color = uColor;

    //lIGHT
    vec3 light = vec3(0.0);

    light+= ambientLight(
        vec3(1.0), // light color
        1.0 // light intensity
    );

    light += directionalLight(
        vec3(1.0,1.0,1.0), // the color
        1.0, // the intensity
        normal, // the normal
        vec3(1.0,1.0,1.0), // the position
        viewDirection,
        1.0
    );

    color*=light;

    // Halftone 
    float repetition = 50.0;

    vec2 uv = gl_FragCoord.xy / uResolution.y;// this are the position of the xy viewport porsition, more the xy position of the rendered viewport 
    uv*=repetition;
    uv = mod(uv, 1.0);

    // Final color
    gl_FragColor = vec4(uv,1.0, 1.0);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}