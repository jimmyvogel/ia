    p(X,Y) :- q(X), r(X,Y).
    p(d,d1).

    q(a). q(b). q(c).

    r(b,b1). r(c,c1). r(a,a1). r(a,a2). r(a,a3).
	
	
	/*
	Solutions du but : p(X,Y).
	*/
	
    p1(X,Y) :- q(X), r(X,Y), !. /* même question sur le but : p1(X,Y). */
    p2(X,Y) :- q(X), !, r(X,Y). /* même question sur le but : p2(X,Y). */
    p3(X,Y) :- !, q(X), r(X,Y). 
    p3(d,d1).					/* même question sur le but : p3(X,Y). */
    
