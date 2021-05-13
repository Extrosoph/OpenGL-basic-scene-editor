varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

varying vec3 fN;
varying vec3 fL;
varying vec3 fV;
varying vec3 fL2; // for second light

varying vec3 position;
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform float Shininess;

// Everything lights needed
uniform vec4 LightPosition1, LightPosition2;
uniform vec3 LightColor1, LightColor2;
uniform float LightBrightness1, LightBrightness2;

// Textures
uniform float texScale;
uniform sampler2D texture;

void main()
{

    // The vector to the light from the vertex
    vec3 Lvec = LightPosition1.xyz - position;
    vec3 Lvec2 = LightPosition2.xyz - position;

    //normalize
    vec3 N = normalize(fN);
    vec3 V = normalize(fV);
    vec3 L = normalize(fL);
    
    vec3 L2 = normalize(fL2);

    vec3 H = normalize(L + V);
    vec3 H2 = normalize(L2 + V);

    // Ambient Calculation 
    vec3 ambient = AmbientProduct * (LightColor1 * LightBrightness1);
    vec3 ambient2 = AmbientProduct * (LightColor2 * LightBrightness2);

    // Diffuse Calculation
    float Kd = max(dot(L, N), 0.0);
    float Kd2 = max(dot(L2, N), 0.0);
    vec3 diffuse = Kd * DiffuseProduct * (LightColor1 * LightBrightness1);
    vec3 diffuse2 = Kd2 * DiffuseProduct * (LightColor2 * LightBrightness2);

    // Specular Calculation
    float Ks = pow(max(dot(N, H), 0.0), Shininess);
    float Ks2 = pow(max(dot(N, H2), 0.0), Shininess);
    vec3 specular = Ks * (SpecularProduct) * (LightColor1 * LightBrightness1);
    vec3 specular2 = Ks2 * (SpecularProduct) * (LightColor2 * LightBrightness2);
    if(dot(L, N) < 0.0)
    {
        specular = vec3(0.0, 0.0, 0.0);
    }
    if(dot(L2, N) < 0.0)
    {
        specular2 = vec3(0.0, 0.0, 0.0);
    }

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);

    // Distance light reduction for light 1
    float d = length(Lvec);
    float b = 0.1;
    float c = 0.1;
    float reduction = 1.0 / (1.0 + (b * d) + (c * d * d));

    // Colour for FragColor
    vec4 color;
    color.rgb = globalAmbient + (( diffuse +  ambient) * reduction) + diffuse2 + ambient2;
	color.a = 1.0;

    /*Part H
    * https://stackoverflow.com/questions/35917678/opengl-lighting-specular-higlight-is-colored
    */

    gl_FragColor = color * texture2D( texture, texCoord * texScale) + vec4((specular * reduction), 0.0) + vec4(specular2, 0.0);
}
