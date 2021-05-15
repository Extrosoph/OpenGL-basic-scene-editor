attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

varying vec2 texCoord;
varying vec4 position;
varying vec3 normal;

uniform mat4 ModelView;
uniform mat4 Projection;

void main()
{
    position = vec4(vPosition, 1.0);

    normal = vNormal;
    texCoord = vTexCoord;
    gl_Position = Projection * ModelView * vec4(vPosition, 1.0);
}
