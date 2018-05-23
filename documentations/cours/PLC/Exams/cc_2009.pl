%cc_2009

%exo1
%dernier([X],X).
%dernier([_|L],X) :- dernier(L,X).
%q2
dernier([X],X) :- !.
dernier([_|L],X) :- dernier(L,X).
%q3
ad([X,_], X) :- !.
ad([_|L], X) :- ad(L,X).
%q4
kd(K, [X|L], X):- Z is K-1, length(L, Z), !.
kd(K, [_|L], X):- kd(K, L, X).

%exo2
grandpatron(a).
employe(b). 
employe(c). 
employe(d). 
employe(e).
employe(f).
superieurdirect(a,b).
superieurdirect(b,c).
superieurdirect(b,d).
superieurdirect(c,e).
superieurdirect(e,f). 
%q1
rang(X,1):-grandpatron(X).
rang(X,N):- 
	employe(X),
	superieurdirect(S,X),
	rang(S,Z),
	N is Z+1.
%q2
hierarchie_ok(_):- 
	findall(Y,superieurdirect(X,Y),S1),
	setof(Y,[X]^superieurdirect(X,Y),S2),
	S1=S2.
%q3
unsuperieur(E,S):- superieurdirect(S,E),!.
unsuperieur(E,S):- superieurdirect(Y,E), unsuperieur(Y,S).
%q4
unehierarchie([_]).
unehierarchie([X,Y|L]):- superieurdirect(X,Y), unehierarchie([Y|L]).
%q5
superieur(E,[]):- grandpatron(E),!.
superieur(E,[X|S]):- superieurdirect(X,E), superieur(X, S).
%q6
/*element(X,L) est vrai si X est élément de la liste L.*/
element(X,[X|_]).
element(X,[_|R]) :- element(X,R).
/*intersection(L1,L2,L3) est vrai si L3 est l'intersection de L1 et L2.*/
intersection([],_,[]).
intersection([X|L1],L2,[X|L3]):- element(X,L2), intersection(L1,L2,L3),!.
intersection([_|L1],L2,L3):- intersection(L1,L2,L3).

listesuperieurs([],_).
listesuperieurs([X|L1],L2):-
	employe(X), 		% x est un employé.
	superieur(X,S1),	% S1 la liste des supérieurs de x.
	listesuperieurs(L1,S2), % intuitif, à faire sans comprendre :p
	intersection(S1,S2,L2). % on fait l intersection entre tous les résultats.

%exo3Matrices
%q1
matrice([],0,_).
matrice([L|L1],N,M):- 
	length(L,M),
	matrice(L1,Z,M),
	N is Z+1.
%q2
somL([],[],[]).
somL([X|L1],[Y|L2],[Z|L3]):- Z is X+Y, somL(L1,L2,L3).

somMat([],[],[]).
somMat([X|L1],[Y|L2],[Z|L3]):- somL(X,Y,Z), somMat(L1,L2,L3).

%q3
prodL(_,[],[]).
prodL(X,[Y|L2],[Z|L3]):- 
	Z is X*Y, 
	prodL(X,L2,L3).
prodConst(_,[],[]).
prodConst(X,[L1|L2],[S1|S2]):- 
	prodL(X,L1, S1),
	prodConst(X,L2,S2).


