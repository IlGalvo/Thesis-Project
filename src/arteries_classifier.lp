% ********** MODEL ********** %
% **KNOWLEDGE BASE ********** %
% ********** MODEL ********** %

%%% Parameters
id(ID) :- 		   in_artery(ID,_,_,_,_,_,_,_,_,_,_).
radius(1..50).
density(D) :- 	   in_artery(_,_,D,_,_,_,_,_,_,_,_).
quality(Q) :- 	   in_artery(_,_,_,Q,_,_,_,_,_,_,_).
cog_x(X) :- 	   in_artery(_,_,_,_,X,_,_,_,_,_,_).
cog_y(Y) :- 	   in_artery(_,_,_,_,_,Y,_,_,_,_,_).
cog_z(Z) :- 	   in_artery(_,_,_,_,_,_,Z,_,_,_,_).
path_length(PL) :- in_artery(_,_,_,_,_,PL,_,_,_,_,_).
dfe(DE) :- 		   in_artery(_,_,_,_,_,_,DE,_,_,_,_).
height(H) :- 	   in_artery(_,_,_,_,_,_,_,_,_,H,_).
angle(1..360).

% List of arteries
name(celiac_trunk).
name(gastricL).
name(splenic).
name(hepatic).
name(dorsal_pancreatic).
name(sup_mesenteric).
name(renalL).
name(renalR).
name(renalL_mysterious).
name(renalR_mysterious).
name(inf_mesenteric).
name(lumbarR1).
name(lumbarL1).
name(lumbarR2).
name(lumbarL2).
name(lumbarR3).
name(lumbarL3).
name(lumbarR4).
name(lumbarL4).

% Radius -- Check if there is a more meaningful one
radius_small(R) :- radius(R), R > 0,  R <= 20.
radius_big(R) :- radius(R), R > 20.

radius_s(R) :- radius(R), R > 0,  R <= 20.
radius_m(R) :- radius(R), R > 20, R <= 30.
radius_l(R) :- radius(R), R > 30.

radius_1(R) :- radius(R), R > 0,  R <= 5.
radius_2(R) :- radius(R), R > 5,  R <= 10.
radius_3(R) :- radius(R), R > 10, R <= 15.
radius_4(R) :- radius(R), R > 15, R <= 20.
radius_5(R) :- radius(R), R > 20, R <= 25.
radius_6(R) :- radius(R), R > 25, R <= 30.
radius_7(R) :- radius(R), R > 30, R <= 35.
radius_8(R) :- radius(R), R > 35, R <= 40.
radius_9(R) :- radius(R), R > 40.

%% Angle -- 0 considered to be the left-facing direction and angle increasing clockwise (e.g., sup_mesenteric = 90, renalR = 180)
% High granularuty -- each 90 degrees
quadrant_1(A) :- angle(A), A > 0,   A <= 90.
quadrant_2(A) :- angle(A), A > 90,  A <= 180.
quadrant_3(A) :- angle(A), A > 180, A <= 270.
quadrant_4(A) :- angle(A), A > 270, A <= 360.
% High granularuty but shifted -- each 90 degrees
shiftedquadrant_1(A) :- angle(A), A > 330, A <= 360.
shiftedquadrant_1(A) :- angle(A), A > 0,   A <= 60.
shiftedquadrant_2(A) :- angle(A), A > 60,  A <= 150.
shiftedquadrant_3(A) :- angle(A), A > 150, A <= 240.
shiftedquadrant_4(A) :- angle(A), A > 240, A <= 330.
% Low granularity -- each 45 degrees
semiquadrant_1(A) :- angle(A), A > 0,   A <= 45.
semiquadrant_2(A) :- angle(A), A > 45,  A <= 90.
semiquadrant_3(A) :- angle(A), A > 90,  A <= 135.
semiquadrant_4(A) :- angle(A), A > 135, A <= 180.
semiquadrant_5(A) :- angle(A), A > 180, A <= 225.
semiquadrant_6(A) :- angle(A), A > 225, A <= 270.
semiquadrant_7(A) :- angle(A), A > 270, A <= 315.
semiquadrant_8(A) :- angle(A), A > 315, A <= 360.

% Height comparators
height_greater(H1,H2) :- H1 > H2.
height_less(H1,H2) :- H1 < H2.

% ASP helper
params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A) :- id(ID), radius(R), density(D), quality(Q),
                                          cog_x(X), cog_y(Y), cog_z(Z), path_length(PL),
                                          dfe(DE), height(H), angle(A), in_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A).

out_artery(ID,N) :- artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N), id(ID), name(N).

%%% Arteries exiting directly from (descending) Aorta.
%% Don't move, it's for parser efficiency
% artery(ID,radius,density,quality,center_of_ggravity_x,center_of_ggravity_y,center_of_ggravity_z,
%        path_legth,distance_from_extremes,heigth,angle,name).
artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = celiac_trunk, quadrant_1(A), radius_l(R), edge(aorta,ID).
									
artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = gastricL, radius_l(R).							
									
artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = splenic, radius_l(R).

artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = hepatic, radius_l(R).

artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = dorsal_pancreatic, radius_l(R).

artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = sup_mesenteric, quadrant_1(A), radius_l(R), edge(aorta,ID).	

artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = renalL, quadrant_4(A), radius_l(R), edge(aorta,ID).

artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = renalR, quadrant_2(A), radius_m(R), edge(aorta,ID).

artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = renalL_mysterious, quadrant_4(A), radius_m(R), edge(aorta,ID).

artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = renalR_mysterious, shiftedquadrant_2(A), radius_m(R), edge(aorta,ID).

artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = inf_mesenteric, quadrant_1(A), radius_l(R), edge(aorta,ID).

artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = lumbarL1, quadrant_4(A), radius_big(R), edge(aorta,ID).
									  
artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = lumbarR1, quadrant_3(A), radius_big(R), edge(aorta,ID).

artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = lumbarL2, quadrant_4(A), radius_big(R), edge(aorta,ID).

artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = lumbarR2, quadrant_3(A), radius_big(R), edge(aorta,ID).

artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = lumbarL3, quadrant_4(A), radius_big(R), edge(aorta,ID).

artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = lumbarR3, quadrant_3(A), radius_big(R), edge(aorta,ID).

artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = lumbarL4, quadrant_4(A), radius_big(R), edge(aorta,ID).

artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A), N = lumbarR4, quadrant_3(A), radius_big(R), edge(aorta,ID).

%%% confidence_rules rules
%% Don't move, it's for parser efficiency
% confidence_rules(name, ID)

%% CELIAC TRUNK
confidence_rules(N,0)  :- N = celiac_trunk, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_2(A).
confidence_rules(N,1)  :- N = celiac_trunk, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_7(R).
confidence_rules(N,2)  :- N = celiac_trunk, artery(ID1,_,_,_,_,_,_,_,_,_,_,N), artery(ID2,_,_,_,_,_,_,_,_,_,_,gastricL), edge(ID1,ID2).
%confidence_rules(N,3) :- N = celiac_trunk, artery(ID1,_,_,_,_,_,_,_,_,_,_,N), artery(ID1,_,_,_,_,_,_,_,_,_,_,splenic), edge(ID1,ID2).
%confidence_rules(N,4) :- N = celiac_trunk, artery(ID1,_,_,_,_,_,_,_,_,_,_,N), artery(ID1,_,_,_,_,_,_,_,_,_,_,hepatic), edge(ID1,ID2).
confidence_rules(N,5)  :- N = celiac_trunk, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,sup_mesenteric), height_greater(H1+10,H2).
confidence_rules(N,6)  :- N = celiac_trunk, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,sup_mesenteric), height_greater(H1,H2).
confidence_rules(N,7)  :- N = celiac_trunk, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalL), height_greater(H1,H2+10).
confidence_rules(N,8)  :- N = celiac_trunk, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalL), height_greater(H1,H2).
confidence_rules(N,9)  :- N = celiac_trunk, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalR), height_greater(H1,H2+10).
confidence_rules(N,10) :- N = celiac_trunk, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalR), height_greater(H1,H2).
confidence_rules(N,11) :- N = celiac_trunk, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,sup_mesenteric), height_greater(H1,H2+30).

%% LEFT GASTRIC
confidence_rules(N,0) :-  N = gastricL, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_7(R).
confidence_rules(N,1) :-  N = gastricL, artery(ID1,_,_,_,_,_,_,_,_,_,_,N), artery(ID2,_,_,_,_,_,_,_,_,_,_,celiac_trunk), edge(ID1,ID2).

%% SPLENIC
confidence_rules(N,0) :- N = splenic, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_7(R).
confidence_rules(N,1) :- N = splenic, artery(ID1,_,_,_,_,_,_,_,_,_,_,N), artery(ID2,_,_,_,_,_,_,_,_,_,_,celiac_trunk), edge(ID1,ID2).

%% HEPATIC
confidence_rules(N,0)  :- N = hepatic, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_7(R).
confidence_rules(N,1) :-  N = hepatic, artery(ID1,_,_,_,_,_,_,_,_,_,_,N), artery(ID2,_,_,_,_,_,_,_,_,_,_,celiac_trunk), edge(ID1,ID2).
%confidence_rules(N,1) :- N = hepatic, artery(ID2,_,_,_,_,_,_,_,_,_,_,N), artery(ID2,_,_,_,_,_,_,_,_,_,_,sup_mesenteric), edge(ID1,ID2). % gastricR ?

%% DORSAL PANCREATIC
confidence_rules(N,0) :- N = dorsal_pancreatic, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_7(R).
confidence_rules(N,1) :- N = dorsal_pancreatic, artery(ID1,_,_,_,_,_,_,_,_,_,_,N), artery(ID2,_,_,_,_,_,_,_,_,_,_,splenic), edge(ID1,ID2).
% An example of verification of 0 exiting edges (can be done also for entering ones)
confidence_rules(N,2) :- N = dorsal_pancreatic, K = #count {ID2: edge(ID1,ID2)}, K = 0, artery(ID1,_,_,_,_,_,_,_,_,_,_,N).

%% SUPERIOR MESENTERIC
confidence_rules(N,0) :- N = sup_mesenteric, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_2(A).
confidence_rules(N,1) :- N = sup_mesenteric, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_8(R).
confidence_rules(N,2) :- N = sup_mesenteric, artery(ID1,_,_,_,_,_,_,_,_,_,_,N), artery(ID2,_,_,_,_,_,_,_,_,_,_,hepatic), edge(ID1,ID2).
confidence_rules(N,3) :- N = sup_mesenteric, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2+10).
confidence_rules(N,4) :- N = sup_mesenteric, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2).
confidence_rules(N,5) :- N = sup_mesenteric, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalL), height_greater(H1,H2).
confidence_rules(N,6) :- N = sup_mesenteric, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalR), height_greater(H1,H2).
confidence_rules(N,7) :- N = sup_mesenteric, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,inf_mesenteric), height_greater(H1,H2+20).

%% LEFT RENAL
confidence_rules(N,0) :- N = renalL, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_8(A).
confidence_rules(N,1) :- N = renalL, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_8(R).
confidence_rules(N,2) :- N = renalL, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2+10).
confidence_rules(N,3) :- N = renalL, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2).
confidence_rules(N,4) :- N = renalL, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,sup_mesenteric), height_less(H1,H2).
confidence_rules(N,5) :- N = renalL, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,inf_mesenteric), height_greater(H1,H2+10).
confidence_rules(N,6) :- N = renalL, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalR), height_less(H1,H2+10).

%% RIGHT RENAL
confidence_rules(N,0) :- N = renalR, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_4(A).
confidence_rules(N,1) :- N = renalR, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_6(R).
confidence_rules(N,2) :- N = renalR, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2+10).
confidence_rules(N,3) :- N = renalR, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2).
confidence_rules(N,4) :- N = renalR, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,sup_mesenteric), height_less(H1,H2).
confidence_rules(N,5) :- N = renalR, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,inf_mesenteric), height_greater(H1,H2+10).
confidence_rules(N,6) :- N = renalR, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalL), height_greater(H1+10,H2).

%% LEFT RENAL MYSTERIOUS (Temp)
confidence_rules(N,0) :- N = renalL_mysterious, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_8(A).
confidence_rules(N,1) :- N = renalL_mysterious, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_6(R).
confidence_rules(N,2) :- N = renalL_mysterious, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2).
confidence_rules(N,3) :- N = renalL_mysterious, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,inf_mesenteric), height_greater(H1,H2).
confidence_rules(N,4) :- N = renalL_mysterious, K = #count {ID2: edge(ID1,ID2)}, K = 0, artery(ID1,N).

%% RIGHT RENAL MYSTERIOUS
confidence_rules(N,0) :- N = renalR_mysterious, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_2(A).
confidence_rules(N,1) :- N = renalR_mysterious, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_3(A).
confidence_rules(N,2) :- N = renalR_mysterious, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_6(R).
confidence_rules(N,3) :- N = renalR_mysterious, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2).
confidence_rules(N,4) :- N = renalR_mysterious, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,inf_mesenteric), height_greater(H1,H2).
confidence_rules(N,5) :- N = renalR_mysterious, K = #count {ID2: edge(ID1,ID2)}, K = 0, artery(ID1,N).

%% INFERIOR MESENTERIC
confidence_rules(N,0) :- N = inf_mesenteric, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_2(A).
confidence_rules(N,1) :- N = inf_mesenteric, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_7(R).
confidence_rules(N,2) :- N = inf_mesenteric, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2+50).
confidence_rules(N,3) :- N = inf_mesenteric, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2+20).
confidence_rules(N,4) :- N = inf_mesenteric, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalL), height_less(H1,H2).
confidence_rules(N,5) :- N = inf_mesenteric, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalR), height_less(H1,H2).
confidence_rules(N,6) :- N = inf_mesenteric, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,sup_mesenteric), height_less(H1,H2+50).
confidence_rules(N,7) :- N = inf_mesenteric, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,sup_mesenteric), height_less(H1,H2+20).

%% 1st LEFT LUMBAR
confidence_rules(N,0)  :- N = lumbarL1, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_7(A).
confidence_rules(N,1)  :- N = lumbarL1, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_4(R).
confidence_rules(N,2)  :- N = lumbarL1, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_6(R).
confidence_rules(N,3)  :- N = lumbarL1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL2), height_greater(H1,H2).
confidence_rules(N,4)  :- N = lumbarL1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL3), height_greater(H1,H2).
confidence_rules(N,5)  :- N = lumbarL1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL4), height_greater(H1,H2).
confidence_rules(N,6)  :- N = lumbarL1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR2), height_greater(H1,H2).
confidence_rules(N,7)  :- N = lumbarL1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR3), height_greater(H1,H2).
confidence_rules(N,8)  :- N = lumbarL1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR4), height_greater(H1,H2).
confidence_rules(N,9)  :- N = lumbarL1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalR), height_less(H1,H2).
confidence_rules(N,10) :- N = lumbarL1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalL), height_less(H1,H2).
confidence_rules(N,11) :- N = lumbarL1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2).
confidence_rules(N,12) :- N = lumbarL1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR1), height_less(H1,H2+5).
confidence_rules(N,13) :- N = lumbarL1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR1), height_greater(H1+5,H2).

%% 1st RIGHT LUMBAR
confidence_rules(N,0)  :- N = lumbarR1, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_6(A).
confidence_rules(N,1)  :- N = lumbarR1, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_4(R).
confidence_rules(N,2)  :- N = lumbarR1, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_6(R).
confidence_rules(N,3)  :- N = lumbarR1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL2), height_greater(H1,H2).
confidence_rules(N,4)  :- N = lumbarR1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL3), height_greater(H1,H2).
confidence_rules(N,5)  :- N = lumbarR1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL4), height_greater(H1,H2).
confidence_rules(N,6)  :- N = lumbarR1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR2), height_greater(H1,H2).
confidence_rules(N,7)  :- N = lumbarR1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR3), height_greater(H1,H2).
confidence_rules(N,8)  :- N = lumbarR1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR4), height_greater(H1,H2).
confidence_rules(N,9)  :- N = lumbarR1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalR), height_less(H1,H2).
confidence_rules(N,10) :- N = lumbarR1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalL), height_less(H1,H2).
confidence_rules(N,11) :- N = lumbarR1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2).
confidence_rules(N,12) :- N = lumbarR1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL1), height_less(H1,H2+5).
confidence_rules(N,13) :- N = lumbarR1, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL1), height_greater(H1+5,H2).

%% 2nd LEFT LUMBAR
confidence_rules(N,0)  :- N = lumbarL2, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_7(A).
confidence_rules(N,1)  :- N = lumbarL2, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_4(R).
confidence_rules(N,2)  :- N = lumbarL2, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_6(R).
confidence_rules(N,3)  :- N = lumbarL2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL1), height_less(H1,H2).
confidence_rules(N,4)  :- N = lumbarL2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL3), height_greater(H1,H2).
confidence_rules(N,5)  :- N = lumbarL2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL4), height_greater(H1,H2).
confidence_rules(N,6)  :- N = lumbarL2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR1), height_less(H1,H2).
confidence_rules(N,7)  :- N = lumbarL2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR3), height_greater(H1,H2).
confidence_rules(N,8)  :- N = lumbarL2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR4), height_greater(H1,H2).
confidence_rules(N,9)  :- N = lumbarL2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalR), height_less(H1,H2).
confidence_rules(N,10) :- N = lumbarL2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalL), height_less(H1,H2).
confidence_rules(N,11) :- N = lumbarL2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2).
confidence_rules(N,12) :- N = lumbarL2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR2), height_less(H1,H2+5).
confidence_rules(N,13) :- N = lumbarL2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR2), height_greater(H1+5,H2).

%% 2nd RIGHT LUMBAR
confidence_rules(N,0)  :- N = lumbarR2, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_6(A).
confidence_rules(N,1)  :- N = lumbarR2, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_4(R).
confidence_rules(N,2)  :- N = lumbarR2, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_6(R).
confidence_rules(N,3)  :- N = lumbarR2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL1), height_less(H1,H2).
confidence_rules(N,4)  :- N = lumbarR2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL3), height_greater(H1,H2).
confidence_rules(N,5)  :- N = lumbarR2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL4), height_greater(H1,H2).
confidence_rules(N,6)  :- N = lumbarR2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR1), height_less(H1,H2).
confidence_rules(N,7)  :- N = lumbarR2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR3), height_greater(H1,H2).
confidence_rules(N,8)  :- N = lumbarR2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR4), height_greater(H1,H2).
confidence_rules(N,9)  :- N = lumbarR2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalR), height_less(H1,H2).
confidence_rules(N,10) :- N = lumbarR2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalL), height_less(H1,H2).
confidence_rules(N,11) :- N = lumbarR2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2).
confidence_rules(N,12) :- N = lumbarR2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL2), height_less(H1,H2+5).
confidence_rules(N,13) :- N = lumbarR2, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL2), height_greater(H1+5,H2).

%% 3rd LEFT LUMBAR
confidence_rules(N,0)  :- N = lumbarL3, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_7(A).
confidence_rules(N,1)  :- N = lumbarL3, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_4(R).
confidence_rules(N,2)  :- N = lumbarL3, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_6(R).
confidence_rules(N,3)  :- N = lumbarL3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL1), height_less(H1,H2).
confidence_rules(N,4)  :- N = lumbarL3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL3), height_greater(H1,H2).
confidence_rules(N,5)  :- N = lumbarL3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL4), height_greater(H1,H2).
confidence_rules(N,6)  :- N = lumbarL3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR1), height_less(H1,H2).
confidence_rules(N,7)  :- N = lumbarL3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR3), height_greater(H1,H2).
confidence_rules(N,8)  :- N = lumbarL3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR4), height_greater(H1,H2).
confidence_rules(N,9)  :- N = lumbarL3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalR), height_less(H1,H2).
confidence_rules(N,10) :- N = lumbarL3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalL), height_less(H1,H2).
confidence_rules(N,11) :- N = lumbarL3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2).
confidence_rules(N,12) :- N = lumbarL3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR2), height_less(H1,H2+5).
confidence_rules(N,13) :- N = lumbarL3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR2), height_greater(H1+5,H2).

%% 3rd RIGHT LUMBAR
confidence_rules(N,0)  :- N = lumbarR3, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_6(A).
confidence_rules(N,1)  :- N = lumbarR3, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_4(R).
confidence_rules(N,2)  :- N = lumbarR3, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_6(R).
confidence_rules(N,3)  :- N = lumbarR3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL1), height_less(H1,H2).
confidence_rules(N,4)  :- N = lumbarR3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL3), height_less(H1,H2).
confidence_rules(N,5)  :- N = lumbarR3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL4), height_greater(H1,H2).
confidence_rules(N,6)  :- N = lumbarR3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR1), height_less(H1,H2).
confidence_rules(N,7)  :- N = lumbarR3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR3), height_less(H1,H2).
confidence_rules(N,8)  :- N = lumbarR3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR4), height_greater(H1,H2).
confidence_rules(N,9)  :- N = lumbarR3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalR), height_less(H1,H2).
confidence_rules(N,10) :- N = lumbarR3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalL), height_less(H1,H2).
confidence_rules(N,11) :- N = lumbarR3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2).
confidence_rules(N,12) :- N = lumbarR3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL3), height_less(H1,H2+5).
confidence_rules(N,13) :- N = lumbarR3, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL3), height_greater(H1+5,H2).

%% 4th LEFT LUMBAR
confidence_rules(N,0)  :- N = lumbarL4, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_7(A).
confidence_rules(N,1)  :- N = lumbarL4, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_4(R).
confidence_rules(N,2)  :- N = lumbarL4, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_6(R).
confidence_rules(N,3)  :- N = lumbarL4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL1), height_less(H1,H2).
confidence_rules(N,4)  :- N = lumbarL4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL3), height_less(H1,H2).
confidence_rules(N,5)  :- N = lumbarL4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL4), height_greater(H1,H2).
confidence_rules(N,6)  :- N = lumbarL4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR1), height_less(H1,H2).
confidence_rules(N,7)  :- N = lumbarL4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR3), height_less(H1,H2).
confidence_rules(N,8)  :- N = lumbarL4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR4), height_greater(H1,H2).
confidence_rules(N,9)  :- N = lumbarL4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalR), height_less(H1,H2).
confidence_rules(N,10) :- N = lumbarL4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalL), height_less(H1,H2).
confidence_rules(N,11) :- N = lumbarL4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2).
confidence_rules(N,12) :- N = lumbarL4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR3), height_less(H1,H2+5).
confidence_rules(N,13) :- N = lumbarL4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR3), height_greater(H1+5,H2).

%% 4th RIGHT LUMBAR
confidence_rules(N,0)  :- N = lumbarR4, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_6(A).
confidence_rules(N,1)  :- N = lumbarR4, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_4(R).
confidence_rules(N,2)  :- N = lumbarR4, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_6(R).
confidence_rules(N,3)  :- N = lumbarR4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL1), height_less(H1,H2).
confidence_rules(N,4)  :- N = lumbarR4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL3), height_less(H1,H2).
confidence_rules(N,5)  :- N = lumbarR4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL4), height_less(H1,H2).
confidence_rules(N,6)  :- N = lumbarR4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR1), height_less(H1,H2).
confidence_rules(N,7)  :- N = lumbarR4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR3), height_less(H1,H2).
confidence_rules(N,8)  :- N = lumbarR4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR4), height_less(H1,H2).
confidence_rules(N,9)  :- N = lumbarR4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalR), height_less(H1,H2).
confidence_rules(N,10) :- N = lumbarR4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,renalL), height_less(H1,H2).
confidence_rules(N,11) :- N = lumbarR4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2).
confidence_rules(N,12) :- N = lumbarR4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL4), height_less(H1,H2+5).
confidence_rules(N,13) :- N = lumbarR4, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL4), height_greater(H1+5,H2).

%%% Constraints
% Structural
:- artery(ID1,_,_,_,_,_,_,_,_,_,_,N1), artery(ID2,_,_,_,_,_,_,_,_,_,_,N2), ID1 != ID2, N1 == N2.
:- artery(ID1,_,_,_,_,_,_,_,_,_,_,N1), artery(ID2,_,_,_,_,_,_,_,_,_,_,N2), ID1 == ID2, N1 != N2.
:- artery(ID1,N1), artery(ID2,N2), ID1 != ID2, N1 == N2.
:- artery(ID1,N1), artery(ID2,N2), ID1 == ID2, N1 != N2.

% Anatomical
:- edge(ID1,ID2), artery(ID1,_,_,_,_,_,_,_,_,_,_,_),, ID1 != aorta.
:- artery(_,_,_,_,_,_,_,_,_,H1,_,celiac_trunk), artery(_,_,_,_,_,_,_,_,_,H2,_,sup_mesenteric), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,celiac_trunk), artery(_,_,_,_,_,_,_,_,_,H2,_,inf_mesenteric), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,celiac_trunk), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR1), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,celiac_trunk), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR2), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,celiac_trunk), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR3), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,celiac_trunk), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR4), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,celiac_trunk), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL1), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,celiac_trunk), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL2), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,celiac_trunk), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL3), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,celiac_trunk), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL4), height_less(H1,H2).

:- artery(_,_,_,_,_,_,_,_,_,H1,_,sup_mesenteric), artery(_,_,_,_,_,_,_,_,_,H2,_,inf_mesenteric), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,sup_mesenteric), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR1), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,sup_mesenteric), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR2), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,sup_mesenteric), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR3), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,sup_mesenteric), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR4), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,sup_mesenteric), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL1), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,sup_mesenteric), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL2), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,sup_mesenteric), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL3), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,sup_mesenteric), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL4), height_less(H1,H2).

:- artery(_,_,_,_,_,_,_,_,_,H1,_,renalR), artery(_,_,_,_,_,_,_,_,_,H2,_,inf_mesenteric), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,renalL), artery(_,_,_,_,_,_,_,_,_,H2,_,inf_mesenteric), height_less(H1,H2).

:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarR1), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR2), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarR1), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR3), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarR1), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR4), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarR1), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL2), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarR1), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL3), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarR1), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL4), height_less(H1,H2).

:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarL1), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR2), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarL1), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR3), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarL1), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR4), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarL1), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL2), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarL1), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL3), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarL1), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL4), height_less(H1,H2).

:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarR2), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR3), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarR2), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR4), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarR2), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL3), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarR2), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL4), height_less(H1,H2).

:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarL2), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR3), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarL2), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR4), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarL2), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL3), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarL2), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL4), height_less(H1,H2).

:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarR3), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR4), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarR3), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL4), height_less(H1,H2).

:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarL3), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarR4), height_less(H1,H2).
:- artery(_,_,_,_,_,_,_,_,_,H1,_,lumbarL3), artery(_,_,_,_,_,_,_,_,_,H2,_,lumbarL4), height_less(H1,H2).

%%% Solution Generation
0 {artery_gen(ID,N) : name(N)} 1 :- id(ID).

% Optimization
rule_count(K) :- K = #count {N,R: confidence_rules(N,R)}.
#maximize {K:rule_count(K)}.

% Satisfiability (just to get unsatisfiable when 0 arteries are found -- remove for optimization)
:- J = #count {ID: artery(ID,_)}, J == 0.

%#show in_artery/4.
%#show artery/12.
%#show params_artery/11.

#show out_artery/2.
#show confidence_rules/2.