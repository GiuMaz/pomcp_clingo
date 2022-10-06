% #include <incmode>.

#program base.

% problem entities
#const num_rocks=4.
rock(0..num_rocks-1).
ranges_dist(-25..25).
range_guess(0..100).
perc_rocks(0..100).


% context
#external guess(R,D) : rock(R), range_guess(D).
#external dist(R,D) : rock(R), ranges_dist(D).
#external min_dist(R) : rock(R).
#external worst_guess(R) : rock(R).
#external max_dist(R) : rock(R).
#external best_guess(R) : rock(R).
#external delta_x(R,D) : rock(R), ranges_dist(D).
#external delta_y(R,D) : rock(R), ranges_dist(D).
#external sampled(R) : rock(R).
#external num_sampled(R) : perc_rocks(R).


%66/1067 COUNTEREX
1{ target_sample(V1) : V2 >= 30, guess(V1, V2), min_dist(V1), not sampled(V1)}num_rocks. 
:~ target_sample(V1), min_dist(V1), guess(V1,V2), not sampled(V1).[-V2@3, V1, V2]


%1099/1877 COUNTEREX
1 {check(V1) : min_dist(V1), not sampled(V1);
check(V1) : max_dist(V1), worst_guess(V1), not sampled(V1)} num_rocks. 
:~ check(V1), best_guess(V1), not sampled(V1).[1@1, V1] 
:~ check(V1), worst_guess(V1), dist(V1,V2), not sampled(V1).[V2@3, V1, V2] 


%109/4433 COUNTEREX
exit :- num_sampled(V1); V1 >= 100.
exit :- num_sampled(V1); V1 >= 25; V2 <= 70; guess(V3, V2), not sampled(V3).


% motion
south(V1) :- V2 < 0; delta_y(V1, V2); target_sample(V1).
north(V1) :- V2 > 0; delta_y(V1, V2); target_sample(V1).
west(V1) :- V2 < 0; delta_x(V1, V2); target_sample(V1).
east(V1) :- V2 > 0; delta_x(V1, V2); target_sample(V1).


% some equivalent rules for sample action
%% Solution 1 (score 2) 
sample(V1) :- best_guess(V1), not sampled(V1).
%% Solution 2 (score 2) 
sample(V1) :- min_dist(V1), not sampled(V1).
%% Solution 3 (score 3) 
sample(V1) :- min_dist(V1); best_guess(V1), not sampled(V1).
%% Solution 4 (score 3) 
sample(V1) :- V2 <= 0; dist(V1, V2), not sampled(V1).


%Output in the answer sets
%#show target_sample/1.
#show check/1.
#show sample/1.
%#show exit.
#show south/1.
#show west/1.
#show east/1.
#show north/1.
