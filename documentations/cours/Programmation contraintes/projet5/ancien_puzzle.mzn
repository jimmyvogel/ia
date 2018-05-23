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
set of int: TAILLEP1 = 1..n+1;
set of int: NBPIECES = 1..4;
set of int: DIRECTIONS = 1..4;
set of int: POSSIBILITIES = 1..nb_couleurs*nb_couleurs2*nb_formes*nb_variantes;

array[NOMBRES, NBPIECES] of POSSIBILITIES: t;
array[NBPIECES] of 1..10: tuile = [2,4,6,9];

%en imaginant que l'on suit les données du prof, on a la représentation des pieces dans le sens:
%nord, puis aiguille d'une montre.

%direction nord, direction 'normale'
array[DIRECTIONS,NBPIECES] of DIRECTIONS: ind = [|1,2,3,4|2,3,4,1|3,4,1,2|4,1,2,3|];

%VARIABLES 
array[NOMBRES] of var NOMBRES: base;
array[TAILLE,TAILLE] of var NOMBRES: m;
array[TAILLEP1,TAILLEP1] of var POSSIBILITIES: batons;
array[NOMBRES] of var DIRECTIONS: dir;
var n..nb_couleurs*nb_couleurs2*nb_formes*nb_variantes*n: max;

%PREDICAT:

% Deux pièces sont identiques et ne sont pas grises.
predicate piece_egal(int:i1,int:j1,var int:npiece,int:i2,int:j2,var int:npiece2) 
             = t[m[i1,j1],npiece]!=gris /\ t[m[i1,j1],npiece]=t[m[i2,j2],npiece2];                               

%CONTRAINTES:

%Transformation d'une matrice à un tableau
constraint forall(i, j in TAILLE)(base[i+n*(j-1)]=m[j,i]);
%tableau en termes d'indice 1-49
%matrice en termes d'indice (i:la hauteur,j:la largeur)

%contraintes toutes les tuiles doivent être utilisés.
constraint alldifferent(base);

%contraintes pour les éléments centraux: pas de gris ; et tous les éléments égaux dans les 4 directions.
constraint forall(i,j in 2..n-1)(piece_egal(i,j,  ind[dir[m[i,j]],1],  i-1,j,  ind[dir[m[i-1,j]],3])
                              /\ piece_egal(i,j,  ind[dir[m[i,j]],2],  i,j+1,  ind[dir[m[i,j+1]],4])
                              /\ piece_egal(i,j,  ind[dir[m[i,j]],3],  i+1,j,  ind[dir[m[i+1,j]],1])
                              /\ piece_egal(i,j,  ind[dir[m[i,j]],4],  i,j-1,  ind[dir[m[i,j-1]],2]));
                                  
% contrainte pour les éléments sur le côté gauche et droit sauf les coins: 
%  1 -pas de gris pour le bas et le haut.
%  2 -éléments égaux pour le bas et le haut.
constraint forall(i in 2..n-1, j in {1,n})(piece_egal(i,j,  ind[dir[m[i,j]],1],  i-1,j,  ind[dir[m[i-1,j]],3])
                                        /\ piece_egal(i,j,  ind[dir[m[i,j]],3],  i+1,j,  ind[dir[m[i+1,j]],1]));

% contrainte pour les éléments sur le côté haut et bas sauf les coins: 
%  1 -pas de gris pour la gauche et la droite.
%  2 -éléments égaux pour la gauche et la droite.
constraint forall(j in 2..n-1, i in {1,n})(piece_egal(i,j,  ind[dir[m[i,j]],2],  i,j+1,  ind[dir[m[i,j+1]],4])
                                        /\ piece_egal(i,j,  ind[dir[m[i,j]],4],  i,j-1,  ind[dir[m[i,j-1]],2]));
                                        
% contrainte gris sur les bords.(coins compris)
constraint forall(i in TAILLE)(t[m[i,1],ind[dir[m[i,1]],4]]=gris
                             /\t[m[i,n],ind[dir[m[i,n]],2]]=gris
                             /\t[m[1,i],ind[dir[m[1,i]],1]]=gris
                             /\t[m[n,i],ind[dir[m[n,i]],3]]=gris);

% contrainte pour supprimer la rotation complète de la grille (a partir de 4 égalité rare):
% - la plus grande somme des valeurs d'un côté doit être le côté nord.
constraint sum(i in TAILLE)(t[m[1,i],ind[dir[m[1,i]],2]])>=sum(i in TAILLE)(t[m[i,n],ind[dir[m[i,n]],3]])
        /\ sum(i in TAILLE)(t[m[1,i],ind[dir[m[1,i]],2]])>=sum(i in TAILLE)(t[m[i,1],ind[dir[m[i,1]],1]])
        /\ sum(i in TAILLE)(t[m[1,i],ind[dir[m[1,i]],2]])>=sum(i in TAILLE)(t[m[n,i],ind[dir[m[n,i]],4]]);

constraint max = sum(i in TAILLE)(t[m[i,1],ind[dir[m[i,1]],2]]);

%RESOLUTION
solve satisfy;

%AFFICHAGE
output[show(max), "\n", show(base), "\n", show(dir), "\n"];