% #include <incmode>.



#program base.



% problem entities
#const num_levels=10.
#const max_dist=4.
level(0..num_levels).
dist(1..max_dist).
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
prob(100).

% context
#external guess(L,D) : level(L), prob(D).
#external open(D) : prob(D).
#external open_next(D) : prob(D).
#external at_station.
#external dist_station_next(D) : dist(D). %PUÒ ESSERE SIA PROSSIMA STAZIONE (NON QUELLA SU CUI SI È GIÀ), SIA IL GOAL SE NON CI SONO ALTRE STAZIONI

%NEW AXIOMS: FIXED ILASP BUG
recharge :- at_station; open(V1); V2 >= 5; V3 <= 80; V1 >= 60; guess(V2, V3). % 5340 / 29231 COUNTEREX
%check :- at_station. %16486 / 29231 COUNTEREX
advance :- V1 <= 2; dist_station_next(V1). %13896 / 29231 COUNTEREX

% #show recharge.
% #show check.
% #show advance.
