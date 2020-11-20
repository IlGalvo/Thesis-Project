% ********** MODEL **********
%**KNOWLEDGE BASE**%

%%%Parameters
angle(1..360).
radius(1..50).
id(ID) :- main_artery_in(ID,_,_,_).
id(ID) :- bif_artery_in(ID,_).
height(Z) :- main_artery_in(_,Z,_,_).
height(Z) :- bif_artery_in(_,Z).

%List of arteries
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

%Radius -- Check if there is a more meaningful one
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

%%Angle -- 0 considered to be the left-facing direction and angle increasing clockwise (e.g., sup_mesenteric = 90, renalR = 180)
%High granularuty -- each 90 degrees
quadrant_1(A) :- angle(A), A > 0,   A <= 90.
quadrant_2(A) :- angle(A), A > 90,  A <= 180.
quadrant_3(A) :- angle(A), A > 180, A <= 270.
quadrant_4(A) :- angle(A), A > 270, A <= 360.
%High granularuty but shifted -- each 90 degrees
shiftedquadrant_1(A) :- angle(A), A > 330, A <= 360.
shiftedquadrant_1(A) :- angle(A), A > 0,   A <= 60.
shiftedquadrant_2(A) :- angle(A), A > 60,  A <= 150.
shiftedquadrant_3(A) :- angle(A), A > 150, A <= 240.
shiftedquadrant_4(A) :- angle(A), A > 240, A <= 330.
%Low granularity -- each 45 degrees
semiquadrant_1(A) :- angle(A), A > 0,   A <= 45.
semiquadrant_2(A) :- angle(A), A > 45,  A <= 90.
semiquadrant_3(A) :- angle(A), A > 90,  A <= 135.
semiquadrant_4(A) :- angle(A), A > 135, A <= 180.
semiquadrant_5(A) :- angle(A), A > 180, A <= 225.
semiquadrant_6(A) :- angle(A), A > 225, A <= 270.
semiquadrant_7(A) :- angle(A), A > 270, A <= 315.
semiquadrant_8(A) :- angle(A), A > 315, A <= 360.

%Height comparators
height_greater(Z1,Z2) :- Z1 > Z2.
height_less(Z1,Z2) :- Z1 < Z2.

%ASP helper
param_main_artery(ID,Z,A,R) :- id(ID), height(Z), angle(A), radius(R), main_artery_in(ID,Z,A,R).
param_bif_artery(ID,R) :- id(ID), radius(R), bif_artery_in(ID,R).

artery(ID,N) :- main_artery(ID,_,_,_,N), id(ID), name(N).
artery(ID,N) :- bif_artery(ID,_,N), id(ID), name(N).

%Relazioni di ordine tra ranges (z < z1+e)
%****Arteries exiting directly from (descending) Aorta.****%
%%CELIAC TRUNK (Examples of various confidence_rules)
main_artery(ID,Z,A,R,N) :- artery_gen(ID,N), name(N), param_main_artery(ID,Z,A,R),
                           N = celiac_trunk, quadrant_1(A), radius_l(R).

confidence_rule(N,0)  :-  N = celiac_trunk, main_artery(_,_,A,_,N), semiquadrant_2(A).
confidence_rule(N,1)  :-  N = celiac_trunk, main_artery(_,_,_,R,N), radius_7(R).
confidence_rule(N,2)  :-  N = celiac_trunk, main_artery(ID,_,_,_,N), edge(aorta,ID).
confidence_rule(N,3)  :-  N = celiac_trunk, main_artery(ID1,_,_,_,N), bif_artery(ID2,_,gastricL), edge(ID1,ID2).
%Less informative version              ... artery     (ID1,      N), artery    (ID2,  gastricL), ....
confidence_rule(N,4)  :-  N = celiac_trunk, main_artery(ID1,_,_,_,N), bif_artery(ID2,_,gastricL), edge(ID1,ID2).
%confidence_rule(N,5)  :-  N = celiac_trunk, main_artery(ID1,_,_,_,N), bif_artery(ID2,_,splenic), edge(ID1,ID2).
%confidence_rule(N,6)  :-  N = celiac_trunk, main_artery(ID1,_,_,_,N), bif_artery(ID2,_,hepatic), edge(ID1,ID2).
confidence_rule(N,7)  :-  N = celiac_trunk, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,sup_mesenteric), height_greater(Z1+10,Z2).
confidence_rule(N,8)  :-  N = celiac_trunk, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,sup_mesenteric), height_greater(Z1,Z2).
confidence_rule(N,9)  :-  N = celiac_trunk, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalL), height_greater(Z1,Z2+10).
confidence_rule(N,10) :-  N = celiac_trunk, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalL), height_greater(Z1,Z2).
confidence_rule(N,11) :-  N = celiac_trunk, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalR), height_greater(Z1,Z2+10).
confidence_rule(N,12) :-  N = celiac_trunk, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalR), height_greater(Z1,Z2).
confidence_rule(N,13) :-  N = celiac_trunk, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,inf_mesenteric), height_greater(Z1,Z2+30).

%%LEFT GASTRIC
bif_artery(ID,R,N) :- artery_gen(ID,N), name(N), param_bif_artery(ID,R),
                      N = gastricL, radius_l(R).

confidence_rule(N,0) :-  N = gastricL, bif_artery(_,R,N), radius_7(R).
confidence_rule(N,1) :-  N = gastricL, bif_artery(ID2,_,N), main_artery(ID1,_,_,_,celiac_trunk), edge(ID1,ID2).

%%SPLENIC
bif_artery(ID,R,N) :- artery_gen(ID,N), name(N), param_bif_artery(ID,R),
                      N = splenic, radius_l(R).

confidence_rule(N,0) :- N = splenic, bif_artery(_,R,N), radius_7(R).
%confidence_rule(N,1) :- N = splenic, bif_artery(ID2,_,N), main_artery(ID1,_,_,_,celiac_trunk), edge(ID1,ID2).

%%HEPATIC
bif_artery(ID,R,N) :- artery_gen(ID,N), name(N), param_bif_artery(ID,R),
                      N = hepatic, radius_l(R).

confidence_rule(N,0) :- N = hepatic, bif_artery(_,R,N), radius_7(R).
%confidence_rule(N,1) :- N = hepatic, bif_artery(ID2,_,N), main_artery(ID1,_,_,_,celiac_trunk), edge(ID1,ID2).
confidence_rule(N,2) :- N = hepatic, bif_artery(ID2,_,N), main_artery(ID1,_,_,_,sup_mesenteric), edge(ID1,ID2).

%%DORSAL PANCREATIC
bif_artery(ID,R,N) :- artery_gen(ID,N), name(N), param_bif_artery(ID,R),
                      N = dorsal_pancreatic, radius_l(R).

confidence_rule(N,0) :- N = dorsal_pancreatic, bif_artery(_,R,N), radius_7(R).
%confidence_rule(N,..) :-  N = hepatic, bif_artery(ID2,_,N), main_artery(ID1,_,_,_,celiac_trunk), edge(ID1,ID2).
%An example of verification of 0 exiting edges (can be done also for entering ones)
confidence_rule(N,1) :- N = dorsal_pancreatic, K = #count {ID2: edge(ID1,ID2)}, K = 0, bif_artery(ID1,_,N).

%%SUPERIOR MESENTERIC
main_artery(ID,Z,A,R,N) :- artery_gen(ID,N), name(N), param_main_artery(ID,Z,A,R),
                           N = sup_mesenteric, quadrant_1(A), radius_l(R).

confidence_rule(N,0) :-  N = sup_mesenteric, main_artery(_,_,A,_,N), semiquadrant_2(A).
confidence_rule(N,1) :-  N = sup_mesenteric, main_artery(_,_,_,R,N), radius_8(R).
confidence_rule(N,2) :-  N = sup_mesenteric, main_artery(ID,_,_,_,N), edge(aorta,ID).
confidence_rule(N,3) :-  N = sup_mesenteric, main_artery(ID1,_,_,_,N), bif_artery(ID2,_,hepatic), edge(ID1,ID2).
confidence_rule(N,5) :-  N = sup_mesenteric, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2+10).
confidence_rule(N,6) :-  N = sup_mesenteric, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2).
confidence_rule(N,7) :-  N = sup_mesenteric, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalL), height_greater(Z1,Z2).
confidence_rule(N,8) :-  N = sup_mesenteric, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalR), height_greater(Z1,Z2).
confidence_rule(N,9) :-  N = sup_mesenteric, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,inf_mesenteric), height_greater(Z1,Z2+20).

%%LEFT RENAL
main_artery(ID,Z,A,R,N) :- artery_gen(ID,N), name(N), param_main_artery(ID,Z,A,R),
                           N = renalL, quadrant_4(A), radius_l(R).

confidence_rule(N,0) :-  N = renalL, main_artery(_,_,A,_,N), semiquadrant_8(A).
confidence_rule(N,1) :-  N = renalL, main_artery(_,_,_,R,N), radius_8(R).
confidence_rule(N,2) :-  N = renalL, main_artery(ID,_,_,_,N), edge(aorta,ID).
confidence_rule(N,3) :-  N = renalL, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2+10).
confidence_rule(N,4) :-  N = renalL, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2).
confidence_rule(N,5) :-  N = renalL, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,sup_mesenteric), height_less(Z1,Z2).
confidence_rule(N,6) :-  N = renalL, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,inf_mesenteric), height_greater(Z1,Z2+10).
confidence_rule(N,7) :-  N = renalL, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalR), height_less(Z1,Z2+10).

%%RIGHT RENAL
main_artery(ID,Z,A,R,N) :- artery_gen(ID,N), name(N), param_main_artery(ID,Z,A,R),
                           N = renalR, quadrant_2(A), radius_m(R).

confidence_rule(N,0) :-  N = renalR, main_artery(_,_,A,_,N), semiquadrant_4(A).
confidence_rule(N,1) :-  N = renalR, main_artery(_,_,_,R,N), radius_6(R).
confidence_rule(N,2) :-  N = renalR, main_artery(ID,_,_,_,N), edge(aorta,ID).
confidence_rule(N,5) :-  N = renalR, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2+10).
confidence_rule(N,6) :-  N = renalR, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2).
confidence_rule(N,7) :-  N = renalR, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,sup_mesenteric), height_less(Z1,Z2).
confidence_rule(N,9) :-  N = renalR, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,inf_mesenteric), height_greater(Z1,Z2+10).
confidence_rule(N,7) :-  N = renalR, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalL), height_greater(Z1+10,Z2).

%%LEFT RENAL MYSTERIOUS
main_artery(ID,Z,A,R,N) :- artery_gen(ID,N), name(N), param_main_artery(ID,Z,A,R),
                           N = renalL_mysterious, quadrant_4(A), radius_m(R).

confidence_rule(N,0) :-  N = renalL_mysterious, main_artery(_,_,A,_,N), semiquadrant_8(A).
confidence_rule(N,1) :-  N = renalL_mysterious, main_artery(_,_,_,R,N), radius_6(R).
confidence_rule(N,2) :-  N = renalL_mysterious, main_artery(ID,_,_,_,N), edge(aorta,ID).
confidence_rule(N,3) :-  N = renalL_mysterious, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2).
confidence_rule(N,4) :-  N = renalL_mysterious, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,inf_mesenteric), height_greater(Z1,Z2).
confidence_rule(N,5) :-  N = renalL_mysterious, K = #count {ID2: edge(ID1,ID2)}, K = 0, artery(ID1,N).

%%RIGHT RENAL MYSTERIOUS
main_artery(ID,Z,A,R,N) :- artery_gen(ID,N), name(N), param_main_artery(ID,Z,A,R),
                           N = renalR_mysterious, shiftedquadrant_2(A), radius_m(R).

confidence_rule(N,0) :-  N = renalR_mysterious, main_artery(_,_,A,_,N), semiquadrant_2(A).
confidence_rule(N,1) :-  N = renalR_mysterious, main_artery(_,_,A,_,N), semiquadrant_3(A).
confidence_rule(N,2) :-  N = renalR_mysterious, main_artery(_,_,_,R,N), radius_6(R).
confidence_rule(N,3) :-  N = renalR_mysterious, main_artery(ID,_,_,_,N), edge(aorta,ID).
confidence_rule(N,4) :-  N = renalR_mysterious, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2).
confidence_rule(N,5) :-  N = renalR_mysterious, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,inf_mesenteric), height_greater(Z1,Z2).
confidence_rule(N,6) :-  N = renalR_mysterious, K = #count {ID2: edge(ID1,ID2)}, K = 0, artery(ID1,N).

%%INFERIOR MESENTERIC
main_artery(ID,Z,A,R,N) :- artery_gen(ID,N), name(N), param_main_artery(ID,Z,A,R),
                           N = inf_mesenteric, quadrant_1(A), radius_l(R).

confidence_rule(N,0) :-  N = inf_mesenteric, main_artery(_,_,A,_,N), semiquadrant_2(A).
confidence_rule(N,1) :-  N = inf_mesenteric, main_artery(_,_,_,R,N), radius_7(R).
confidence_rule(N,2) :-  N = inf_mesenteric, main_artery(ID,_,_,_,N), edge(aorta,ID).
confidence_rule(N,3) :-  N = inf_mesenteric, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2+50).
confidence_rule(N,4) :-  N = inf_mesenteric, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2+20).
confidence_rule(N,5) :-  N = inf_mesenteric, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalL), height_less(Z1,Z2).
confidence_rule(N,6) :-  N = inf_mesenteric, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalR), height_less(Z1,Z2).
confidence_rule(N,7) :-  N = inf_mesenteric, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,sup_mesenteric), height_less(Z1,Z2+50).
confidence_rule(N,8) :-  N = inf_mesenteric, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,sup_mesenteric), height_less(Z1,Z2+20).

%%1st LEFT LUMBAR
main_artery(ID,Z,A,R,N) :- artery_gen(ID,N), name(N), param_main_artery(ID,Z,A,R),
                           N = lumbarL1, quadrant_4(A), radius_big(R).

confidence_rule(N,0)  :-  N = lumbarL1, main_artery(_,_,A,_,N), semiquadrant_7(A).
confidence_rule(N,1)  :-  N = lumbarL1, main_artery(_,_,_,R,N), radius_4(R).
confidence_rule(N,2)  :-  N = lumbarL1, main_artery(_,_,_,R,N), radius_6(R).
confidence_rule(N,3)  :-  N = lumbarL1, main_artery(ID,_,_,_,N), edge(aorta,ID).
confidence_rule(N,4)  :-  N = lumbarL1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL2), height_greater(Z1,Z2).
confidence_rule(N,5)  :-  N = lumbarL1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL3), height_greater(Z1,Z2).
confidence_rule(N,6)  :-  N = lumbarL1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL4), height_greater(Z1,Z2).
confidence_rule(N,7)  :-  N = lumbarL1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR2), height_greater(Z1,Z2).
confidence_rule(N,8)  :-  N = lumbarL1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR3), height_greater(Z1,Z2).
confidence_rule(N,9)  :-  N = lumbarL1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR4), height_greater(Z1,Z2).
confidence_rule(N,10) :-  N = lumbarL1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalR), height_less(Z1,Z2).
confidence_rule(N,11) :-  N = lumbarL1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalL), height_less(Z1,Z2).
confidence_rule(N,12) :-  N = lumbarL1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2).
confidence_rule(N,13) :-  N = lumbarL1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR1), height_less(Z1,Z2+5).
confidence_rule(N,14) :-  N = lumbarL1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR1), height_greater(Z1+5,Z2).

%%1st RIGHT LUMBAR
main_artery(ID,Z,A,R,N) :- artery_gen(ID,N), name(N), param_main_artery(ID,Z,A,R),
                           N = lumbarR1, quadrant_3(A), radius_big(R).

confidence_rule(N,0)  :-  N = lumbarR1, main_artery(_,_,A,_,N), semiquadrant_6(A).
confidence_rule(N,1)  :-  N = lumbarR1, main_artery(_,_,_,R,N), radius_4(R).
confidence_rule(N,2)  :-  N = lumbarR1, main_artery(_,_,_,R,N), radius_6(R).
confidence_rule(N,3)  :-  N = lumbarR1, main_artery(ID,_,_,_,N), edge(aorta,ID).
confidence_rule(N,4)  :-  N = lumbarR1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL2), height_greater(Z1,Z2).
confidence_rule(N,5)  :-  N = lumbarR1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL3), height_greater(Z1,Z2).
confidence_rule(N,6)  :-  N = lumbarR1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL4), height_greater(Z1,Z2).
confidence_rule(N,7)  :-  N = lumbarR1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR2), height_greater(Z1,Z2).
confidence_rule(N,8)  :-  N = lumbarR1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR3), height_greater(Z1,Z2).
confidence_rule(N,9)  :-  N = lumbarR1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR4), height_greater(Z1,Z2).
confidence_rule(N,10) :-  N = lumbarR1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalR), height_less(Z1,Z2).
confidence_rule(N,11) :-  N = lumbarR1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalL), height_less(Z1,Z2).
confidence_rule(N,12) :-  N = lumbarR1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2).
confidence_rule(N,13) :-  N = lumbarR1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL1), height_less(Z1,Z2+5).
confidence_rule(N,14) :-  N = lumbarR1, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL1), height_greater(Z1+5,Z2).

%%2nd LEFT LUMBAR
main_artery(ID,Z,A,R,N) :- artery_gen(ID,N), name(N), param_main_artery(ID,Z,A,R),
                           N = lumbarL2, quadrant_4(A), radius_big(R).

confidence_rule(N,0)  :-  N = lumbarL2, main_artery(_,_,A,_,N), semiquadrant_7(A).
confidence_rule(N,1)  :-  N = lumbarL2, main_artery(_,_,_,R,N), radius_4(R).
confidence_rule(N,2)  :-  N = lumbarL2, main_artery(_,_,_,R,N), radius_6(R).
confidence_rule(N,3)  :-  N = lumbarL2, main_artery(ID,_,_,_,N), edge(aorta,ID).
confidence_rule(N,4)  :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL1), height_less(Z1,Z2).
confidence_rule(N,5)  :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL3), height_greater(Z1,Z2).
confidence_rule(N,6)  :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL4), height_greater(Z1,Z2).
confidence_rule(N,7)  :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR1), height_less(Z1,Z2).
confidence_rule(N,8)  :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR3), height_greater(Z1,Z2).
confidence_rule(N,9)  :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR4), height_greater(Z1,Z2).
confidence_rule(N,10) :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalR), height_less(Z1,Z2).
confidence_rule(N,11) :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalL), height_less(Z1,Z2).
confidence_rule(N,12) :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2).
confidence_rule(N,13) :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR2), height_less(Z1,Z2+5).
confidence_rule(N,14) :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR2), height_greater(Z1+5,Z2).

%%2nd RIGHT LUMBAR
main_artery(ID,Z,A,R,N) :- artery_gen(ID,N), name(N), param_main_artery(ID,Z,A,R),
                           N = lumbarR2, quadrant_3(A), radius_big(R).

confidence_rule(N,0)  :-  N = lumbarR2, main_artery(_,_,A,_,N), semiquadrant_6(A).
confidence_rule(N,1)  :-  N = lumbarR2, main_artery(_,_,_,R,N), radius_4(R).
confidence_rule(N,2)  :-  N = lumbarR2, main_artery(_,_,_,R,N), radius_6(R).
confidence_rule(N,3)  :-  N = lumbarR2, main_artery(ID,_,_,_,N), edge(aorta,ID).
confidence_rule(N,4)  :-  N = lumbarR2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL1), height_less(Z1,Z2).
confidence_rule(N,5)  :-  N = lumbarR2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL3), height_greater(Z1,Z2).
confidence_rule(N,6)  :-  N = lumbarR2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL4), height_greater(Z1,Z2).
confidence_rule(N,7)  :-  N = lumbarR2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR1), height_less(Z1,Z2).
confidence_rule(N,8)  :-  N = lumbarR2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR3), height_greater(Z1,Z2).
confidence_rule(N,9)  :-  N = lumbarR2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR4), height_greater(Z1,Z2).
confidence_rule(N,10) :-  N = lumbarR2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalR), height_less(Z1,Z2).
confidence_rule(N,11) :-  N = lumbarR2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalL), height_less(Z1,Z2).
confidence_rule(N,12) :-  N = lumbarR2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2).
confidence_rule(N,13) :-  N = lumbarR2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL2), height_less(Z1,Z2+5).
confidence_rule(N,14) :-  N = lumbarR2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL2), height_greater(Z1+5,Z2).

%%2nd LEFT LUMBAR
main_artery(ID,Z,A,R,N) :- artery_gen(ID,N), name(N), param_main_artery(ID,Z,A,R),
                           N = lumbarL2, quadrant_4(A), radius_big(R).

confidence_rule(N,0)  :-  N = lumbarL2, main_artery(_,_,A,_,N), semiquadrant_7(A).
confidence_rule(N,1)  :-  N = lumbarL2, main_artery(_,_,_,R,N), radius_4(R).
confidence_rule(N,2)  :-  N = lumbarL2, main_artery(_,_,_,R,N), radius_6(R).
confidence_rule(N,3)  :-  N = lumbarL2, main_artery(ID,_,_,_,N), edge(aorta,ID).
confidence_rule(N,4)  :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL1), height_less(Z1,Z2).
confidence_rule(N,5)  :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL3), height_greater(Z1,Z2).
confidence_rule(N,6)  :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL4), height_greater(Z1,Z2).
confidence_rule(N,7)  :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR1), height_less(Z1,Z2).
confidence_rule(N,8)  :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR3), height_greater(Z1,Z2).
confidence_rule(N,9)  :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR4), height_greater(Z1,Z2).
confidence_rule(N,10) :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalR), height_less(Z1,Z2).
confidence_rule(N,11) :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalL), height_less(Z1,Z2).
confidence_rule(N,12) :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2).
confidence_rule(N,13) :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR2), height_less(Z1,Z2+5).
confidence_rule(N,14) :-  N = lumbarL2, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR2), height_greater(Z1+5,Z2).

%%3rd RIGHT LUMBAR
main_artery(ID,Z,A,R,N) :- artery_gen(ID,N), name(N), param_main_artery(ID,Z,A,R),
                           N = lumbarR3, quadrant_3(A), radius_big(R).

confidence_rule(N,0)  :-  N = lumbarR3, main_artery(_,_,A,_,N), semiquadrant_6(A).
confidence_rule(N,1)  :-  N = lumbarR3, main_artery(_,_,_,R,N), radius_4(R).
confidence_rule(N,2)  :-  N = lumbarR3, main_artery(_,_,_,R,N), radius_6(R).
confidence_rule(N,3)  :-  N = lumbarR3, main_artery(ID,_,_,_,N), edge(aorta,ID).
confidence_rule(N,4)  :-  N = lumbarR3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL1), height_less(Z1,Z2).
confidence_rule(N,5)  :-  N = lumbarR3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL3), height_less(Z1,Z2).
confidence_rule(N,6)  :-  N = lumbarR3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL4), height_greater(Z1,Z2).
confidence_rule(N,7)  :-  N = lumbarR3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR1), height_less(Z1,Z2).
confidence_rule(N,8)  :-  N = lumbarR3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR3), height_less(Z1,Z2).
confidence_rule(N,9)  :-  N = lumbarR3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR4), height_greater(Z1,Z2).
confidence_rule(N,10) :-  N = lumbarR3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalR), height_less(Z1,Z2).
confidence_rule(N,11) :-  N = lumbarR3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalL), height_less(Z1,Z2).
confidence_rule(N,12) :-  N = lumbarR3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2).
confidence_rule(N,13) :-  N = lumbarR3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL3), height_less(Z1,Z2+5).
confidence_rule(N,14) :-  N = lumbarR3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL3), height_greater(Z1+5,Z2).

%%3rd LEFT LUMBAR
main_artery(ID,Z,A,R,N) :- artery_gen(ID,N), name(N), param_main_artery(ID,Z,A,R),
                           N = lumbarL3, quadrant_4(A), radius_big(R).

confidence_rule(N,0)  :-  N = lumbarL3, main_artery(_,_,A,_,N), semiquadrant_7(A).
confidence_rule(N,1)  :-  N = lumbarL3, main_artery(_,_,_,R,N), radius_4(R).
confidence_rule(N,2)  :-  N = lumbarL3, main_artery(_,_,_,R,N), radius_6(R).
confidence_rule(N,3)  :-  N = lumbarL3, main_artery(ID,_,_,_,N), edge(aorta,ID).
confidence_rule(N,4)  :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL1), height_less(Z1,Z2).
confidence_rule(N,5)  :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL3), height_less(Z1,Z2).
confidence_rule(N,6)  :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL4), height_greater(Z1,Z2).
confidence_rule(N,7)  :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR1), height_less(Z1,Z2).
confidence_rule(N,8)  :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR3), height_less(Z1,Z2).
confidence_rule(N,9)  :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR4), height_greater(Z1,Z2).
confidence_rule(N,10) :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalR), height_less(Z1,Z2).
confidence_rule(N,11) :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalL), height_less(Z1,Z2).
confidence_rule(N,12) :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2).
confidence_rule(N,13) :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR3), height_less(Z1,Z2+5).
confidence_rule(N,14) :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR3), height_greater(Z1+5,Z2).

%%4th RIGHT LUMBAR
main_artery(ID,Z,A,R,N) :- artery_gen(ID,N), name(N), param_main_artery(ID,Z,A,R),
                           N = lumbarR4, quadrant_3(A), radius_big(R).

confidence_rule(N,0)  :-  N = lumbarR4, main_artery(_,_,A,_,N), semiquadrant_6(A).
confidence_rule(N,1)  :-  N = lumbarR4, main_artery(_,_,_,R,N), radius_4(R).
confidence_rule(N,2)  :-  N = lumbarR4, main_artery(_,_,_,R,N), radius_6(R).
confidence_rule(N,3)  :-  N = lumbarR4, main_artery(ID,_,_,_,N), edge(aorta,ID).
confidence_rule(N,4)  :-  N = lumbarR4, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL1), height_less(Z1,Z2).
confidence_rule(N,5)  :-  N = lumbarR4, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL3), height_less(Z1,Z2).
confidence_rule(N,6)  :-  N = lumbarR4, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL4), height_less(Z1,Z2).
confidence_rule(N,7)  :-  N = lumbarR4, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR1), height_less(Z1,Z2).
confidence_rule(N,8)  :-  N = lumbarR4, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR3), height_less(Z1,Z2).
confidence_rule(N,9)  :-  N = lumbarR4, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR4), height_less(Z1,Z2).
confidence_rule(N,10) :-  N = lumbarR4, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalR), height_less(Z1,Z2).
confidence_rule(N,11) :-  N = lumbarR4, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalL), height_less(Z1,Z2).
confidence_rule(N,12) :-  N = lumbarR4, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2).
confidence_rule(N,13) :-  N = lumbarR4, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL4), height_less(Z1,Z2+5).
confidence_rule(N,14) :-  N = lumbarR4, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL4), height_greater(Z1+5,Z2).

%%3rd LEFT LUMBAR
main_artery(ID,Z,A,R,N) :- artery_gen(ID,N), name(N), param_main_artery(ID,Z,A,R),
                           N = lumbarL3, quadrant_4(A), radius_big(R).

confidence_rule(N,0)  :-  N = lumbarL3, main_artery(_,_,A,_,N), semiquadrant_7(A).
confidence_rule(N,1)  :-  N = lumbarL3, main_artery(_,_,_,R,N), radius_4(R).
confidence_rule(N,2)  :-  N = lumbarL3, main_artery(_,_,_,R,N), radius_6(R).
confidence_rule(N,3)  :-  N = lumbarL3, main_artery(ID,_,_,_,N), edge(aorta,ID).
confidence_rule(N,4)  :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL1), height_less(Z1,Z2).
confidence_rule(N,5)  :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL3), height_less(Z1,Z2).
confidence_rule(N,6)  :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarL4), height_greater(Z1,Z2).
confidence_rule(N,7)  :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR1), height_less(Z1,Z2).
confidence_rule(N,8)  :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR3), height_less(Z1,Z2).
confidence_rule(N,9)  :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR4), height_greater(Z1,Z2).
confidence_rule(N,10) :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalR), height_less(Z1,Z2).
confidence_rule(N,11) :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,renalL), height_less(Z1,Z2).
confidence_rule(N,12) :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,celiac_trunk), height_less(Z1,Z2).
confidence_rule(N,13) :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR3), height_less(Z1,Z2+5).
confidence_rule(N,14) :-  N = lumbarL3, main_artery(_,Z1,_,_,N), main_artery(_,Z2,_,_,lumbarR3), height_greater(Z1+5,Z2).

%%%Constraints
%Structural
:- main_artery(ID1,_,_,_,N1), main_artery(ID2,_,_,_,N2), ID1 != ID2, N1 == N2.
:- main_artery(ID1,_,_,_,N1), main_artery(ID2,_,_,_,N2), ID1 == ID2, N1 != N2.
:- bif_artery(ID1,_,N1), bif_artery(ID2,_,N2), ID1 != ID2, N1 == N2.
:- bif_artery(ID1,_,N1), bif_artery(ID2,_,N2), ID1 == ID2, N1 != N2.
:- artery(ID1,N1), artery(ID2,N2), ID1 != ID2, N1 == N2.
:- artery(ID1,N1), artery(ID2,N2), ID1 == ID2, N1 != N2.

%Anatomical
:- edge(ID1,ID2), main_artery(ID2,_,_,_,_), ID1 != aorta.
:- main_artery(_,Z1,_,_,celiac_trunk), main_artery(_,Z2,_,_,sup_mesenteric), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,celiac_trunk), main_artery(_,Z2,_,_,inf_mesenteric), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,celiac_trunk), main_artery(_,Z2,_,_,lumbarR1), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,celiac_trunk), main_artery(_,Z2,_,_,lumbarR2), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,celiac_trunk), main_artery(_,Z2,_,_,lumbarR3), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,celiac_trunk), main_artery(_,Z2,_,_,lumbarR4), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,celiac_trunk), main_artery(_,Z2,_,_,lumbarL1), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,celiac_trunk), main_artery(_,Z2,_,_,lumbarL2), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,celiac_trunk), main_artery(_,Z2,_,_,lumbarL3), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,celiac_trunk), main_artery(_,Z2,_,_,lumbarL4), height_less(Z1,Z2).

:- main_artery(_,Z1,_,_,sup_mesenteric), main_artery(_,Z2,_,_,inf_mesenteric), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,sup_mesenteric), main_artery(_,Z2,_,_,lumbarR1), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,sup_mesenteric), main_artery(_,Z2,_,_,lumbarR2), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,sup_mesenteric), main_artery(_,Z2,_,_,lumbarR3), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,sup_mesenteric), main_artery(_,Z2,_,_,lumbarR4), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,sup_mesenteric), main_artery(_,Z2,_,_,lumbarL1), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,sup_mesenteric), main_artery(_,Z2,_,_,lumbarL2), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,sup_mesenteric), main_artery(_,Z2,_,_,lumbarL3), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,sup_mesenteric), main_artery(_,Z2,_,_,lumbarL4), height_less(Z1,Z2).

:- main_artery(_,Z1,_,_,renalR), main_artery(_,Z2,_,_,inf_mesenteric), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,renalL), main_artery(_,Z2,_,_,inf_mesenteric), height_less(Z1,Z2).

:- main_artery(_,Z1,_,_,lumbarR1), main_artery(_,Z2,_,_,lumbarR2), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,lumbarR1), main_artery(_,Z2,_,_,lumbarR3), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,lumbarR1), main_artery(_,Z2,_,_,lumbarR4), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,lumbarR1), main_artery(_,Z2,_,_,lumbarL2), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,lumbarR1), main_artery(_,Z2,_,_,lumbarL3), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,lumbarR1), main_artery(_,Z2,_,_,lumbarL4), height_less(Z1,Z2).

:- main_artery(_,Z1,_,_,lumbarL1), main_artery(_,Z2,_,_,lumbarR2), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,lumbarL1), main_artery(_,Z2,_,_,lumbarR3), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,lumbarL1), main_artery(_,Z2,_,_,lumbarR4), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,lumbarL1), main_artery(_,Z2,_,_,lumbarL2), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,lumbarL1), main_artery(_,Z2,_,_,lumbarL3), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,lumbarL1), main_artery(_,Z2,_,_,lumbarL4), height_less(Z1,Z2).

:- main_artery(_,Z1,_,_,lumbarR2), main_artery(_,Z2,_,_,lumbarR3), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,lumbarR2), main_artery(_,Z2,_,_,lumbarR4), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,lumbarR2), main_artery(_,Z2,_,_,lumbarL3), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,lumbarR2), main_artery(_,Z2,_,_,lumbarL4), height_less(Z1,Z2).

:- main_artery(_,Z1,_,_,lumbarL2), main_artery(_,Z2,_,_,lumbarR3), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,lumbarL2), main_artery(_,Z2,_,_,lumbarR4), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,lumbarL2), main_artery(_,Z2,_,_,lumbarL3), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,lumbarL2), main_artery(_,Z2,_,_,lumbarL4), height_less(Z1,Z2).

:- main_artery(_,Z1,_,_,lumbarR3), main_artery(_,Z2,_,_,lumbarR4), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,lumbarR3), main_artery(_,Z2,_,_,lumbarL4), height_less(Z1,Z2).

:- main_artery(_,Z1,_,_,lumbarL3), main_artery(_,Z2,_,_,lumbarR4), height_less(Z1,Z2).
:- main_artery(_,Z1,_,_,lumbarL3), main_artery(_,Z2,_,_,lumbarL4), height_less(Z1,Z2).

:- bif_artery(_,_,celiac_trunk).
:- bif_artery(_,_,sup_mesenteric).
:- bif_artery(_,_,renalL).
:- bif_artery(_,_,renalR).
:- bif_artery(_,_,renalL_mysterious).
:- bif_artery(_,_,renalR_mysterious).
:- bif_artery(_,_,inf_mesenteric).
:- bif_artery(_,_,lumbarR1).
:- bif_artery(_,_,lumbarL1).
:- bif_artery(_,_,lumbarR2).
:- bif_artery(_,_,lumbarL2).
:- bif_artery(_,_,lumbarR3).
:- bif_artery(_,_,lumbarL3).
:- bif_artery(_,_,lumbarR4).
:- bif_artery(_,_,lumbarL4).

%%%Solution Generation
0 {artery_gen(ID,N) : name(N)} 1 :- id(ID).

%Optimization
rule_count(K) :- K = #count {N,R: confidence_rule(N,R)}.
#maximize {K:rule_count(K)}.

%Satisfiability (just to get unsatisfiable when 0 arteries are found -- remove for optimization)
:- J = #count {ID: artery(ID,_)}, J == 0.

%#show main_artery_in/4.
%#show main_artery/5.
%#show bif_artery/3.
%#show param_bif_artery/2.

#show artery/2.
#show confidence_rule/2. 