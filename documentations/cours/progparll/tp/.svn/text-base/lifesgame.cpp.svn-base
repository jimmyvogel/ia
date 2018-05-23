#include <mpi.h>
#include <stdio.h>
#include <ctime>
#include <cstdlib>
#include "grille.hpp"
#define ITER 200
#define TAILLE 10
using namespace std;

int main ( int argc , char **argv ){
  srand(time(NULL));
  myGrid * theGrid = new myGrid(TAILLE,TAILLE,10);
  int pid;
  int nbprocs;
  int tanche;
  int res_tranche; 
  bool ** content ; 
  bool * pred;
  bool * suiv;
  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD,&nbprocs);//nb total de proc
  MPI_Comm_rank(MPI_COMM_WORLD,&pid);//mon pid

  //init des tableaux
  tranche = TAILLE / nbprocs;
  res_tranches = TAILLE%nbprocs;

  //grande boucle d'iteration
  for( int etape = 0 ; etape< ITER; etape++){
    //partie processus dont le pid est pair
    if( pid%2 == 0 ){ //cas pair, send et enuite recvr
    
    }
    // envoi
    MPI_Ssend
    // reception
    //calcul
    //si pid = 0 alors gather +affichage
    else{
      //partie pid impair
      //recep
      //envoi
      //calcul
      //juste gather
    }
  }

}
