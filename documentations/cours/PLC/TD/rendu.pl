/*
Question 1: Ecrire un prédicat est_un_polynome(P) qui est vrai si la liste P représent bien un polynôme
*/

est_un_polynome([]).
est_un_polynome([(X, Y)|Z]):-
	Y >= 0, 
	est_un_polynome(Z).
	

/*
Question 2
*/

remove([],_,[]).
remove([A|B], A, L]):- remove(B, A, L).
remove([C|B], A, [C|L]):- C \= A, remove(B,A,L). 

trier([], L2).
trier(L1, L2):-
	maxList(L1, E),
	append(E, L2),
	remove(E, L1),
	trier(L1, L2).
	

/*
Question 3
*/

simplifier(P1, P2):- 
	trier(P1),
	simplifier2(P1, P2).
	
simplifier2([(A,B),(A2,B)|Y], [(C,B)|Y]):-
	C = A + A2 + simplifier2([

/*
Question 4
*/
somme(P1, P2, S):-
	simplifier(P1, P3),
	simplifier(P2, P4),
	somme2(P2, P4, S).

somme2([],[], []).
somme2([],L, L).
somme2(L,[], L).

somme2([(A,B)|Y],[(C,B)|Q], [(D,B)|Z]):-
	D = A + C,
	somme2(Y, Q, Z).

somme2([(A,B)|Y],[(C,E)|Q], [(A,B)|Z]):-
	B \= E,
	B > E, 
	somme2(Y, [(C,E)|Q], Z).

somme2([(A,B)|Y],[(C,E)|Q], [(C,E)|Z]):-
	B \= E,
	B < E,
	somme2([(A,B)|Y], Q, Z).

/*
Question 5 
*/
evaluer(P,X,V):-
	simplifier(P),
	evaluer2(P,X,V).
evaluer2([],_,0).
evaluer2([(A,B)|Y],X,V):-
	pow(A,B,Res),
	evaluer2(Y,X,V2).	
	V is Res * X + V2.
