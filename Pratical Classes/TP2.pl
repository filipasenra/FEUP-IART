start_state([0,0]).
goal_state([2,0]).

/* With Cost */

%Eb1
operator([B1,B2],[0,B2], C) :-
    B1>0,
    C is B1.

%Eb2
operator([B1,B2], [B1,0], C) :-
    B2>0,
    C is B2.

%Fb1
operator([B1,B2], [4,B2], C) :-
    B1<4,
    C is 4-B1.

%Fb2
operator([B1, B2], [B1,3], C) :-
    B2<3,
    C is 3-B2.

%D12_dc
operator([B1,B2],[B1_,3], C) :-
    B1+B2>=3,
    B2<3,
    B1_ is B1-(3-B2),
    C is B1-B1_.


%D12_ov
operator([B1,B2],[0,B2_], C) :-
    B1+B2<3,
    B1>0,
    B2_ is B1+B2, 
    C is B1.

%D21_dc
operator([B1,B2],[4,B2_], C) :-
    B1+B2>=4,
    B1<4,
    B2_ is B2-(4-B1),
    C is B2-B2_.


%D21_ov
operator([B1,B2],[B1_,0], C) :-
    B1+B2<4,
    B2>0,
    B1_ is B1+B2,
    C is B2.

h([B1,B2], H):-
  goal_state([B1f,B2f]),
  H is max(abs(B1-B1f),abs(B2-B2f)).

%SOLUÇÕES

/* A* 
start_state(Ei), h(Ei, Hi), astar([(Hi, Hi, 0, [Ei])], Sol).

We don't need to save the H argument because it is not cumultative 
*/

astar([(_, _, _, [E | Cam]) | _], [E | Cam]) :-
    goal_state(E).

astar([(_, _, G, [E | Cam]) | R], Sol) :-
    findall((F2, H2, G2, [E2 | [E | Cam]]), 
    (operator(E, E2, C), h(E2, H2), G2 is G + C, F2 is G2 + H2), 
    LS),

    append(R, LS, L2),
    sort(L2, L2ord),
    astar(L2ord, Sol).

/* uniform cost 
start_state(Ei), uc([(0, [Ei])], Sol). 
*/

uc([( _, [E | Cam]) | _], [E | Cam]) :-
    goal_state(E).

uc([(G, [E | Cam]) | R], Sol) :-
    findall((G2, [E2 | [E | Cam]]), 
    (operator(E, E2, C), G2 is G + C), 
    LS),

    append(R, LS, L2),
    sort(L2, L2ord),
    uc(L2ord, Sol).

/* Greedy 
start_state(Ei), h(Ei, Hi), greedy([(Hi, 0, [Ei])], Sol).

To not go into cycles add\ \+ member
*/
greedy([(_, _, [E | Cam]) | _], [E | Cam]) :-
    goal_state(E).

greedy([(_, G, [E | Cam]) | R], Sol) :-
    findall((H2, G2, [E2 | [E | Cam]]), 
    (operator(E, E2, C), \+ member(E2, [E | Cam]), h(E2, H2), G2 is G + C), 
    LS),

    append(R, LS, L2),
    sort(L2, L2ord),
    greedy(L2ord, Sol).