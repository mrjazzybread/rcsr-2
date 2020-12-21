slot(D, M) :- slots(D, M).
%Se o dia D tem M slots então o Slot M do Diia D existe

slot(D, M-1) :- slot(D, M), M>1.
%criação dos slots, Se o slot M existe então M-1 também existe 

overlap(C2, C1, N) :- overlap(C1, C2, N).
%Se C1 e C2 tem overlap então C2 e C1 também tem overlap

1{assign(C, D, S) : slot(D, S)}1 :- courseYear(C, _).
%One and Only one Slot should be assigned that day to that course

{courseRoom(C, R) : room(R, _)} :- courseYear(C, _).
%Aquele curso usa a sala R.

1{watcher(P, R, C) : professor(P, _) }1 :- courseRoom(C, R).
%Há um e um só watcher por sala.

:- watcher(P, _,C), professor(P, C).
%O watcher de uma sala não pode lecionar esse curso

:-watcher(P, R1, C1), watcher(P, R2, C2), assign(C1, D, S), assign(C2, D, S), C1 != C2.
%Um watcher não pode vigiar duas salas ao mesmo tempo

roomAssign(R, D, S) :- courseRoom(C, R), assign(C, D, S).
%A sala R e no dia e no slot S está a ser utilizada.

:- #sum{M, C: enrolled(C, M), assign(C, D, S)} > L, assign(_, D, S), limit(L).
%O numero de estudantes no campus não pode ultrapassar o limite

:- M > #sum{N, R : room(R, N), courseRoom(C, R)}, enrolled(C, M).
%O numero de estudantes matriculados tem que ser menor ou igual do que a capacidade total das salas reservadas.

:- #sum{N, R : room(R, N), courseRoom(C, R)} > E + N2, enrolled(C, E), room(R2, N2), courseRoom(C, R2). 
% Não pudemos alocar mais salas do que efetivamente precisamos.

:- courseRoom(C, R1), assign(C, D, S), not roomAssign(R2, D, S), room(R1, N1), room(R2, N2), N1 < N2, M!=N2, M!=#sup, M=#min{N : room(R, N), courseRoom(C, R)}.
% Descarta modelos onde usamos uma sala mais pequena quando uma maior estava disponível.-> Modelos ótimos vão cumprir a restrição.

:- assign(C, D1, _), later(C, D2), D2 >= D1. 		

:- assign(C, D1, _), earlier(C, D2), D2 <= D1. 	

:- assign(C1, D, S), courseRoom(C1, R), assign(C2, D, S), courseRoom(C2, R), C1!=C2. 
% Um curso tem que estar sozinho numa sala.

:- assign(C1, D, _), assign(C2, D, _), overlap(C1, C2, _).
%Nenhum curso deve ter mais do que um teste no mesmo dia.

:- assign(C1, D1, _), assign(C2, D2, _), courseYear(C1, Y), courseYear(C2, Y), D1 = D2+1, Y < 4, overlap(C1, C2, _). 
%Um curso não deve ter testes em dias consecutivos, excepto 4º e 5º ano.

#minimize {1 @ 1, C, R: courseRoom(C, R)}.
%Minimizar o número de salas

#minimize{N @ 2, C1, C2 : assign(C1, D1, _), assign(C2, D2, _),  overlap(C1, C2, N), D1=D2+1}.
%Minimizing the number of students that have tests on consecutive days
#show assign/3.
