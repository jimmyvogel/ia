:- discontiguous(ancetre/2).

/* ========= 
   les faits
   ========= */

/* les hommes */
homme(andre).
homme(bernard).
homme(babar).
homme(clement).
homme(dudulle).
homme(damien).
homme(baptiste).
homme(cedric).
homme(didier).
homme(dagobert).

/* les femmes */
femme(augustine).
femme(becassine).
femme(brigitte).
femme(chantal).  % Ma nounou !
femme(celestine).
femme(caroline).
femme(charlotte).
femme(daniela).
femme(dominique).

/* les relations de parenté */
enfant(bernard,andre).
enfant(bernard,augustine).
enfant(babar,andre).
enfant(babar,augustine).
enfant(brigitte,andre).
enfant(brigitte,augustine).
enfant(clement,bernard).
enfant(clement,becassine).
enfant(celestine,bernard).
enfant(celestine,becassine).
enfant(caroline,brigitte).
enfant(caroline,baptiste).
enfant(cedric,brigitte).
enfant(cedric,baptiste).
enfant(dudulle,clement).
enfant(dudulle,chantal).
enfant(damien,clement).
enfant(damien,chantal).
enfant(daniela,clement).
enfant(daniela,chantal).
enfant(didier,cedric).
enfant(didier,charlotte).
enfant(dagobert,cedric).
enfant(dagobert,charlotte).
enfant(dominique,cedric).
enfant(dominique,charlotte).

/* données générales (règles) */

parent(Y,X) :- enfant(X,Y).

ancetre(X,Y) :- parent(X,Y).

pere(X,Y) :- parent(X,Y),homme(X).
mere(X,Y) :- parent(X,Y),femme(X).

fils(X,Y) :- enfant(X,Y),homme(X).
fille(X,Y) :- enfant(X,Y),femme(X).

grand_parent(X,Y) :- parent(X,Z),parent(Z,Y).
grand_pere(X,Y) :- grand_parent(X,Y),homme(X).
grand_mere(X,Y) :- grand_parent(X,Y),femme(X).

petit_enfant(X,Y) :- grand_parent(Y,X).
petit_fils(X,Y) :-  petit_enfant(X,Y),homme(X).
petite_fille(X,Y) :-  petit_enfant(X,Y),femme(X).

frere_ou_soeur(X,Y) :- pere(P,X),pere(P,Y),mere(M,X),mere(M,Y),X\==Y.
frere(X,Y) :- frere_ou_soeur(X,Y),homme(X).
soeur(X,Y) :- frere_ou_soeur(X,Y),femme(X).

oncle_ou_tante(X,Y) :- parent(Z,Y),frere_ou_soeur(X,Z).
oncle(X,Y) :- oncle_ou_tante(X,Y),homme(X).
tante(X,Y) :- oncle_ou_tante(X,Y),femme(X).

cousin_ou_cousine(X,Y) :- oncle_ou_tante(Z,X),enfant(Y,Z).
cousin(X,Y) :- cousin_ou_cousine(X,Y),homme(X).
cousine(X,Y) :- cousin_ou_cousine(X,Y),femme(X).

ancetre(X,Y) :- parent(X,Z),ancetre(Z,Y).


/*                            TD5                                            */
/* pour rajouter un autre fichier, on peut aussi rajouter en entête: :- include('extension.pl').    */

analyse(L) :- etat1(L).

etat1([qui,est|L]):-etat3(L).

etat3([le|L]):-etat4(L).
etat3([l|L]):-etat5(L).
etat3([la|L]):-etat10(L).

etat4([frere|L]):-etat6(L).
etat4([neveu|L]):-etat6(L).

etat5([oncle|L]):-etat6(L).
etat5([ancetre|L]):-etat6(L).

etat6([du|L]):- etat4(L).
etat6([d,andre]).
etat6([de|L]):- etat8(L).

etat8([bernard]).
etat8([babar]).
etat8([caroline]).
etat8([l|L]):- etat5(L).
etat8([la|L]):- etat10(L).

etat10([mere|L]):- etat6(L).
etat10([soeur|L]):- etat6(L).



/*Les mots acceptés sont :      andre bernard caroline babar
				mère soeur neveu frère ancetre oncle
			 */
motVide(qui).
motVide(est).
motVide(le).
motVide(l).
motVide(la).
motVide(de).
motVide(du).

/* */

nettoie([],[]).
nettoie([X|L], L2):- motVide(X), nettoie(L,L2).
nettoie([X|L], [X|L2]):- \+ motVide(X), nettoie(L,L2).


/* */

reponse([Predicat,Individu],X):- T =.. [Predicat, X, Individu], call(T).
reponse([Predicat|L],X):- 
	reponse(L, I), 
	reponse([Predicat, I],X).
	
question(L):- 
	nettoie(L,Q),
	setof(X,reponse(Q,X),L2),
	affiche_reponse(L2).
