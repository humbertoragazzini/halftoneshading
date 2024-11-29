uniform vec3 uColor;

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

    // Final color
    gl_FragColor = vec4(color, 1.0);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}