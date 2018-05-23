#include <iostream>
#include <GL/glew.h>
#include <GL/glut.h>
#include <GL/gl.h>
#include <GL/glu.h>
#include <math.h>
#include <iostream>
#include <fstream>

#include "shaders_utilities.hpp"
#include "lecture_trajectoire.hpp"

#define GLM_FORCE_RADIANS
// Include GLM
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
using namespace glm;

using namespace std;

// Pour la fenêtre
GLsizei width = 500;
GLsizei height = 500;


// Pour la navigation
float stepTrans=1.0;
int mouseXOld, mouseYOld;
bool boutongauche = false;
bool boutondroit = false;
bool buttonmollette = false;

//Mettre en wait la simulation
bool wait = false;

// Pour les identifiants des VBO
GLuint vboid[4];

// Identifiant des shaders liés au programme
GLuint programID;

// Identifiant des 2 variables transmises au vertex shader
GLuint MatrixID; // Uniform pour la matrice
GLuint TransID;  // Attribute pour la translation des cubes

// Les différentes matrices gérées par la librairie glm
glm::mat4 Projection;
glm::mat4 View;
glm::mat4 Model;
glm::mat4 MVP;

glm::mat4 translation;
glm::mat4 trans_initial;
glm::mat4 rotation;

//Positionnement translation pour les événements
float axeX;
float axeY;
float axeZ;
float rotationValueY;
float rotationValueX;

// Pour la lecture de la trajectoire
XDRFILE * xdrFile; //le fichier
GLint NbAtoms; // le nombre d'atomes par frame
GLfloat bbox[6]; //la boite englobante (xmin,ymin,zmin,xmax,ymax,zmax)
GLfloat centre[3]; // le centre de la boite englobante 
bool eof = false; // test fin de fichier

// Pour les sommets et leurs attributs
GLuint sommetparcube = 12; // nombre de sommet par cube
GLuint facetparcube = 20; // nombre de facet par cube

GLfloat* positions; // pour la lecture du frame et la position des atomes
GLfloat* couleurs; // pour la lecture du frame et la traduction type d'atomes -> couleur

// Pour les VBO
GLfloat* coord_attribute;
GLfloat* couleurs_attribute; 
GLuint* lesindices;
GLfloat* positions_attribute;

static GLfloat sommets[36] =
{
  // devant
  -1.0, -1.0,  1.0,
  1.0, -1.0,  1.0,
  1.0,  1.0,  1.0,
  -1.0,  1.0,  1.0,
  // derrière
  -1.0, -1.0, -1.0,
  1.0, -1.0, -1.0,
  1.0,  1.0, -1.0,
  -1.0,  1.0, -1.0,
  
};

// Le tableau d'indices correspondant
GLuint indices[60] =
  {
	// face
	0, 1, 2,
	2, 3, 0,
	// haut
	1, 5, 6,
	6, 2, 1,
	// dos
	7, 6, 5,
	5, 4, 7,
	// fond
	4, 0, 3,
	3, 7, 4,
	// gauche
	4, 5, 1,
	1, 0, 4,
	// droite
	3, 2, 6,
	6, 7, 3,
};

 
/*
Fonction pour lire la première frame de la trajectoire et construire
 les tableaux en allouant la bonne taille en mémoire 
 Seuls les tableaux positions et positions_attribute seront modifiés par la suite*/

void get_first_frame()
{
  int step;
  float tps;
  float box[9];
  if (!eof) {
	if (xdrfile_getframe_header(&NbAtoms, &step, &tps, box, xdrFile)!=1) {  
	  //allocations mémoire
	  positions = new float[3*NbAtoms];    
	  couleurs = new float[3*NbAtoms];
	  positions_attribute = new float[3*NbAtoms*sommetparcube];
	  couleurs_attribute  = new float[3*NbAtoms*sommetparcube];
	  coord_attribute = new float[3*NbAtoms*sommetparcube];
	  lesindices = new unsigned int[3*NbAtoms*facetparcube];
	  char c;  

	  //pour les couleurs grace à un fichier qui associe type d'atome et couleur
	  ifstream f;
	  float rgb[3];
	  f.open("gestioncouleur.txt",ios::in);

	  int index = 0;
	  f>>c;
	  while (!f.eof()){
	choix_couleur(c,rgb);
	couleurs[index] = rgb[0];
	couleurs[index+1] = rgb[1];
	couleurs[index+2] = rgb[2];
	index+=3;
	f>>c;
	  }
	  f.close();

	  // Après l'entete lecture des positions de la première frame
	  xdrfile_getframe_positions(NbAtoms, positions, xdrFile);

	  // construction de la boite englobante en parcourant les positions des atomes
	  //pour chercher le coin en bas à gauche et le coin en haut à droite
	  bbox[0] = positions[0];
	  bbox[1] = positions[1];
	  bbox[2] = positions[2];
	  bbox[3] = positions[0];
	  bbox[4] = positions[1];
	  bbox[5] = positions[2];
	  for (int i=1; i<NbAtoms; i++) {
	if (positions[3*i]<bbox[0])
	  bbox[0] = positions[3*i];
	if (positions[3*i+1]<bbox[1])
	  bbox[1] = positions[3*i+1];
	if (positions[3*i+2]<bbox[2])
	  bbox[2] = positions[3*i+2];
	if (positions[3*i]>bbox[3])
	  bbox[3] = positions[3*i];
	if (positions[3*i+1]>bbox[4])
	  bbox[4] = positions[3*i+1];
	if (positions[3*i+2]>bbox[5])
	  bbox[5] = positions[3*i+2];
	  }
	}
	// Calcul du centre de la boite englobante
	centre[0] = bbox[0]+(bbox[3]-bbox[0])/2;
	centre[1] = bbox[1]+(bbox[4]-bbox[1])/2;
	centre[2] = bbox[2]+(bbox[5]-bbox[2])/2;
  }

  //Construction des tableaux
  // positions_attribute est construit en répétant la position d'un atome autant de fois qu'il y a de sommets dans le cube
  // idem pour couleurs_attribute on répéte la couleur d'un atome autant de fois qu'il y a de sommets dans le cube
  // coord_attribute contient NbAtoms fois le cube de base
  for (int i=0; i<NbAtoms; i++) {
	for (int j=0; j<sommetparcube; j++) {
	  positions_attribute[3*sommetparcube*i+3*j] = positions[3*i];
	  positions_attribute[3*sommetparcube*i+3*j+1] = positions[3*i+1];
	  positions_attribute[3*sommetparcube*i+3*j+2] = positions[3*i+2];
	  couleurs_attribute[3*sommetparcube*i+3*j] = couleurs[3*i];
	  couleurs_attribute[3*sommetparcube*i+3*j+1] = couleurs[3*i+1];
	  couleurs_attribute[3*sommetparcube*i+3*j+2] = couleurs[3*i+2];
	  coord_attribute[sommetparcube*3*i+3*j] = sommets[3*j];
	  coord_attribute[sommetparcube*3*i+3*j+1] = sommets[3*j+1];
	  coord_attribute[sommetparcube*3*i+3*j+2] = sommets[3*j+2];      
	}
  }
  // Pour les indices on répète le tableau indices du cube de base NbAtoms fois mais en décalant les indices du nombre de sommets
  // il faut bien séparer les sommets car ils ont des attributs différents
  for (int i=0; i<NbAtoms; i++) {
	for (int j=0; j<facetparcube; j++) {
	  lesindices[facetparcube*3*i+3*j] = 12*i+indices[3*j];
	  lesindices[facetparcube*3*i+3*j+1] = 12*i+indices[3*j+1];
	  lesindices[facetparcube*3*i+3*j+2] = 12*i+indices[3*j+2];
	}
  }
}

// Lecture des autres frames avec mise à jour du tableau positions
void get_frame()
{

  int step;
  float tps;
  float box[9];


  if (xdrfile_getframe_header(&NbAtoms, &step, &tps, box, xdrFile)!=1)  {
	xdrfile_getframe_positions(NbAtoms, positions, xdrFile);       
  }
  else {
	xdrfile_close(xdrFile);
	xdrFile = xdrfile_open("00_peptide.200_traj1.xtc","r");
  }
   for (int i=0; i<NbAtoms; i++) {
	for (int j=0; j<sommetparcube; j++) {
	  positions_attribute[3*sommetparcube*i+3*j] = positions[3*i];
	  positions_attribute[3*sommetparcube*i+3*j+1] = positions[3*i+1];
	  positions_attribute[3*sommetparcube*i+3*j+2] = positions[3*i+2];
	}
  }
}


/* La fonction init va lier les shaders au programme
créer les VBO
initialiser les 2 variables Uniform et Attribute à transmettre au vertex shader
initialiser les matrices : projection view et model avec les transformations (translatio/rotation) à effectuer
*/
void init() {
  
  
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

  glClearDepth(1.0);
  glEnable(GL_DEPTH_TEST);

  //programID est l'identifiant du "programme shader"
  // les shaders ont été chargés et liés au programme OpenGL
  programID = LoadShaders( "VertexShader.vert", "FragmentShader.frag" );

  // lecture de la première frame
  get_first_frame();
 
  // Création des VBO
  glGenBuffers ( 3 , vboid ) ;
  glBindBuffer ( GL_ARRAY_BUFFER , vboid[0]) ;
  glBufferData ( GL_ARRAY_BUFFER , NbAtoms*sommetparcube*3* sizeof(float) , coord_attribute , GL_STATIC_DRAW ) ;

  glBindBuffer ( GL_ARRAY_BUFFER , vboid[1]) ;
  glBufferData ( GL_ARRAY_BUFFER , NbAtoms*sommetparcube*3* sizeof(float) , couleurs_attribute , GL_STATIC_DRAW ) ;

  glBindBuffer ( GL_ARRAY_BUFFER , vboid[2]) ;
  glBufferData ( GL_ARRAY_BUFFER , NbAtoms*sommetparcube*3* sizeof(float) , positions_attribute , GL_STATIC_DRAW );

  glBindBuffer ( GL_ELEMENT_ARRAY_BUFFER , vboid[3]) ;
  glBufferData ( GL_ELEMENT_ARRAY_BUFFER , NbAtoms*facetparcube*3* sizeof(int) , lesindices , GL_STATIC_DRAW );

  //???
  GLint loc2 = glGetAttribLocation(programID , "centres") ;
  glEnableVertexAttribArray( loc2 ) ;
  glBindBuffer ( GL_ARRAY_BUFFER , vboid[2]) ;
  glVertexAttribPointer( loc2 , 3 , GL_FLOAT , GL_FALSE , 3*sizeof( GL_FLOAT ) , 0) ;

  
  // MatrixID est l'identifiant de la variable uniform de nom MVP dans le vertex shader
  MatrixID = glGetUniformLocation(programID, "MVP");

  // Les matrices Projection, View et Model...
  Projection = glm::perspective(70.0f, 4.0f / 3.0f, 0.1f, 1000.0f);
  View = glm::lookAt(glm::vec3(0,0,-15), glm::vec3(0,0,0), glm::vec3(0,1,0));
  
  trans_initial = glm::translate(glm::mat4(1.0f), glm::vec3(-centre[0],-centre[1],-centre[2]));
  
  Model = glm::mat4(1.0f);

  MVP = Projection * View * Model; 
  
  rotationValueX=0;
  rotationValueY=0;
  rotation = glm::mat4(1.0f);

  //Matrice de translation pour les événements clés souris
  axeX = 0;
  axeY = 0;
  axeZ = 35;
  translation = glm::translate(glm::mat4(1.0f), glm::vec3(axeX,axeY,axeZ));

}

//La fonction d'affichage
void Display(void) {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  // Pour activer l'utilisation des shaders
  glUseProgram(programID);

  // Tranfert de la matrice finale au Vertex shader
  // Comme elle peut etre modifiée par les différents événement souris/clavier
  // le transfert est fait à chaque dessin
  Model = translation * rotation * trans_initial;
  MVP =  Projection * View * Model;
  glUniformMatrix4fv(MatrixID, 1, GL_FALSE, &MVP[0][0]);

  // Définitions des VBO correspondant aux sommets et aux couleurs
  glBindBuffer ( GL_ARRAY_BUFFER , vboid[0]);
  glVertexPointer( 3 ,GL_FLOAT , 3 * sizeof(float), 0);
  glBindBuffer ( GL_ARRAY_BUFFER , vboid[1]);
  glColorPointer ( 3 , GL_FLOAT , 3 * sizeof(float), 0 );
  glBindBuffer ( GL_ELEMENT_ARRAY_BUFFER , vboid[3]);
  
  //Activation
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_COLOR_ARRAY);

  // glDrawElements va lancer le pipeline graphique
  glDrawElements( GL_TRIANGLES, NbAtoms*facetparcube*3, GL_UNSIGNED_INT, lesindices);

  glDisableClientState( GL_COLOR_ARRAY );
  glDisableClientState( GL_VERTEX_ARRAY );

  glutSwapBuffers();

}

/* Dans la fonction Idle on prend le temps de lire une nouvelle frame
et de mettre à jour la variable attribute correspondant au déplacement sur les sommets de 
chaque cube */
void Idle()
{
  	get_frame();
  	glBindBuffer ( GL_ARRAY_BUFFER , vboid[2]) ;
  	glBufferData ( GL_ARRAY_BUFFER , NbAtoms*sommetparcube*3* sizeof(int) , positions_attribute , GL_STATIC_DRAW );
  	
	rotation = glm::rotate(rotation, rotationValueX, glm::vec3(0.f, 1.f, 0.f));
    rotation = glm::rotate(rotation, rotationValueY, glm::vec3(1.f, 0.f, 0.f));
  	translation = glm::translate(glm::mat4(1.0f), glm::vec3(axeX,axeY,axeZ));
  	glutPostRedisplay();
}

void ClavierClassique(unsigned char key, int x, int y)
{
  switch(key) { 
  case 'q':
	exit(0);
  case 'p':
	wait = !wait;
	break;
  }
}

//TODO
void ClavierSpecial(int key, int x, int y)
{
  switch(key) {
  case GLUT_KEY_UP:
	axeY = axeY-1;
	break;
  case GLUT_KEY_DOWN:
	axeY = axeY+1;
	break;
  case GLUT_KEY_RIGHT:
	axeX = axeX+1;
	break;
  case GLUT_KEY_LEFT:
	axeX = axeX-1;
	break;
  case GLUT_KEY_PAGE_UP:
	axeZ = axeZ-1;
	break;
  case GLUT_KEY_PAGE_DOWN:
	axeZ = axeZ+1;
	break;
  }
  glutPostRedisplay();  
}

void Souris(int bouton, int etat, int x, int y)
{     
	switch (bouton) {
	  case GLUT_LEFT_BUTTON :
	if (etat==GLUT_DOWN) {
	  boutongauche=true;
	  mouseXOld = x;
	  mouseYOld = y;
	}
	else
	boutongauche=false;
	break;
	  case GLUT_MIDDLE_BUTTON :
	if (etat==GLUT_DOWN) {
	  buttonmollette=true;
	  mouseXOld = x;
	  mouseYOld = y;
	}
	else
	buttonmollette=false;
	break;
	  case GLUT_RIGHT_BUTTON:
	if (etat==GLUT_DOWN) {
	  boutondroit=true;
	  mouseXOld = x;
	  mouseYOld = y;
	}
	else
	  boutondroit=false;
	break;
	}
	glutPostRedisplay();  
}

void Motion (int x, int y)
{
  	if (boutondroit) {
		float norm=abs(axeZ);
		if(norm>1){
			axeX = axeX + (mouseXOld-x )/norm;
			axeY = axeY + (mouseYOld-y )/norm;            
		}
		mouseXOld=x;
 		mouseYOld=y;
   }
   if (buttonmollette) {
		float norm=abs(axeZ);
		if(norm>1){
			axeX = axeX + (mouseXOld-x )/norm;
			axeY = axeY + (mouseYOld-y )/norm;            
		}
		mouseXOld=x;
 		mouseYOld=y;
   }   
   if (boutongauche){
		float norm=abs(axeZ)*2;
		if(norm>1){
			rotationValueX = (x-mouseXOld)/norm;
			rotationValueY = -(y-mouseXOld)/norm;
		}
		mouseXOld=x;
 		mouseYOld=y;

   }
   glutPostRedisplay();    
}

int main(int argc, char** argv)
{
  xdrFile = xdrfile_open("00_peptide.200_traj1.xtc","r"); //Ouverture du fichier en lecture

  glutInit (&argc,argv) ;
  glutInitDisplayMode (GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH) ;
  glutInitWindowSize (width,height) ;
  glutInitWindowPosition (100, 100) ;
  glutCreateWindow ("GLUT") ;
  GLenum err = glewInit();

  init();
  glutDisplayFunc(Display);
  glutKeyboardFunc(ClavierClassique);
  glutSpecialFunc(ClavierSpecial);
  glutMouseFunc(Souris);
  glutMotionFunc(Motion);
  glutIdleFunc(Idle);

  glutMainLoop () ;

  xdrfile_close(xdrFile);
  return 0 ;
  
}
