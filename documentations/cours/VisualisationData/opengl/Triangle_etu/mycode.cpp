#include <iostream>
#include <GL/glew.h>
#include <GL/glut.h>
#include <GL/gl.h>
#include <GL/glu.h>
#include <math.h>

#include "shaders_utilities.hpp"
#define GLM_FORCE_RADIANS

// Include GLM
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
using namespace glm;
using namespace std;

// Pour la fenêtre
GLsizei width = 500;
GLsizei height = 500;

//Variables objects
static GLfloat sommets[] = {0,0,0, 1,0,0, 0,1,0, 1,1,0, 0,0,-1, 0,1,-1, 0,1,-1, 1,1,-1};
static GLfloat couleurs[] = {1,0,0, 1,0,0, 1,1,1, 1,1,1, 0,1,0, 0,1,0, 0,0,0, 0,0,0};
static GLuint IndiceArray [36] = {0,1,2, 2,3,1, 3,5,7, 3,1,5, 4,5,7, 4,6,7, 0,4,2, 2,4,6, 2,3,7, 2,6,7, 0,1,5, 0,4,5};
static GLfloat triangle[] = {-1,1,0, 1,-1,0, 1,1,0};

//Variables buffers
GLuint CubeBuffers[3];
GLuint vboid[2];

//Transformations variables
float rtri;             // Angle For The Triangle
float rquad;

//Shaders
GLuint programID;

//Projection et model
GLuint MatrixID;
glm::mat4 Projection;
glm::mat4 View;
glm::mat4 Model;
glm::mat4 MVP;



void init() {
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

  //Gestion du shader
  //default : glShadeModel(GL_SMOOTH);              // Enable Smooth Shading
  programID = LoadShaders( "VertexShader.vert", "FragmentShader.frag" );
  MatrixID = glGetUniformLocation(programID, "MVP");

  Projection = glm::perspective(70.0f, 4.0f / 3.0f, 0.1f, 100.0f);
  //glMatrixMode   ( GL_PROJECTION );  // Select The Projection Matrix

  View       = glm::lookAt(
			   glm::vec3(0,2, 5), 
			   glm::vec3(0,0,0), 
			   glm::vec3(0,1,0)  
			   );

  Model      = glm::mat4(1.0f);
  MVP        = Projection * View * Model; 

    
}

void reshape ( int w, int h )   // Create The Reshape Function (the viewport)
{
  glViewport     ( 0, 0, w, h );
  glMatrixMode   ( GL_PROJECTION );  // Select The Projection Matrix
  glLoadIdentity ( );                // Reset The Projection Matrix
  if ( h==0 )  // Calculate The Aspect Ratio Of The Window
     gluPerspective ( 80, ( float ) w, 1.0, 5000.0 );
  else
     gluPerspective ( 80, ( float ) w / ( float ) h, 1.0, 5000.0 );
  glMatrixMode   ( GL_MODELVIEW );  // Select The Model View Matrix
  glLoadIdentity ( );    // Reset The Model View Matrix
}

void Display(void) {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // Clear Screen And Depth Buffer
   glLoadIdentity();                  // Reset The Current Modelview Matrix
   glPushMatrix();
  glUseProgram(programID);

  glUniformMatrix4fv(MatrixID, 1, GL_FALSE, &MVP[0][0]);

  /*glBindBuffer ( GL_ARRAY_BUFFER , CubeBuffers[0]);
  glVertexPointer( 3 ,GL_FLOAT , 3 * sizeof(float), 0);
  glBindBuffer ( GL_ARRAY_BUFFER , CubeBuffers [1]);
  glColorPointer ( 3 , GL_FLOAT , 3 * sizeof(float), 0 );
  glBindBuffer ( GL_ELEMENT_ARRAY_BUFFER , CubeBuffers[2]);

  glEnableClientState( GL_VERTEX_ARRAY ) ;
  glEnableClientState( GL_COLOR_ARRAY ) ;
  glDrawElements( GL_TRIANGLES , 36 , GL_UNSIGNED_INT , 0) ;
  glRotated(1,0,1,0);

  glDisableClientState( GL_COLOR_ARRAY ) ;
  glDisableClientState( GL_VERTEX_ARRAY ) ;*/
  glLoadIdentity();         // Reset The Current Modelview Matrix
    glTranslatef(1.5f,0.0f,-6.0f);       // Move Right 1.5 Units And Into The Screen 6.0
    glRotatef(rquad,1.0f,0.0f,0.0f);
  glBegin( GL_TRIANGLES );
    glColor3f(0,1,0);glVertex3f(-1,1,0);
    glColor3f(1,0,1);glVertex3f(1,-1,0);
    glColor3f(1,1,0);glVertex3f(1,1,0);
  glEnd();
  glPopMatrix();
  /*glEnableClientState( GL_VERTEX_ARRAY );
  glEnableClientState( GL_COLOR_ARRAY );

  glVertexPointer( 3, GL_FLOAT, 0, sommets);
  glColorPointer( 3, GL_FLOAT, 0, couleurs);
  glDrawElements( GL_TRIANGLES, 36, GL_UNSIGNED_INT, IndiceArray );
  
  glDisableClientState( GL_COLOR_ARRAY );
  glDisableClientState( GL_VERTEX_ARRAY );*/

  rquad+=0.5f;

  glutSwapBuffers();
}

int main(int argc, char** argv)
{

  glutInit (&argc,argv) ;
  glutInitDisplayMode (GLUT_DOUBLE | GLUT_RGBA) ;
  glutInitWindowSize (width,height) ;
  glutInitWindowPosition (100, 100) ;
  glutCreateWindow ("GLUT") ;
  GLenum err = glewInit();

  init();
  glutDisplayFunc(Display);
  glutMainLoop () ;
  return 0 ;
  
}
