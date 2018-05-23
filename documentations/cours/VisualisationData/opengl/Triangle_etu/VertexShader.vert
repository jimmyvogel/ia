uniform mat4 MVP;

void main(){

  gl_FrontColor = gl_Color;
  gl_Position =  MVP * gl_Vertex;
}
