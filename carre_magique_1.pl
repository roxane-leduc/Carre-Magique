%% En ligne de commande:
%% ?- [carre_magique_1].
%% ?- use_module(library(clpfd)).
%% ?- mon_carre_magique(3, X).

element_n(1,[X|_],X).
element_n(N,[_|Q],X) :- M is N-1, element_n(M,Q,X).

colonne_n(_,[],[]).
colonne_n(N,[L|R],[X|S]) :- element_n(N,L,X), colonne_n(N,R,S). 

%% Une alternative :
element_lc(Ligne, Colonne, Carre, X) :- element_n(Ligne, Carre, L), element_n(Colonne, L, X).

diag1(Carre, D1) :- diag1(1, Carre, D1).
diag1(_,[],[]).
diag1(I, [L|R], [X|D1]) :- element_n(I, L, X), Ipp is I+1, diag1(Ipp, R, D1).

dim([],0).
dim([T|_],Dim) :- length(T,Dim).

diag2(Carre,D2) :- dim(Carre,Dim), diag2(Dim,Carre,D2).
diag2(_,[],[]).
diag2(I,[L|R],[X|D2]) :- element_n(I,L,X), Imm is I-1, diag2(Imm,R,D2).

toutes_les_listes(Carre, X) :- transpose(Carre, T), diag1(Carre,D1), diag2(Carre,D2), append(Carre, [D1,D2], Y), append(Y, T, X).

magique(Carre) :- toutes_les_listes(Carre, Comp), meme_somme(Comp, _).
meme_somme([], _).
meme_somme([L|R], S) :- sum_list(L,S), meme_somme(R, S).

genere_liste(1, [1]) :- !.
genere_liste(N, [N|L]) :- Nmm is N-1, genere_liste(Nmm, L).

retire_el([], _, []).
retire_el([X|Q], X, Q) :- !.
retire_el([T|Q], X, [T|R]) :- retire_el(Q, X, R).

genere_ligne(0, ListeNbs, [], ListeNbs) :- !.
genere_ligne(N, ListeNbs, [X|R], NewListeNbs) :- member(X, ListeNbs), retire_el(ListeNbs, X, ListeNbs2),
	M is N-1, genere_ligne(M, ListeNbs2, R, NewListeNbs).

genere_carre([], _, []).
genere_carre(N, Carre) :- NN is N*N, genere_liste(NN, ListeNbs), genere_carre(ListeNbs, N, Carre).
genere_carre(ListeNbs, N, [L|S]) :- genere_ligne(N, ListeNbs, L, NewListeNbs), genere_carre(NewListeNbs, N, S).

mon_carre_magique(N,C) :- genere_carre(N,C), magique(C).
