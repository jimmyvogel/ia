% somme_GN(X, Y, S) : S (liste de chiffres) est unifiée avec la somme des "nombres" X, Y représentés par des chaînes de caractères composées de leurs chiffres :
%  somme_GN("1456789487565437654", "5482111010302549", S) : unifie S à [1,4,6,2,2,7,1,5,9,8,5,7,5,7,4,0,2,0,3]
somme_GN(X, Y, S) :-
	appliquer(code2digit, X, X1),
	appliquer(code2digit, Y, Y1),
	somme(X1, Y1, S).

% somme(X, Y, S) : S est unifié avec la somme des "nombres" X, Y représentés par la liste des chiffres (dans l'ordre) qui les composent. 
somme(X, Y, S) :-
	reverse(X, X1),
	reverse(Y, Y1),
	somme_inv(X1, Y1, 0, S1),
	reverse(S1, S).
	
% Algorithme de somme classique qui commence pas les unités (liste inversée)
somme_inv([X|L], [Y|M], R, [Z|N]) :-
	Z is (X+Y+R) mod 10,
	R1 is (X+Y+R) // 10,
	somme_inv(L, M, R1, N).

% Qd une liste se termine avec une retenue 0, la somme de cette liste et de la liste restante est cette liste restante.
somme_inv([], Y, 0, Y).
somme_inv(X, [], 0, X).

% Qd une liste se termine avec une retenue 1, on remet cette retenue dans la liste qui s'est terminée et on relance la somme.
somme_inv([], Y, 1, S) :-
	somme_inv([1], Y, 0, S).
somme_inv(X, [], 1, S) :-
	somme_inv(X, [1], 0, S).

% LA DIFFÉNCE SE FAIT SUR LE MÊME PRINCIPE QUE LA SOMME.

% LA COMPARAISON PEUT SE FAIRE SIMPLEMENT EN REGARDANT SI LE PRÉDICAT DIFFÉRENCE RÉUSSIT OU ECHOUE!!

% mult_GN(X, Y, M) : M (liste de chiffres) unifiée avec le produit des "nombres" X et Y représentés par des chaînes de caractères composées de leurs chiffres.
mult_GN(X, Y, S) :-
	appliquer(code2digit, X, X1),
	appliquer(code2digit, Y, Y1),
	mult(X1, Y1, S).
	
% somme(X, Y, M) : M est unifié avec la somme des "nombres" X, Y représentés par la liste des chiffres (dans l'ordre) qui les composent. 
mult(X, Y, M) :-
	reverse(X, X1),
	reverse(Y, Y1),
	mult_inv(X1, Y1, M1),
	reverse(M1, M2),
	retirer_zeros_non_significatifs(M2, M).

% Algorithme de produit classique qui commence pas les unités (liste inversée) et multiplie successivement les chiffres du second nombre par le premier.
mult_inv(_, [], [0]).
mult_inv(X, [Y|L], M) :-
	mult_scalaire(X, Y, 0, XY),
	mult_inv(X, L, M1),
	somme_inv(XY, [0|M1], 0, M).

% Algorithme de produit classique qui multiplie successivement les chiffres du second paramètre (liste de chiffre) par le premier (chiffre).
mult_scalaire([], _, R, [R]).
mult_scalaire([X|L], Y, R, [Z|M]) :-
	Z is (X*Y + R) mod 10,
	R1 is (X*Y + R) // 10,
	mult_scalaire(L, Y, R1, M).

% Retirer les éventuels zéros (non significatifs) en tête de la liste.
retirer_zeros_non_significatifs([0, X|L], M) :-
	!,
	retirer_zeros_non_significatifs([X|L], M).
	retirer_zeros_non_significatifs(L, L).

% appliquer(P, L1, L2) : Appliquer le prédicat P sur tous les éléments de la liste L1 et unifier les résultats avec les éléments de la liste L2.
appliquer(_, [], []).
appliquer(P, [E|L], [E1|L1]) :-
	Pred =.. [P, E, E1],  	% Unifie Pred avec le terme P(E, E1)
	call(Pred),				% Résoudre le but P(E, E1)
	appliquer(P, L, L1).
	
% code2digit(+Code, Chiffre) : Vrai si Chiffre s'unifie avec le chiffre dont le code est Code. Par exemple : code2digit(54, 6) est vrai.
code2digit(Code, Chiffre) :- 
	48 =< Code, Code =< 57, 
	char_code('0', CodeZero),
	Chiffre is Code - CodeZero.

% digit2code(+Chiffre, Code) : Vrai si Code s'unifie avec le code du chiffre Chiffre . Par exemple : digit2code(6, 54) est vrai.
digit2code(Chiffre, Code) :- 
	0 =< Chiffre, Chiffre =< 9, 
	char_code('0', CodeZero),
	Code is CodeZero + Chiffre.

