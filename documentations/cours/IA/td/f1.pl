/* Exo 1  */

/* Question 1 
Donner les actions effectués suite aux séquences perceptives suivantes: 
[A,Sale] <= Aspirer
[A,Propre] <= Droite
[B,Sale] <= Aspirer
[A,Propre] <= gauche
*/

/* Question 2
Montrer que la fonction est rationnelle:
PEAS:
	P:
	- capteurs donnent perceptions correctes
	- pas de connaissance sur le coût des actions
	- Des actions ont un effet
	E:
	- 2 cases A, B, A à gauche de B, communicantes.
	- cases à 2 états : sale, propre.
	A:
	- Asp, Gauche, Droite, No_op.
	S:
	- 2 capteurs: saleté, position.

*/

/*Question 3:*/
action_reflex(_, sale, Action):- Action = aspirer, !.
action_reflex(a, propre, Action):- Action = droite, !.
action_reflex(b, propre, Action):- Action = gauche.

/* Etat final */
agent_reflexe_sup(_, _, propre, propre, _):-!.

/* On est sur a */
agent_reflexe_sup(Nbr_actions, a, Sale, Sale2, [X|L]):-
	action_reflex(a, Sale, X),
	(	(X==aspirer, 
		 agent_reflexe_sup(Nbr_actions, a, propre, Sale2, L)
		 )
		 ;
		(X==droite, 
		 agent_reflexe_sup(Nbr_actions, b, Sale, Sale2, L)
		 )
	).

/* On est sur b */	
agent_reflexe_sup(Nbr_actions, b, Sale, Sale2, [X|L]):-
	action_reflex(b, Sale2, X),
	(	(X==aspirer, 
		 agent_reflexe_sup(Nbr_actions, b, Sale, propre, L)
		)
		;
		(X\=aspirer, 
		agent_reflexe_sup(Nbr_actions, a, Sale, Sale2, L)
		)
	).
	
/* Fonction agent */
agent_reflexe(Position, Sale, Sale2, L):-
	agent_reflexe_sup(0, Position, Sale, Sale2, L),
	affiche(L).
	
affiche([]).	
affiche([X|L]):- write('['), write(X), write(']'), affiche(L).
