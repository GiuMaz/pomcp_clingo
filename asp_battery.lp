
% #include <incmode>.



#program base.



% problem entities
#const num_levels=10.
#const max_dist=6.
level(0..num_levels).
dist(0..max_dist).
prob(0).
prob(10).
prob(20).
prob(30).
prob(40).
prob(50).
prob(60).
prob(70).
prob(80).
prob(90).

% context
#external guess(L,D) : level(L), prob(D).
#external open(D) : prob(D).
#external open_next(D) : prob(D).
#external at_station.
#external dist_station_next(D) : dist(D). %PUÒ ESSERE SIA PROSSIMA STAZIONE (NON QUELLA SU CUI SI È GIÀ), SIA IL GOAL SE NON CI SONO ALTRE STAZIONI

%NEW AXIOMS: FIXED ILASP BUG
recharge :- V2 <= 6; V1 <= 60; guess(V2, V1); at_station. % 1894 / 19009 COUNTEREX
check :- V1 >= 5; dist_station_next(V1). %7997 / 19009 COUNTEREX
advance :- V2 <= 8; V1 >= 70; guess(V2, V1). %8734 / 19009 COUNTEREX

% #show recharge.
% #show check.
% #show advance.
