attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;


varying vec2 v_coord;
varying vec4 v_color;

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1);
    
    v_color = in_Colour;
    v_coord = in_TextureCoord;
}