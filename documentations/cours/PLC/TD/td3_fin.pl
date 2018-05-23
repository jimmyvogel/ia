% aplatir d'un niveau une liste %

aplatir([],[]).
aplatir([L|LL], L1) :- aplatir(LL,L2), append(L,L2,L1).

% +

plus(X,Y,Z):- T=.. ['+', X, Y], Z is T.
mult(X,Y,Z):- Z is X*Y.


%  ?- appliquer(plus, [1,2,5,8,9,123], R). doesn't work because appliquer doesn't exist.
% so we have to do that : using univ (T=.. for using a fonction which we don't know yet.
appliquer(_, [],[]).
appliquer(Fonction, [A,B|Y], [C|Z]):-
	T=.. [Fonction, A, B], C is T, appliquer(Fonction, Y, Z).
	
% current_op(X,Y,'+'). to know information about a method;

%  comment faire pour appeler ce prédicat avec appliquer('+', [1,2,3,4,5,6], L).

p(1,3,5).
p(2,4,1).
p(3,5,2).
p(4,3,1).
p(5,2,4).
% resultat de bagof(Z, p(X,Y,Z),Sac). => X=1, Y=3, Sac = [5]
% il suffit de faire bagof(Z,p(_,_,Z),Sac).
% ou
% bagof(Z,(X,Y)^p(X,Y,Z),L). pour avoir aussi la liste entière.
% resultat de bagof(Z, (p(X,Y,Z),Z>6), Sac). => false;
% il suffit de faire findall(Z, (p(X,Y,Z),Z>6), Sac

dynamic(table/1).
resoudre(T,But):-
	call(But),
	asserta(table(T)),
	fail.
my_findall(T,But,table[X]):-
	call(resoudre(T,But)).
	
dynamic(table/1).


Table(0,1).
Table(1,1)
fibo(N,F):- table(N,F), !.
fibo(N,F):- N1 is N-1, N2 is N-2, fibo(N1,F1),fibo(N2,F2), F is F1 + F2, asserta(table(N,F)).

resoudre(T,But):-
	call(But),
	asserta(T),
	fail.


%3) Negation par l'échec \+

q(2).
r(3).
p(X):- q(X), \+ r(X).


/* Voir la feuille pour tous les predicats. arbre de recherche de p(a) :
		p(a):- q(a), \+ r(a). true;
				  |  
			      v
                \+ r(a) <- true;
				  |
				  v
				\+ (w(a), \+ s(a)) <- true;
					|
					v
					\+s(a)
						|
						v
						false;
				
		p(b):- q(b), \+ r(b). false
				   |
				   v
				  \+ r(b) false
				   |
			       v
				  \+ (w(b), \+ s(b)) false
						|
						v
						true
*/


