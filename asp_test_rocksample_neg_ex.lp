% #include <incmode>.



#program base.



% problem entities
#const num_rocks=4.
rock(0..num_rocks-1).
perc_rocks(0).
perc_rocks(25).
perc_rocks(50).
perc_rocks(75).
perc_rocks(100).
ranges_dist(-25..25).
range_guess(0).
range_guess(10).
range_guess(20).
range_guess(30).
range_guess(40).
range_guess(50).
range_guess(60).
range_guess(70).
range_guess(80).
range_guess(90).
range_guess(100).

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

%dist(0,2). delta_x(0,1). delta_y(0,1). dist(1,4). delta_x(1,0). delta_y(1,4). dist(2,6). delta_x(2,-1). delta_y(2,-5). dist(3,5). delta_x(3,0). delta_y(3,5). min_dist(0). max_dist(2). guess(0,50). guess(1,50). guess(2,40). guess(3,50). best_guess(0). best_guess(1). best_guess(3). worst_guess(2). num_sampled(0).

%TOTAL EXAMPLES 15468; COUNTEREXAMPLES 3468
0{check(V1) : V2 <= 80, V3 <= 0, dist(V1, V3), guess(V1, V2), not sampled(V1); 
check(V1) : V2 <= 50, V3 <= 2, dist(V1, V3), guess(V1, V2), best_guess(V1), not sampled(V1)}num_rocks.
:~ dist(V1,V2), check(V1), not sampled(V1).[-V2@1, V1, V2] 
:~ min_dist(V1), guess(V1,V2), check(V1), not sampled(V1).[-V2@3, V1, V2] 

%TOTAL EXAMPLES 15468; COUNTEREXAMPLES 76
sample(V1) :- V2 >= 90; V3 <= 0; target_sample(V1); dist(V1, V3); guess(V1, V2); not sampled(V1).

%TOTAL EXAMPLES 3266; COUNTEREXAMPLES 270
1{target_sample(V1) : min_dist(V1), best_guess(V1), not sampled(V1)}num_rocks.

%3266 TOTAL EXAMPLES, 435 COUNTEREXAMPLES
east(V1) :- V2 >= 1; target_sample(V1); delta_x(V1, V2). 
%3266 TOTAL EXAMPLES, 21 COUNTEREXAMPLES
west(V1) :- V2 <= -1; delta_x(V1, V2); target_sample(V1).
%3266 TOTAL EXAMPLES, 223 COUNTEREXAMPLES
south(V1) :- V2 <= -1; delta_y(V1, V2); target_sample(V1).
%3266 TOTAL EXAMPLES, 261 COUNTEREXAMPLES
north(V1) :- V2 >= 1; target_sample(V1); delta_y(V1, V2). 

%15648 TOTAL EXAMPLES, 4352 COUNTEREXAMPLES
exit :- V1 >= 6; dist(V2, V1); min_dist(V2); not sampled(V2).


%Output in the answer sets
#show sample/1.
#show check/1.
#show exit.
#show south/1.
#show west/1.
#show east/1.
#show north/1.
