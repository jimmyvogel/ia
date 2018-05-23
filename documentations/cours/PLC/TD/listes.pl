/* ====================================================
             Prédicats sur les listes
   ====================================================  */

/*
  affiche(L) est vrai si tous les éléments de la liste L sont écrits dans l'ordre.
*/

affiche([]).
affiche([X|R]) :- write(X), nl, affiche(R).

/*
  affiche2(L) est vrai si tous les éléments de la liste L sont écrits en ordre inverse.
*/

affiche2([]).
affiche2([X|R]) :- affiche2(R), write(X), nl.

/*
  Retrouver le premier élément d'une liste : 
  premier1(L,X) est vrai si X est le premier élement de L.
*/

premier1([X|_],X).

/*
  Afficher le premier élément d'une liste : 
  premier2(L) est vrai si le premier élément de la liste L est affiché (et aucun autre).
*/

premier2([X|_]) :- write(X),nl.

/*
  Retrouver le dernier élément d'une liste : 
  dernier1(L,X) est vrai si X est le dernier élement de L.
*/

dernier1([X],X).
dernier1([_|L],X) :- dernier1(L,X).

/*
  Afficher le dernier élément d'une liste : 
  dernier2(L) est vrai si le dernier élément de la liste L est affiché (et aucun autre).
*/

dernier2([X]) :- write(X),nl.
dernier2([_|L]) :- dernier2(L).

/*
  element(X,L) est vrai si X est élément de la liste L.
*/

element(X,[X|_]).
element(X,[_|R]) :- element(X,R).

/*
On peut l'utiliser sous la forme element(2,[1,3,5,8]) mais aussi element(X,[1,3,5,8]).
Il existe un prédicat prédéfini en Prolog qui fait exactement la même chose : 
     member(X,L), vrai si X est dans la liste L.
*/

/*
  compte(L,N) est vrai si N est le nombre d'éléments dans la liste L.
*/

compte([],0).
compte([_|R],N) :- 
	compte(R,N1), 
	N is N1+1.

/*
  somme(L,N) est vrai si N est la somme des éléments de la liste d'entiers L.
*/

somme([],0).
somme([X|R],N) :- 
	somme(R,N1), 
	N is N1+X.

/*
Attention, un prédicat somme(...) a déjà été défini dans le TD n°2. 
Si vous rangez toutes vos définitions dans le même fichier cela va entraîner des conflits. 
Dans ce cas il faut en renommer un des deux.
*/

/*
  nieme(N,L,X) est vrai si X est le N-ème élément de la liste L.
  La variable anonyme "_" est utilisée quand il n'est pas nécessaire de la nommer.
  Ceci évite d'ailleurs le warning du compilateur "sigleton variable" qui indique qu'une variable apparait une seule fois (dans la tête de la clause et pas dans le corps).
  C'est parfois involentaire à cause d'une faute de frappe.
*/

nieme(1,[X|_],X) :- !.
nieme(N,[_|R],X) :- 
	N1 is N-1, 
	nieme(N1,R,X).

/*
  occurrence(L,X,N) est vrai si N est le nombre de fois où X est présent dans la liste L.
*/

occurrence([],_,0).
occurrence([X|L],X,N) :- 
	occurrence(L,X,N1),
	N is N1+1.
occurrence([Y|L],X,N) :- 
	X\==Y,
	occurrence(L,X,N).

/*
  Fonctionne sous la forme occurrence([1,5,3,5,5,2,2,8],2,X) et, moins bien, sous la forme occurrence([1,5,3,5,5,2,2,8],X,2).
*/

/*
  sous-ensemble(L1,L2) est vrai si tous les éléments de la liste L1 font partie de la liste L2.
*/

sous_ensemble([],_).
sous_ensemble([X|R],L2) :- 
	element(X,L2),
	sous_ensemble(R,L2).

/*
  On peut l'utiliser sous la forme sous-ensemble([1,2,8],[1,3,5,2,8]) et pas sous la forme sous-ensemble(X,[1,3,5,2,8]).
*/

/*
  substitue(X,Y,L1,L2) est vrai si L2 est le résultat du remplacement de X par Y dans L1.
*/

substitue(_,_,[],[]).
substitue(X,Y,[X|R],[Y|R1]) :- 
	substitue(X,Y,R,R1).
substitue(X,Y,[Z|R],[Z|R1]) :- 
	X\==Z, substitue(X,Y,R,R1).

/*
  retourne(L,L1) est vrai si la liste L1 est la liste L dans l'ordre inverse
*/

retourne([],[]).
retourne([X|R],L1) :- 
	retourne(R,R1),
	append(R1,[X],L1).
