start_state([0,0]).
goal_state([2,0]).

%Eb1
operator([B1,B2],[0,B2]) :-
    B1>0.

%Eb2
operator([B1,B2], [B1,0]) :-
    B2>0.

%Fb1
operator([B1,B2], [4,B2]) :-
    B1<4.

%Fb2
operator([B1, B2], [B1,3]) :-
    B2<3.

%D12_dc
operator([B1,B2],[B1_,3]) :-
    B1+B2>=3,
    B2<3,
    B1_ is B1-(3-B2).


%D12_ov
operator([B1,B2],[0,B2_]) :-
    B1+B2<3,
    B1>0,
    B2_ is B1+B2.

%D21_dc
operator([B1,B2],[4,B2_]) :-
    B1+B2>=4,
    B1<4,
    B2_ is B2-(4-B1).


%D21_ov
operator([B1,B2],[B1_,0]) :-
    B1+B2<4,
    B2>0,
    B1_ is B1+B2.


%SOLUÇÕES
/*  start_state(S), dfs(S, [], Sol).
    Sol = [[0,0], ..., [2,0]]
*/


/* Pesquisa em profundidade */
dfs(S,_,[S]) :-
    goal_state(S).

dfs(S, V, [S|R]) :-
    operator(S, S2), 
    \+member(S2, V),
    dfs(S2, [S2|V], R).


/* Pesquisa em largura */
bfs([[S|Path]|_], [S,Path]) :-
    goal_state(S).

bfs([[S|Path]|R], Sol) :-
    findall([S2|[S|Path]], operator(S, S2), LS),
    append(R, LS, L2),
    bfs(L2, Sol).

