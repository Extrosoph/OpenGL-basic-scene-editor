attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
varying vec3 position;
varying vec3 normal;

varying vec3 fN;
varying vec3 fV;
varying vec3 fL;
varying vec3 fL2;

uniform mat4 ModelView;
uniform mat4 Projection;

uniform vec4 LightPosition1;
uniform vec4 LightPosition2;

void main()
{
    fN = (ModelView * vec4(vNormal, 0.0)).xyz;
    fV = -(ModelView * vec4(vPosition, 1.0)).xyz;
    fL = LightPosition1.xyz - (ModelView * vec4(vPosition, 1.0)).xyz;

    fL2 = LightPosition2.xyz - (ModelView * vec4(vPosition, 1.0)).xyz;// - (ModelView * vec4(0.0,0.0,0.0,1.0)).xyz;// - (ModelView * vec4(vPosition, 1.0)).xyz;

    position = (ModelView * vec4(vPosition, 1.0)).xyz;
    normal = vNormal;
    gl_Position = Projection * ModelView * vec4(vPosition, 1.0);
    texCoord = vTexCoord;
}
