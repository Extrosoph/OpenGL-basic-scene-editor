varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded
varying vec3 normal;
varying vec4 position;

varying vec4 vPosition;
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform float Shininess;

// Everything lights needed
uniform vec4 LightPosition1, LightPosition2, LightPosition3;
uniform vec3 LightColor1, LightColor2, LightColor3;
uniform float LightBrightness1, LightBrightness2, LightBrightness3;
uniform vec4 LightDirection;

// Textures
uniform float texScale;
uniform sampler2D texture;

void main()
{

    vec3 pos = (ModelView * position).xyz;

    // The vector to the light from the vertex
    vec3 Lvec = LightPosition1.xyz - pos;
    vec3 Lvec2 = LightPosition2.xyz;
    vec3 Lvec3 = LightPosition3.xyz - pos;

    //normalize
    vec3 L = normalize(Lvec);
    vec3 L2 = normalize(Lvec2);
    vec3 L3 = normalize(Lvec3);

    vec3 E = normalize(-pos);

    vec3 H = normalize(L + E);
    vec3 H2 = normalize(L2 + E);
    vec3 H3 = normalize(L3 + E);

    // Ambient Calculation
    vec3 ambient = AmbientProduct * (LightColor1 * LightBrightness1);
    vec3 ambient2 = AmbientProduct * (LightColor2 * LightBrightness2);
    vec3 ambient3 = AmbientProduct * (LightColor3 * LightBrightness3);

    vec3 N = normalize((ModelView * vec4(normal, 0.0)).xyz);

    // Diffuse Calculation
    float Kd = max(dot(L, N), 0.0);
    float Kd2 = max(dot(L2, N), 0.0);
    float Kd3 = max(dot(L3, N), 0.0);
    vec3 diffuse = Kd * DiffuseProduct * (LightColor1 * LightBrightness1);
    vec3 diffuse2 = Kd2 * DiffuseProduct * (LightColor2 * LightBrightness2);
    vec3 diffuse3 = Kd3 * DiffuseProduct * (LightColor3 * LightBrightness3);

    // Specular Calculation
    float Ks = pow(max(dot(N, H), 0.0), Shininess);
    float Ks2 = pow(max(dot(N, H2), 0.0), Shininess);
    float Ks3 = pow(max(dot(N, H3), 0.0), Shininess);
    vec3 specular = Ks * (SpecularProduct) * (LightColor1 * LightBrightness1);
    vec3 specular2 = Ks2 * (SpecularProduct) * (LightColor2 * LightBrightness2);
    vec3 specular3 = Ks3 * (SpecularProduct) * (LightColor3 * LightBrightness3);
    if(dot(L, N) < 0.0)
    {
        specular = vec3(0.0, 0.0, 0.0);
    }
    if(dot(L2, N) < 0.0)
    {
        specular2 = vec3(0.0, 0.0, 0.0);
    }
    if(dot(L3, N) < 0.0)
    {
        specular3 = vec3(0.0, 0.0, 0.0);
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


    vec3 dL = normalize(LightDirection.xyz);
    vec4 color3;
    if(dot(L3, dL) < 0.5)
    {
        ambient3 = vec3(0.0, 0.0, 0.0);
        diffuse3 = vec3(0.0, 0.0, 0.0);
        specular3 = vec3(0.0, 0.0, 0.0);
    }

    // Distance light reduction for light 3
    float d3 = length(Lvec3);
    float b3 = 0.1;
    float c3 = 0.1;
    float reduction3 = 1.0 / (1.0 + (b3 * d3) + (c3 * d3 * d3));
    color3.rgb = (diffuse3 + ambient3) * reduction3;
	color3.a = 1.0;

    color = color + color3;

    /*Part H
    * https://stackoverflow.com/questions/35917678/opengl-lighting-specular-higlight-is-colored
    */

    /*
    * Part B for changing texture scale
    */
    gl_FragColor = color * texture2D( texture, texCoord * texScale) + vec4((specular * reduction), 0.0)
                  + vec4(specular2, 0.0) + vec4((specular3 * reduction3), 0.0);
}
