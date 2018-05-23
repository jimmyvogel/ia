uniform mat4 MVP; // la matrice 

attribute vec3 centres ;

//Variables to fragmentshader
varying vec4 position;
varying vec4 center;
varying vec3 normal;

void main(){

  //Dans le vertex Shader gl Vertex donne la position du sommet.
  vec4 positionVec4 = gl_Vertex;

  //On repositionne tous les cubes vers la position transmis dans la variable centres.
  positionVec4.xyz += centres;

  //On replace la position du vertex dans le model, la vue puis dans le plan.
  gl_Position = MVP * positionVec4; 

  //Pas de changement sur la couleur
  gl_FrontColor = gl_Color; 

  //On donne la position au fragment shader.
  position = gl_Position;

  //On donne la normale au fragment shader. (gl_MatrixNormal = -gl_Position) on ne rajoute pas la transformation par mvp 
  normal = -(positionVec4.xyz);

  //Normalisation en vec 4: attention, w=1, pour homogénéité des coordonnées
  vec4 centresVec4 = vec4(0,0,0,1);
  centresVec4.xyz += centres;

  //On donne le centre pour chaque sommet
  center = MVP * centresVec4;
  
}
