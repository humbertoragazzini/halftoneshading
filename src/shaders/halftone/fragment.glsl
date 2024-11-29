uniform vec3 uColor;
uniform vec2 uResolution;

varying vec3 vNormal;
varying vec3 vPosition;

#include ../includes/ambientLight.glsl;
#include ../includes/directionalLight.glsl;

vec3 halftone(
    vec3 color,
    float repetition,
    vec3 direction,
    float low,
    float high,
    vec3 pointColor,
    vec3 normal
){
    float intensity = dot(normal, direction);
    intensity = smoothstep(low,high,intensity);
    vec2 uv = gl_FragCoord.xy / uResolution.y;// this are the position of the xy viewport porsition, more the xy position of the rendered viewport 
    uv*=repetition;
    uv = mod(uv, 1.0);

    // Disc
    float point = distance(uv, vec2(0.5));
    point = 1.0 - step(0.5*intensity,point);

    // mix colors
    color = mix(color,pointColor,point);

    return color;
}

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
    float repetition = 100.0;
    vec3 direction = vec3(0.0,-1.0,0.0);
    float low = -0.8;
    float high = 1.5;
    vec3 pointColor = vec3(1.0,0.0,0.0);
    

    color = halftone(
                    color,
                    repetition,
                    direction,
                    low,
                    high,
                    pointColor,
                    normal
                    );
    // Final color
    gl_FragColor = vec4(color, 1.0);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}