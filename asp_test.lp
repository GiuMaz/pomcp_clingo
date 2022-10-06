% #include <incmode>.



#program base.



% problem entities
rock(0..3).
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
#external best_guess(R) : rock(R).
#external delta_x(R,D) : rock(R), ranges_dist(D).
#external delta_y(R,D) : rock(R), ranges_dist(D).
% dist(0,2). 
% delta_x(0,1). delta_y(0,1).
% dist(1,8). delta_x(1,0). delta_y(1,-8). dist(2,10). delta_x(2,-2). delta_y(2,-8). dist(3,6). delta_x(3,6). delta_y(3,0). min_dist(0). guess(0,90). guess(1,20). guess(2,20). guess(3,40). best_guess(0).

% rules
1 {target_sample(V1) } 1 :- V2 <= 1; V2 >= 1; dist(V1, V2). 
1 {target_sample(V1) } 1 :- V2 <= 80; guess(V1, V2); min_dist(V1). 
1 {target_sample(V1) } 1 :- V2 <= 2; V2 >= 1; dist(V1, V2); best_guess(V1). 

south(V1) :- V2 < 0; delta_y(V1, V2); target_sample(V1).
north(V1) :- V2 > 0; delta_y(V1, V2); target_sample(V1).
1 {west(V1) } 1 :- V2 < 0; delta_x(V1, V2); target_sample(V1).
1 {east(V1) } 1 :- V2 > 0; delta_x(V1, V2); target_sample(V1).
east(V1) :- V2 > 0; delta_x(V1, V2); target_sample(V1).

%Output in the answer sets
#show target_sample/1.
#show south/1.
#show west/1.
#show east/1.
#show north/1.
