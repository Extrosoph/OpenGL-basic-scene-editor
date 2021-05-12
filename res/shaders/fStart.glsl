varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

varying vec3 fN;
varying vec3 fL;
varying vec3 fV;

varying vec3 position;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform vec4 LightPosition;
uniform float Shininess;

uniform float texScale;

uniform sampler2D texture;

void main()
{

    // The vector to the light from the vertex
    vec3 Lvec = LightPosition.xyz - position;

    //normalize
    vec3 N = normalize(fN);
    vec3 V = normalize(fV);
    vec3 L = normalize(fL);

    vec3 H = normalize(L + V);

    vec3 ambient = AmbientProduct;
    float Kd = max(dot(L, N), 0.0);

    vec3 diffuse = Kd * DiffuseProduct;

    float Ks = pow(max(dot(N, H), 0.0), Shininess);

    vec3 specular = Ks * (SpecularProduct);

    if(dot(L, N) < 0.0)
    {
        specular = vec3(0.0, 0.0, 0.0);
    }

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);

    float d = length(Lvec);
    float b = 0.1;
    float c = 0.1;
    float reduction = 1.0 / (1.0 + (b * d) + (c * d * d));

    vec4 color;

    color.rgb = globalAmbient + (( diffuse +  ambient) * reduction);
	color.a = 1.0;

    /*Part H
    * https://stackoverflow.com/questions/35917678/opengl-lighting-specular-higlight-is-colored
    */

    gl_FragColor = color * texture2D( texture, texCoord * texScale) + vec4((specular * reduction), 0.0);
}
