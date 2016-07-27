:- include(graph).
:- dynamic(rpath/2).

path(From, To, Dist) :- edge(To, From, Dist).
path(From, To, Dist) :- edge(From, To, Dist).

shorterPath([H|Path], Dist) :-
    (rpath([H|_], D) -> Dist < D -> retract(rpath([H|_], _)); true),
    assertz(rpath([H|Path], Dist)).

traverse(From, Path, Dist) :-
    path(From, T, D),
    \+ memberchk(T, Path),
    shorterPath([T,From|Path], Dist+D),
    traverse(T, [From|Path], Dist+D).

traverse(From) :-
    retractall(rpath(_, _)),
    traverse(From, [], 0).

traverse(_).

calc(From, To) :-
    traverse(From),
    rpath([To|RPath], Dist) ->
        reverse([To|RPath], Path),
        Distance is Dist,
        format('The shortest path is ~w with distance ~w\n', [Path, Distance]);
    format('There is no route from ~w to ~w\n', [From, To]).
