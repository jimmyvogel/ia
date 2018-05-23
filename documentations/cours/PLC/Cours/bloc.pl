bloc(a).
bloc(b).
bloc(c).
place(p).
place(q).
place(r).
init([sur(a,b), sur(b,p), sur(c,r)]).

etat_final([sur(a,b), sur(b,c), sur(c,r)].

test_plan(P):-
	etat_init(E1),
	etat_final(E2),
	transforme(E1,E2,P).
	
transforme(E1,E2, P):- 
	chercher(E1, E2, [E1], P), 
	!.

chercher(E1, E2, , []) :- 
	meme_elts(E1,E2).
	
chercher(E1, E2, V, [A|P]) :-
	choisir_action(E1, A),
	mettre_a_jour(A,E1,E3),
	non_visite(E3,V),
	chercher(E3, E2, [E1|V], P).
	
choisir_action(Etat, placer_sur_place(B,Y,P)):-
	est_sur(B,Y,Etat),	
	libre(B, Etat),
	place(P),
	libre(P,Etat).
	
choisir_action(Etat, Placer_sur_bloc(B1, Y, B2)):-
	est_sur(B1, Y, Etat),
	libre(B1, Etat),
	bloc(B2),
	libre(B2, Etat),
	B1 \== B2.
	
est_sur(B,Y,E):-
	member(sur(B,Y), E).
	
libre(_,[]) .

libre(X, [sur(Y,Z)|E]):- 
	X\==Z, 
	libre(X,E).
	
non_visite(_, []).

non_visite(X,[Y|L]):- 
	\+ meme_elts(X,Y), 
	non_visite(X,L).
	
meme_elts(X,Y):-
	inclus(X,Y),
	incluse(Y,X).
	
inclus([],_).

inclus([X|L1], L2):-
	member(X,L2),
	inclus(L1, L2).
	
mettre_a_jour(placer_sur_place(X,Y,Z), E1, E2):-
	substituer(sur(X,Y), sur(X,Z), E1, E2).
	
mettre_a_jour(placer_sur_place(X,Y,Z), E1, E2):-
	substituer(sur(X,Y), sur(X,Z), E1, E2
	
substituer(_,_,[], []).

substituer(sur(X,Y), sur(X,Z), [sur(X,Y)|E], [sur(X,Z)|E]):-
	!.
	
substituer(sur(X,Y), sur(X,Z), [T|E1], [T|E2]):-
	substituer(sur(X,Y), sur(X,Z), E1, E2).