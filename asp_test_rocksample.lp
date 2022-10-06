% #include <incmode>.



#program base.



% problem entities
#const num_rocks=4.
rock(0..num_rocks-1).
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
#external num_sampled(R) : rock(R).

%81/1294
1{target_sample(V1) : V2 >= 90, guess(V1, V2), not sampled(V1); 
target_sample(V1) : V2 >= 30, guess(V1, V2), min_dist(V1), not sampled(V1)}num_rocks. 
%:~ target_sample(V1), min_dist(V1), guess(V1,V2), not sampled(V1).[-V2@3, V1, V2]

%1108/1877
1 {check(V1) : min_dist(V1), not sampled(V1);
check(V1) : max_dist(V1), worst_guess(V1), not sampled(V1)} num_rocks. 
%:~ check(V1), best_guess(V1), not sampled(V1).[1@2, V1] 
%:~ check(V1), dist(V1,V2), not sampled(V1).[V2@3, V1, V2] 
%:~ check(V1), guess(V1,V2), not sampled(V1).[-V2@1, V1, V2] 

%4372/9431
exit :- num_sampled(V1); V1 >= 4.
exit :- num_sampled(V1); V1 >= 3; V2 <= 70; guess(V3, V2); not sampled(V3).

%Output in the answer sets
#show target_sample/1.
#show check/1.
#show exit.
% #show south/1.
% #show west/1.
% #show east/1.
% #show north/1.
