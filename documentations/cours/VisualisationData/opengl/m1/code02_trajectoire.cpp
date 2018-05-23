#include <iostream>
#include <GL/glew.h>
#include <GL/gl.h>
#include <GL/freeglut.h>

#include <math.h>
#include <fstream>

#include "../Common/shaders_utilities.hpp"
#include "../Common/lecture_trajectoire.hpp"

// Include GLM
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>

#include "icosaedre.hpp"

using namespace glm;
using namespace std;

// Pour la fenêtre

GLfloat* atomes;
GLfloat* couleurs;

GLfloat* coordonnees;
GLfloat* couleurs_par_atome;
GLfloat* translations_par_sommet;

unsigned int* indices;

float stepTrans=1.0;
int mouseXOld, mouseYOld;
bool leftbutton = false;
bool rightbutton = false;
bool middlebutton = false;

GLuint vboID[4];
GLuint vaoID;
GLuint programID;

GLuint MatrixID;
glm::mat4 Projection;
glm::mat4 View;
glm::mat4 Model;
glm::mat4 MVP;

glm::mat4 translation;
glm::mat4 trans_initial;
glm::mat4 rotation;


XDRFILE * xdrFile;
const char* file_trajectoire;
const char* file_couleur;
GLint NbAtoms;
GLfloat bbox[6];
GLfloat centre[3];
bool eof = false;

int stepstep;
float tps;
float box[9];



void get_first_frame()
{
  if (!eof) {
    if (xdrfile_getframe_header(&NbAtoms, &stepstep, &tps, box, xdrFile)!=1) {
      // La lecture de l'entête permet de récupérer des informations générales sur les trajectoires
      // NbAtoms : nombre d'atomes pour chaque frame
      // On peut donc allouer une taille aux tableaux des attributs
      atomes = new float[3*NbAtoms];
      coordonnees = new float[NbAtoms*3*12];      
      couleurs_par_atome = new float[3*NbAtoms];
      couleurs = new float[NbAtoms*3*12];
      translations_par_sommet = new float[NbAtoms*3*12];
      indices = new unsigned int[60*NbAtoms];
      char c;  
      
      ifstream f;
      float rgb[3];
      f.open(file_couleur,ios::in);

      int index = 0;
      f>>c;
      while (!f.eof()){
	choix_couleur(c,rgb);
	couleurs_par_atome[index] = rgb[0];
	couleurs_par_atome[index+1] = rgb[1];
	couleurs_par_atome[index+2] = rgb[2];
	index+=3;
	f>>c;
      }
      f.close();

      xdrfile_getframe_positions(NbAtoms, atomes, xdrFile);

      bbox[0] = atomes[0];
      bbox[1] = atomes[1];
      bbox[2] = atomes[2];
      bbox[3] = atomes[0];
      bbox[4] = atomes[1];
      bbox[5] = atomes[2];
      for (int i=1; i<NbAtoms; i++) {
	if (atomes[3*i]<bbox[0])
	  bbox[0] = atomes[3*i];
	if (atomes[3*i+1]<bbox[1])
	  bbox[1] = atomes[3*i+1];
	if (atomes[3*i+2]<bbox[2])
	  bbox[2] = atomes[3*i+2];
	if (atomes[3*i]>bbox[3])
	  bbox[3] = atomes[3*i];
	if (atomes[3*i+1]>bbox[4])
	  bbox[4] = atomes[3*i+1];
	if (atomes[3*i+2]>bbox[5])
	  bbox[5] = atomes[3*i+2];
      }
    }
    centre[0] = bbox[0]+(bbox[3]-bbox[0])/2;
    centre[1] = bbox[1]+(bbox[4]-bbox[1])/2;
    centre[2] = bbox[2]+(bbox[5]-bbox[2])/2;
  }


  // On recopie les sommets de l'icosaèdre autant de fois qu'il y a d'atomes
  for (int i=0; i<NbAtoms; i++)
    for (int j=0; j<36; j++)
      coordonnees[i*36+j] = sommets[j];

  // On recopie la couleur par atome pour chaque icosaèdre
  for (int i=0; i<NbAtoms; i++)
    for (int j=0; j<12; j++) {
      couleurs[i*36+j*3] = couleurs_par_atome[3*i];
      couleurs[i*36+j*3+1] = couleurs_par_atome[3*i+1];
      couleurs[i*36+j*3+2] = couleurs_par_atome[3*i+2];
    }
  
  // On recopie la translation à effectuer sur chaque sommet
  for (int i=0; i<NbAtoms; i++)
    for (int j=0; j<12; j++) {
      translations_par_sommet[i*36+j*3] = atomes[3*i];
      translations_par_sommet[i*36+j*3+1] = atomes[3*i+1];
      translations_par_sommet[i*36+j*3+2] = atomes[3*i+2];
    }
  
  for (int i=0; i<NbAtoms; i++)
    for (int j=0; j<60; j++)
      indices[i*60+j] = 12*i+indices_par_icosaedre[j];
  
  
}
 



void get_frame()
{
  if (xdrfile_getframe_header(&NbAtoms, &stepstep, &tps, box, xdrFile)!=1)  
    xdrfile_getframe_positions(NbAtoms, atomes, xdrFile);
  else {
    xdrfile_close(xdrFile);
    xdrFile = xdrfile_open(file_trajectoire,"r");
  }

  for (int i=0; i<NbAtoms; i++)
    for (int j=0; j<12; j++) {
      translations_par_sommet[i*36+j*3] = atomes[3*i];
      translations_par_sommet[i*36+j*3+1] = atomes[3*i+1];
      translations_par_sommet[i*36+j*3+2] = atomes[3*i+2];
    }

  
}



void init() {
  
  
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
  
  glClearDepth(1.0);
  glEnable(GL_DEPTH_TEST);
  
  programID = LoadShaders( "../Shaders/TrajectoireVertexShader.vert", "../Shaders/ColorFragShader.frag");
  get_first_frame();
  
  
  glGenVertexArrays(1, &vaoID);
  glBindVertexArray(vaoID);
  
  glGenBuffers(4,vboID);
  
  glBindBuffer(GL_ARRAY_BUFFER, vboID[0]);
  glBufferData(GL_ARRAY_BUFFER,3*12*NbAtoms*sizeof(float),coordonnees,GL_STATIC_DRAW);
  glVertexAttribPointer(0,3,GL_FLOAT,GL_FALSE,0,(void*)0);
  glEnableVertexAttribArray(0);
  
  glBindBuffer(GL_ARRAY_BUFFER, vboID[1]);
  glBufferData(GL_ARRAY_BUFFER,3*12*NbAtoms*sizeof(float),couleurs,GL_STATIC_DRAW);
  glVertexAttribPointer(1,3,GL_FLOAT,GL_FALSE,0,(void*)0);
  glEnableVertexAttribArray(1);

  glBindBuffer(GL_ARRAY_BUFFER, vboID[2]);
  glBufferData(GL_ARRAY_BUFFER,3*12*NbAtoms*sizeof(float),translations_par_sommet,GL_DYNAMIC_DRAW);
  glVertexAttribPointer(2,3,GL_FLOAT,GL_FALSE,0,(void*)0);
  glEnableVertexAttribArray(2);

  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vboID[3]);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER,NbAtoms*60*sizeof(GLuint),indices,GL_STATIC_DRAW);
  

  MatrixID = glGetUniformLocation(programID, "MVP");
  
  Projection = glm::perspective(70.0f, 4.0f / 3.0f, 0.1f, 1000.0f);
  View = glm::lookAt(glm::vec3(0,0,2*bbox[5]), glm::vec3(0,0,0), glm::vec3(0,1,0));
  
  trans_initial = glm::translate(glm::mat4(1.0f), glm::vec3(-centre[0],-centre[1],-centre[2]));
  
  Model = glm::mat4(1.0f);
  
  MVP = Projection * View * Model;

  rotation = glm::mat4(1.0f);
  
  translation = glm::mat4(1.0f);
  

}

void Display(void) {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  glUseProgram(programID);
  
  Model = translation * rotation * trans_initial;
  
  MVP =  Projection * View * Model;

  glUniformMatrix4fv(MatrixID, 1, GL_FALSE, &MVP[0][0]);
  
  //  cout << "avant le dessin" << endl;
  glDrawElements(GL_TRIANGLES, 60*NbAtoms, GL_UNSIGNED_INT, NULL);
  //  cout << "après le dessin" << endl;

  
  glutSwapBuffers();
  
}

void Idle()
{
  
  get_frame();
  
  glBindBuffer(GL_ARRAY_BUFFER, vboID[2]);
  glBufferData(GL_ARRAY_BUFFER,3*12*NbAtoms*sizeof(float),translations_par_sommet,GL_DYNAMIC_DRAW);
  glutPostRedisplay();
  
}

void ClavierClassique(unsigned char key, int x, int y)
{
  switch(key) {	
  case 0x1B:
    exit(0);
  }
}

void ClavierSpecial(int key, int x, int y)
{
  switch(key) {
  case GLUT_KEY_UP:
    translation = glm::translate(translation, glm::vec3(0.f, stepTrans, 0.f));
    break;
  case GLUT_KEY_DOWN:
    translation = glm::translate(translation, glm::vec3(0.f, -stepTrans, 0.f));
    break;
  case GLUT_KEY_RIGHT:
    translation = glm::translate(translation, glm::vec3(stepTrans, 0.f, 0.f));
    break;
  case GLUT_KEY_LEFT:
    translation = glm::translate(translation, glm::vec3(-stepTrans, 0.f, 0.f));
    break;
  case GLUT_KEY_PAGE_UP:
    translation = glm::translate(translation, glm::vec3(0.f, 0.f, stepTrans));
    break;
  case GLUT_KEY_PAGE_DOWN:
    translation = glm::translate(translation, glm::vec3(0.f, 0.f, -stepTrans));
    break;
  }
  glutPostRedisplay();  
}

void Souris(int bouton, int etat, int x, int y)
{	  
    switch (bouton) {
      case GLUT_LEFT_BUTTON :
	if (etat==GLUT_DOWN) {
	  leftbutton=true;
	  mouseXOld = x;
	  mouseYOld = y;
	}
	else
	leftbutton=false;
	break;
      case GLUT_MIDDLE_BUTTON :
	if (etat==GLUT_DOWN) {
	  middlebutton=true;
	  mouseXOld = x;
	  mouseYOld = y;
	}
	else
	middlebutton=false;
	break;
      case GLUT_RIGHT_BUTTON:
	if (etat==GLUT_DOWN) {
	  rightbutton=true;
	  mouseXOld = x;
	  mouseYOld = y;
	}
	else
	  rightbutton=false;
	break;
    }
    glutPostRedisplay();  
}  
void Motion (int x, int y)
{
   if (middlebutton) {
     if (abs(y-mouseYOld) > abs(x-mouseXOld)) 
       translation = glm::translate(translation, glm::vec3(0.f, 0.f, -(y-mouseYOld)*stepTrans/10));
     else 
       translation = glm::translate(translation, glm::vec3(0.f, 0.f, -(x-mouseYOld)*stepTrans/10));
     mouseXOld=x;
     mouseYOld=y;
   }
   else if (rightbutton) {
     translation = glm::translate(translation, glm::vec3(-(x-mouseXOld)*stepTrans/10, -(y-mouseYOld)*stepTrans/10, 0.f));
     mouseXOld=x;
     mouseYOld=y;
   }
   
   if (leftbutton){
     rotation = glm::rotate(rotation, (x-mouseXOld)*stepTrans, glm::vec3(0.f, 1.f, 0.f));
     rotation = glm::rotate(rotation, -(y-mouseXOld)*stepTrans, glm::vec3(1.f, 0.f, 0.f));
     mouseXOld=x;
     mouseYOld=y;
   }
   glutPostRedisplay();     
}

int main(int argc, char** argv)
{

  file_trajectoire = argv[1];
  file_couleur = argv[2];
  
  xdrFile = xdrfile_open(file_trajectoire,"r"); //Ouverture du fichier en lecture

  glutInit (&argc,argv) ;
  glutInitContextVersion(3, 3);
  
  glutInitContextProfile(GLUT_CORE_PROFILE);
  
  glutInitContextFlags(GLUT_FORWARD_COMPATIBLE);


  
  glutInitDisplayMode (GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH) ;
  glutInitWindowSize (500,500) ;
  glutInitWindowPosition (100, 100) ;
  glutCreateWindow ("GLUT") ;

  glewExperimental = GL_TRUE;   
  GLenum err = glewInit();

  init();

  glutDisplayFunc(Display);
  glutIdleFunc(Idle);
  glutKeyboardFunc(ClavierClassique);
  glutSpecialFunc(ClavierSpecial);
  glutMouseFunc(Souris);
  glutMotionFunc(Motion);

  glutMainLoop () ;

  xdrfile_close(xdrFile);
  return 0 ;
  
}
