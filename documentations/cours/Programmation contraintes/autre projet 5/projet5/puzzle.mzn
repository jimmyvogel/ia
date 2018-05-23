include "globals.mzn";

%CONSTANTES
int:n;
int:nb_couleurs;
int:nb_couleurs2;
int:nb_formes;
int:nb_variantes;
int:gris;

set of int: TAILLE = 1..n;
set of int: NOMBRES = 1..n*n;
set of int: NBPIECES = 1..4;
set of int: DIRECTIONS = 1..4;
set of int: POSSIBILITIES = 1..nb_couleurs*nb_couleurs2*nb_formes*nb_variantes;


%On défini une piece comme une partie d'une tuile, une tuile comporte 4 pièces
%Notre tableau de tuiles, une tuile est représenté par toute ses pièces
array[NOMBRES, NBPIECES] of POSSIBILITIES: t;
array[NBPIECES] of 1..10: tuile = [2,4,6,9];

%Direction des pièces d'une tuile dans l'ordre suivant : NORD,EST,SUD,EST.
%1..4 étant l'emplacement d'une pièce dans t
array[DIRECTIONS,NBPIECES] of DIRECTIONS: ind = [|1,2,3,4|2,3,4,1|3,4,1,2|4,1,2,3|];

%VARIABLES 
array[NOMBRES] of var NOMBRES: base;

array[TAILLE,TAILLE] of var NOMBRES: m;
%Matrice de contrainte haut vers bas
array[1..n+1,TAILLE] of var POSSIBILITIES: nordSud;
%Matrice de contrainte gauche vers droite
array[TAILLE,1..n+1] of var POSSIBILITIES: ouestEst;
%Direction d'une tuile cf ind
array[NOMBRES] of var DIRECTIONS: dir;



%PREDICAT:

%On contraint toute les pièces d'une tuile i,j a ces voisins
predicate place(int:i, int:j) = nordSud[i,j]=t[m[i,j],ind[dir[m[i,j]],1]]
                              /\nordSud[i+1,j]=t[m[i,j],ind[dir[m[i,j]],3]]
                              /\ouestEst[i,j]=t[m[i,j],ind[dir[m[i,j]],4]]
                              /\ouestEst[i,j+1]=t[m[i,j],ind[dir[m[i,j]],2]];
%CONTRAINTES:

%Transformation d'une matrice à un tableau pour permettre la contrainte alldifferent
constraint forall(i, j in TAILLE)(base[i+n*(j-1)]=m[j,i]);

%contraintes toutes les tuiles doivent être utilisés.
constraint alldifferent(base);

%contraint tous les tuiles pour que leurs pièces soient égale à leurs voisines dans les 4 directions.
constraint forall(i,j in TAILLE)(place(i,j));
                                                                 
% contrainte gris sur les bords.(coins compris)
constraint forall(i in TAILLE)(nordSud[1,i]=gris
                               /\nordSud[n+1,i]=gris
                               /\ouestEst[i,1]=gris
                               /\ouestEst[i,n+1]=gris);


%RESOLUTION
solve satisfy;

%AFFICHAGE
output[show(base), "\n", show(dir), "\n"];