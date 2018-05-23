/*   1)Jean a 10 ans de plus que Jeanne, mais dans 5 ans, il aura le double de son age. Quels ages ont-ils
tous les deux ?
*/

pb1(Jean,Jeanne):- 
	fd_domain([Jean, Jeanne], 1, 200), 
	Jean #= Jeanne+10,
	Jean +5 #= 2*(Jeanne+5), 
	fd_labeling([Jean, Jeanne]).

/*2. Papa et maman ont le meme age, ils ont 3 enfants dont deux jumeaux. Ils ont le triple de l’age
des jumeaux, le produit de leur age est egal au produit des ages de leurs enfants, et si les enfants
avaient un an de plus, le double de la somme de leur age donnerait la meme chose que la somme
des ages de papa et maman il y a un an. Quel est l’age de chacun ?
*/
pb2(Parent, Jumeau, Autre):-
	fd_domain([Parent, Jumeau, Autre], 1, 200),
	Parent #= Jumeau*3, 
	(Parent*Parent) #= (Jumeau*Jumeau*Autre),
	2*((Jumeau+1)*2+(Autre+1)) #= (Parent-1)*2,
	fd_labeling([Parent, Jumeau, Autre]).

/*
3. Trouver une affectation des chiffres a des lettres telle que SEND + MORE = MONEY. Les lettres
differentes recoivent des chiffrens differents et S et M sont differents de zero.
	S E N D
      + M O R E
    = M O N E Y
*/
pb3(S,E,N,D,M,O,R,Y):-
	fd_domain([S,E,N,D,M,O,R,Y], 0, 9),
	fd_all_different([S,E,N,D,M,O,R,Y]),
	S #\= 0,
	M #\= 0,
	(S+M)*1000+(E+O)*100+(N+R)*10+D+E #= M*10000 + O*1000 + N*100 + E*10 + Y,
	fd_labeling([S,E,N,D,M,O,R,Y]).
	

/*
4. Le cinquieme d’un essain d’abeilles se dirige vers un massif de roses, un tiers vers les lilas, un
nombre egal a trois fois la difference entre les deux groupes precedents vers les lys. La seule
abeille restante fonce sur la rhododendrons. Ecrire l’equation permettant de savoir combien il y
avait d’abeilles dans l’essaim initial.
*/
pb4(Total, Roses, Lilas, Lys):-
	fd_domain([Total, Roses, Lilas, Lys], 1, 1000),
	Total #= 5*Roses,
	Total #= 3*Lilas,
	Lys #= 3*(Lilas-Roses),
	Total #= Roses+Lilas+Lys+1,
	fd_labeling([Total,Roses,Lilas,Lys]).

/*
5. Ecrire les contraintes pour resoudre l’equation : un ordre inconnu tous les chiffres de 1 a 9.
	A/BC+D/EF+G/HI= 1 ou les lettres representent dans
*/
pb5(A,B,C,D,E,F,G,H,I):-
	fd_domain([A,B,C,D,E,F,G,H,I], 1, 9),
	fd_domain([BC,EF,HI], 10, 98),
	fd_domain([Diviseur], 0, 405000),
	fd_all_different([A,B,C,D,E,F,G,H,I]),
	BC #= B*10+C,
	EF #= E*10+F,
	HI #= H*10+I,
	Diviseur #= BC * EF * HI,
	A*EF*HI+D*BC*HI+G*BC*EF #= Diviseur,
	fd_labeling([A,B,C,D,E,F,G,H,I]). 

/*
6. Une entreprise fabrique trois types de voitures : A, B et C. Le cout de production de ces voitures
et le profit obtenu sont differents pour chaque type. Ils sont donnees dans le tableau suivant (les
chiffres sont en milliers d’euros et n le nombre de voitures produites) :
Voiture 

 	Cout n = 1 	Cout n = 2 	Cout n = 3 	Cout n > 3 	Profit 
A 	10 		7 		5 		3 		6
B 	8 		6		4 		3 		4
C 	6 		5	 	4 		2	 	5

Pour le meme type de voiture, le cout de production est plus eleve pour les trois premieres voitures
produites. Par exemple, fabriquer trois voitures de type A coute 10+7+5=22 tandis que fabriquer
quatre voitures de ce type coute 25. Le profit par voiture produite est par contre independant du
nombre de voitures, par exemple avec 5 voitures de type B, on fait un profit de 20.
L’entreprise doit fabriquer au moins une voiture de chaque type et a 50 a investir dans la produc-
tion. Elle souhaite maximiser son profit.
Ecrivez un programme avec des contraintes pour resoudre ce probleme.
*/

coutA(1, 10).
coutA(2, 17).
coutA(A, Resultat):- A>3, Resultat is (A-3)*3+10+7;


pb6(Maximiser, A, B, C):-
	fd_domain([A,B,C], 1, 50),
	fd_domain([Maximiser], 300),
	
	Maximiser = A*6 + B*4 + C*5,
	fd_maximize(pb6, Maximiser),
	fd_labeling([Maximiser,A,B,C]).
	

