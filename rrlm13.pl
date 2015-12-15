sat(Expression) :-
  assignments_start,
  get_time(Start),
  sat_csf(Expression, _, Answer),
  get_time(End),
  Total is (End - Start) / 100.0,
  assignments(N),
  write('Tempo de execucao = '),
  write(Total),
  write(' segundo(s).\nInstanciacoes = '),
  write(N),
  write('.\n'),
  write(Answer),
  write('\n').

assignments_start :-
  retractall(assignments(_)),
  assertz(assignments(0)).

assignments_increase :-
  assignments(N),
  retractall(assignments(_)),
  N2 is N + 1,
  assertz(assignments(N2)).

sat_csf(Expression, Variables, "Sat") :-
  split_string(Expression, "&", " ", L),
  process_terms(L, Variables).

sat_csf(_, _, "Unsat").

process_terms([], _).

process_terms([String | Tail], Variables) :-
  string_to_list(String, L),
  evaluate_term(L, Variables),
  process_terms(Tail, Variables).

evaluate_term([Character | Tail], Variables) :-
  Character is 40,
  string_to_list(String, Tail),
  split_string(String, "#", ") ", L),
  evaluate_unions(L, Variables).

evaluate_term([X, Atom | Tail], Variables) :-
  X is 120,
  Atom > 47,
  Atom < 58,
  get_atom_index([Atom | Tail], Index, _),
  nth0(Index, Variables, true),
  assignments_increase.

evaluate_term([Not, X, Atom | Tail], Variables) :-
  Not is 126,
  X is 120,
  Atom > 47,
  Atom < 58,
  get_atom_index([Atom | Tail], Index, _),
  nth0(Index, Variables, false),
  assignments_increase.

get_atom_index([], Index, Base) :-
  Index is 0, Base is 1.

get_atom_index([Atom | Tail], Index, Base) :-
  Atom > 47,
  Atom < 58,
  get_atom_index(Tail, Index2, Base2),
  Index is Index2 + (Atom - 48) * Base2,
  Base is Base2 * 10.

evaluate_unions([], _) :-
  fail.

evaluate_unions([_ | Tail], Variables) :-
  evaluate_unions(Tail, Variables).

evaluate_unions([String | _], Variables) :-
  string_to_list(String, L),
  evaluate_term(L, Variables), !.
