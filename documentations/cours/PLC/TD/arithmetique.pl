/* ====================================================
             Prédicats sur l'arithmétique
   ====================================================  */

/* Somme de deux nombres */

somme(X,Y,S) :- S is X+Y.

% Attention : dans le prédicat suivant, X+Y est un terme. 
%             Il ne permet pas d'évaluer la somme!

somme2(X,Y,X+Y).


/* Le plus grand de deux nombres */

max2(X,Y,X) :- X>=Y.
max2(X,Y,Y) :- X<Y.



/* Certains étudiants écrivent ceci : */

max2bis(X,Y,Z) :- X>=Y, Z=X.
max2bis(X,Y,Z) :- X<Y, Z=Y.

/* ... en pensant : si X est supérieur à Y alors on AFFECTE à Z la valeur de X.
   Le prédicat max2bis n'est pas faux mais le but Z=X se dit : vrai si Z et X sont UNIFIABLES
*/

/* Le plus grand de 3 nombres */

max3(X,Y,Z,M) :-
	max2(X,Y,MM),  % Calculer le max entre X et Y
	max2(MM,Z,M).  % puis comparer ce max avec Z
	
	
/* Ecrire N fois 'Bonjour !' */

bonjour(0).
bonjour(N) :-
	N>0,
	write('Bonjour ! '),
	N_1 is N - 1,
	bonjour(N_1).
	
/* Afficher les N premiers entiers : de N à 1 */
decroissant(0).
decroissant(N) :- 
	N>0, 
	write(N), nl, 
	N1 is N-1, 
	decroissant(N1).

/* de 1 à N */
croissant(0).
croissant(N) :- 
	N>0, 
	N1 is N-1, 
	croissant(N1), 
	write(N), nl.   % N n'est affiché qu'après la réussite des 
					% appels récursifs sur les autres entiers inférieurs.

/* pair(N) est vrai si N est pair.  */

pair(0).
pair(N) :- N > 0, M is N-2, pair(M).

/* Variante de paraisseux ! On teste si le reste de la division euclidienne par 2 est zéro. */

pair2(N) :- 0 is N mod 2.

/* Somme des N premiers entiers. (som(N,X) est vrai si X est la somme des entiers de 1 à N.) */

som(0,0).
som(N,X) :- N>0, N1 is N-1, som(N1,X1), X is N+X1.

/* Factorielle d'un nombre. (fact(N,X) est vrai si X vaut N!.) */

fact(0,1).
fact(N,X) :- N>0, N1 is N-1, fact(N1,X1), X is N*X1.

/* fibo(N,X) est vrai si X est la valeur de la suite de Fibonacci au rang N. */

fibo(1,1).
fibo(2,1).
fibo(N,X) :- 
	N>2, 
	U is N-1, 
	V is N-2, 
	fibo(U,U1), fibo(V,V1),
	X is U1+V1.


/* Calcul de C(n,p)  (sans utiliser la formule avec la factorielle) */

coeff(_,0,1).
coeff(P,P,1).
coeff(N,P,C) :- 
	N>P, 
	P>0, 
	N>0, 
	N1 is N-1, 
	P1 is P-1,
	coeff(N1,P1,C1),
	coeff(N1,P,C2),
    C is C1+C2.
