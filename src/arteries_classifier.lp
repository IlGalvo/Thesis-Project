% ********** MODEL ********** %
% **KNOWLEDGE BASE ********** %
% ********** MODEL ********** %

%%% Parameters
id(ID)			:- artery(ID,_,_,_,_,_,_,_,_,_,_).
radius(1..50).
density(D)		:- artery(_,_,D,_,_,_,_,_,_,_,_).
quality(Q)		:- artery(_,_,_,Q,_,_,_,_,_,_,_).
cog_x(X)		:- artery(_,_,_,_,X,_,_,_,_,_,_).
cog_y(Y) 		:- artery(_,_,_,_,_,Y,_,_,_,_,_).
cog_z(Z) 		:- artery(_,_,_,_,_,_,Z,_,_,_,_).
path_length(PL) :- artery(_,_,_,_,_,_,_,PL,_,_,_).
dfe(DE) 		:- artery(_,_,_,_,_,_,_,_,DE,_,_).
height(H) 		:- artery(_,_,_,_,_,_,_,_,_,H,_).
angle(1..360).

% List of arteries
name(celiac_trunk).
name(left_gastric).
name(splenic).
name(common_hepatic).
name(proper_hepatic).
name(dorsal_pancreatic).
name(left_renal).
name(right_renal).
name(accessory_left_renal).
name(accessory_right_renal).
name(gastroduodenal).
name(left_hepatic).
name(right_hepatic).
name(superior_mesenteric).
name(left_intercostal_1).
name(right_intercostal_1).
name(left_intercostal_2).
name(right_intercostal_2).

%%%%% For nonames names
dummy_name(X) :- model(_,_,X,_), X != aorta, X != no.
dummy_name(X) :- model(_,_,_,X), X != aorta, X != no.
name(X)       :- dummy_name(X).

% Radius -- Check if there is a more meaningful one
radius_small(R) :- radius(R), R > 0,  R <= 20.
radius_big(R)   :- radius(R), R > 20.

radius_s(R)     :- radius(R), R > 0,  R <= 10.
radius_m(R)     :- radius(R), R > 10, R <= 20.
radius_l(R)     :- radius(R), R > 20.

radius_0_5(R)   :- radius(R), R > 0,  R <= 5.
radius_5_10(R)  :- radius(R), R > 5,  R <= 10.
radius_10_15(R) :- radius(R), R > 10, R <= 15.
radius_15_20(R) :- radius(R), R > 15, R <= 20.
radius_20_25(R) :- radius(R), R > 20, R <= 25.
radius_25_30(R) :- radius(R), R > 25, R <= 30.
radius_30_35(R) :- radius(R), R > 30, R <= 35.
radius_35_40(R) :- radius(R), R > 35, R <= 40.
radius_40(R)    :- radius(R), R > 40.

%% Angle -- 0 considered to be the left-facing direction and angle increasing clockwise (e.g., sup_mesenteric = 90, renalR = 180)
% High granularuty -- each 90 degrees
quadrant_1(A) :- semiquadrant_2(A). %% 90 gradi (fronte)
quadrant_1(A) :- semiquadrant_3(A). %% 90 gradi (fronte)
quadrant_2(A) :- semiquadrant_4(A). %% 180 gradi (destra)
quadrant_2(A) :- semiquadrant_5(A).%% 180 gradi (destra)
quadrant_3(A) :- semiquadrant_6(A).%% 270 gradi (dietro)
quadrant_3(A) :- semiquadrant_7(A).%% 270 gradi (dietro)
quadrant_4(A) :- semiquadrant_8(A).%% 0 gradi sinistra
quadrant_4(A) :- semiquadrant_1(A).%% 0 gradi sinistra

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
height_greater(H1,H2) :- height(H1), height(H2), H1 > H2.
height_less(H1,H2)    :- height(H1), height(H2), H1 < H2.

% ASP helper
params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A) :- id(ID), radius(R), density(D), quality(Q),
                                           cog_x(X), cog_y(Y), cog_z(Z), path_length(PL),
                                           dfe(DE), height(H), angle(A), artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A).

out_artery(ID,N) :- artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N), id(ID), name(N).

%%%%%%%%% Transitivity on edges
edge_t(ID1,ID2) :- edge(ID1,ID2).
edge_t(ID1,ID3) :- edge(ID1,ID2), id(ID1), id(ID2), id(ID3),
                   edge_t(ID2,ID3).

%%%%%%%%% Transitivity on edges strict = no labels in between the nodes
% ToDo

%%% Arteries exiting directly from (descending) Aorta.
%% Don't move, it's for parser efficiency
% artery(ID,radius,density,quality,center_of_ggravity_x,center_of_ggravity_y,center_of_ggravity_z,
%        path_legth,distance_from_extremes,heigth,angle,name).

artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N) :- artery_gen(ID,N), name(N), params_artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A).

%%% Force partial solution for debug
%out_artery(72,celiac_trunk).
%out_artery(58,splenic).
%out_artery(74,left_gastric).
%out_artery(6,noname1).
%out_artery(44,right_hepatic).
%out_artery(11,superior_mesenteric).

%out_artery(92,common_hepatic).
%out_artery(21,gastroduodenal).
%out_artery(70,left_hepatic).
%model_gen(2,3).

%%% Anatomical and topological constraints

%%%%%%%%% Topological models: model(ID, Variant, _, _)
%%%%%%%%% Hard constraints = model ID must hold
%%%% Here alternative models of trees are listed
%%%% exacly one model is imposed among Variants for same ID
%%%% simple confidence rules with no variants should not be listed here

%%%% Model relationships are direct children names (i.e. no known labels are expected in between a pair)
%%%% to name a unlabeled tract, use nonameX labels

model(0,1,aorta,celiac_trunk).
model(0,1,aorta,superior_mesenteric).

%%% celiac trunk, left_gastric, splenic
model(1,1,celiac_trunk,left_gastric).
model(1,1,celiac_trunk,noname1).
model(1,1,noname1,splenic).

%%%% hepatic
%%%% 1: common hepatic branches from celiac trunk
model(2,1,noname1,common_hepatic).
model(2,1,common_hepatic,gastroduodenal).
model(2,1,common_hepatic,proper_hepatic).
model(2,1,proper_hepatic,left_hepatic).
model(2,1,proper_hepatic,right_hepatic).

%%%% 2: common hepatic branches from superior mesenteric (TODO: what happens to noname1 and celiac trunk after splenic branch!)
model(2,2,superior_mesenteric,common_hepatic).
model(2,2,common_hepatic,gastroduodenal).
model(2,2,common_hepatic,proper_hepatic).
model(2,2,proper_hepatic,left_hepatic).
model(2,2,proper_hepatic,right_hepatic).

%%%% 3: right hepatic branches from superior mesenteric
model(2,3,superior_mesenteric,right_hepatic).
model(2,3,noname1,common_hepatic).
model(2,3,common_hepatic,gastroduodenal).
model(2,3,common_hepatic,left_hepatic).
model(2,3,no,proper_hepatic).

%%%% 4: right hepatic branches from left gastric
model(2,4,noname1,common_hepatic).
model(2,4,left_gastric,right_hepatic).
model(2,4,common_hepatic,gastroduodenal).
model(2,4,common_hepatic,left_hepatic).
%%%% hepatic

%%%% renal
model(3,1,aorta,left_renal).

model(3,2,aorta,left_renal).
model(3,2,aorta,accessory_left_renal).

model(4,1,aorta,right_renal).

model(4,2,aorta,right_renal).
model(4,2,aorta,accessory_right_renal).
%%%% renal

model(5,1,aorta,left_intercostal_1).
model(6,1,aorta,left_intercostal_2).
model(7,1,aorta,right_intercostal_1).
model(8,1,aorta,right_intercostal_2).

model(ID,Case) :- model(ID,Case,_,_).
model(ID)      :- model(ID,_,_,_).

%%%% Impose choosen models (only if related labels are assigned)
%%%% given the a generated model model_gen(ID,V) and a A->B arc --> edge_t_strict(A,B) is imposed ( no other labels on the path!)
%%%% given the a generated model model_gen(ID,V) and a aorta->B arc --> edge(A,B) is imposed (direct branching from aorta)
%%%% given the two generated model model_gen(ID1,V1) model_gen(ID2,V2) and A->B A-->C arcs
%%%%    --> (already imposed edge_t(A,B) and edge_t(A,C), B!=C,) edge(D,B), edge(D,C), no edge_t(B,C) e no edge_t(C,B) === require direct siblings

confidence_rules(anatomy,model(ID,V,aorta,N2)) :-
			model_gen(ID,V),
			model(ID,V,aorta,N2),
			artery(ID2,_,_,_,_,_,_,_,_,_,_,N2),
			edge(aorta,ID2).
confidence_rules(anatomy,model(ID,V,no,N2)) :- %%%% this label N2 cant appear
			model_gen(ID,V),
			model(ID,V,no,N2),
			not artery(_,_,_,_,_,_,_,_,_,_,_,N2).
confidence_rules(anatomy,model(ID,V,N1,N2)) :-
			model_gen(ID,V),
			model(ID,V,N1,N2),N1 != aorta, N1 != no,
			artery(ID1,_,_,_,_,_,_,_,_,_,_,N1),
			artery(ID2,_,_,_,_,_,_,_,_,_,_,N2),
			edge_t(ID1,ID2).
			%%%%	edge_t_strict(ID1,ID2).

%%%% every rule in the model must be applied if labels N1 or N2 are used
:- model_gen(ID,V), model(ID,V,N1,N2),
   artery(_,_,_,_,_,_,_,_,_,_,_,N1),
   not confidence_rules(anatomy,model(ID,V,N1,N2)).

:- model_gen(ID,V), model(ID,V,N1,N2),
   artery(_,_,_,_,_,_,_,_,_,_,_,N2),
   not confidence_rules(anatomy,model(ID,V,N1,N2)).

%Definito come unione di due modelli che hanno la prima arteria (N1) in comune
confidence_rules(anatomy,model(ID1,V1,N1,N2,ID2,V2,N1,N3,sibling)) :-
			model_gen(ID1,V1),
			model_gen(ID2,V2),
			model(ID1,V1,N1,N2),
			model(ID2,V2,N1,N3),
			N1 != aorta, N1 != no, N2 < N3,
			artery(IDa2,_,_,_,_,_,_,_,_,_,_,N2),
			artery(IDa3,_,_,_,_,_,_,_,_,_,_,N3),
			not edge_t(IDa3,IDa2),
			not edge_t(IDa2,IDa3),
			edge(IDa4,IDa3),
			edge(IDa4,IDa2).

%%%% siblings must be enforced if labels involved are present
:- model_gen(ID1,V1),
   model_gen(ID2,V2),
   model(ID1,V1,N1,N2),
   model(ID2,V2,N1,N3),
   N1 != aorta, N1 != no, N2 < N3, %%% avoid same rule
   artery(_,_,_,_,_,_,_,_,_,_,_,N1),
   artery(_,_,_,_,_,_,_,_,_,_,_,N2),
   artery(_,_,_,_,_,_,_,_,_,_,_,N3),
   not confidence_rules(anatomy,model(ID1,V1,N1,N2,ID2,V2,N1,N3,sibling)).

%%%%%%% Hard constraints (flagged confidence rules):

%% If celiac trunk and sma are identified, Z order must be preserved
:- not confidence_rules(anatomy,pair(N1,N2)), N1 = celiac_trunk, N2 = superior_mesenteric,
       artery(ID1,_,_,_,_,_,Z1,_,_,_,_,N1), artery(ID2,_,_,_,_,_,Z2,_,_,_,_,N2).

confidence_rules(anatomy,pair(N1,N2)) :- N1 = celiac_trunk, N2 = superior_mesenteric,
                                         artery(ID1,_,_,_,_,_,Z1,_,_,_,_,N1), artery(ID2,_,_,_,_,_,Z2,_,_,_,_,N2), Z1 < Z2.

%% CELIAC TRUNK
confidence_rules(N,12) :- N = celiac_trunk, artery(_,_,_,_,_,_,_,_,_,_,A,N), quadrant_1(A).
confidence_rules(N,15) :- N = celiac_trunk, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_l(R).
confidence_rules(N,1)  :- N = celiac_trunk, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_big(R).
confidence_rules(N,13) :- N = celiac_trunk, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_m(R).
confidence_rules(N,2)  :- N = celiac_trunk, artery(ID1,_,_,_,_,_,_,_,_,_,_,N), artery(ID2,_,_,_,_,_,_,_,_,_,_,left_gastric), edge(ID1,ID2).
confidence_rules(N,21) :- N = celiac_trunk, artery(ID1,_,_,_,_,_,_,_,_,_,_,N), artery(ID2,_,_,_,_,_,_,_,_,_,_,_), artery(ID3,_,_,_,_,_,_,_,_,_,_,left_gastric), edge(ID1,ID2), edge(ID2,ID3). %%% intermedio
confidence_rules(N,5)  :- N = celiac_trunk, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,superior_mesenteric), height_less(H1+10,H2).
confidence_rules(N,6)  :- N = celiac_trunk, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,superior_mesenteric), height_less(H1,H2).
confidence_rules(N,7)  :- N = celiac_trunk, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,right_renal), height_greater(H1,H2+10).
confidence_rules(N,8)  :- N = celiac_trunk, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,right_renal), height_greater(H1,H2).
confidence_rules(N,9)  :- N = celiac_trunk, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,left_renal), height_greater(H1,H2+10).
confidence_rules(N,10) :- N = celiac_trunk, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,left_renal), height_greater(H1,H2).

%% LEFT GASTRIC
confidence_rules(N,2) :- N = left_gastric, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_s(R).
confidence_rules(N,3) :- N = left_gastric, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_m(R).
confidence_rules(N,4) :- N = left_gastric, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_5_10(R).
confidence_rules(N,5) :- N = left_gastric, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_10_15(R).
confidence_rules(N,6) :- N = left_gastric, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_15_20(R).
confidence_rules(N,1) :- N = left_gastric, artery(ID1,_,_,_,_,_,_,_,_,_,_,N), artery(ID2,_,_,_,_,_,_,_,_,_,_,celiac_trunk), edge(ID1,ID2).
confidence_rules(N,7) :- N = left_gastric, artery(ID1,_,_,_,_,_,Z1,_,_,_,_,N), artery(ID2,_,_,_,_,_,Z2,_,_,_,_,splenic), Z1<Z2.

%% SPLENIC
confidence_rules(N,2)  :- N = splenic, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_l(R).

confidence_rules(N,3)  :- N = splenic, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_15_20(R).
confidence_rules(N,4)  :- N = splenic, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_20_25(R).
confidence_rules(N,0)  :- N = splenic, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_25_30(R).
confidence_rules(N1,1) :- N1 = splenic, N2 = celiac_trunk, artery(ID1,_,_,_,_,_,_,_,_,_,_,N1), artery(ID2,_,_,_,X2,_,_,_,_,_,_,N2), %%% almeno un vaso foglia della splenica e' a sinistra del celiac trunk di almeno 50mm
		       	          edge_t(ID1,ID3), not edge(ID3,ID4), id(ID4),
		       	          artery(ID3,_,_,_,X3,_,_,_,_,_,_), X3 > X2+50.

%:- not confidence_rules(N1,1), N1 = splenic, N2 = celiac_trunk,
%                      artery(ID1,_,_,_,X1,_,_,_,_,_,_,N1), artery(ID2,_,_,_,X2,_,_,_,_,_,_,N2).

confidence_rules(N,5) :- N = splenic, artery(ID1,_,_,_,_,_,Z1,_,_,_,_,N), artery(ID2,_,_,_,_,_,Z2,_,_,_,_,left_gastric), Z1>Z2.
confidence_rules(N,6) :- N = splenic, artery(ID1,_,_,_,X1,_,_,_,_,_,_,N), artery(ID2,_,_,_,X2,_,_,_,_,_,_,common_hepatic), X1>X2.
confidence_rules(N,7) :- N = splenic, artery(ID1,_,_,_,X1,_,_,_,_,_,_,N), artery(ID2,_,_,_,X2,_,_,_,_,_,_,left_hepatic), X1>X2.
confidence_rules(N,8) :- N = splenic, artery(ID1,_,_,_,X1,_,_,_,_,_,_,N), artery(ID2,_,_,_,X2,_,_,_,_,_,_,right_hepatic), X1>X2.

%% HEPATIC
%confidence_rules(N,3)  :- N = common_hepatic, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_l(R).
%confidence_rules(N,0)  :- N = common_hepatic, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_7(R).

%% DORSAL PANCREATIC
confidence_rules(N,3) :- N = dorsal_pancreatic, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_l(R).
%confidence_rules(N,0) :- N = dorsal_pancreatic, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_7(R).
confidence_rules(N,1) :- N = dorsal_pancreatic, artery(ID1,_,_,_,_,_,_,_,_,_,_,N), artery(ID2,_,_,_,_,_,_,_,_,_,_,common_hepatic), edge_t(ID2,ID1). %%% esce da common hepatic

% An example of verification of 0 exiting edges (can be done also for entering ones)
%confidence_rules(N,2) :- N = dorsal_pancreatic, K = #count {ID2: edge(ID1,ID2)}, K = 0, artery(ID1,_,_,_,_,_,_,_,_,_,_,N).

%% SUPERIOR MESENTERIC
confidence_rules(N,8) :- N = superior_mesenteric, artery(_,R,_,_,_,_,_,_,_,_,A,N), quadrant_1(A), radius_l(R).
%confidence_rules(N,0) :- N = superior_mesenteric, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_2(A).
confidence_rules(N,1) :- N = superior_mesenteric, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_20_25(R).
confidence_rules(N,5) :- N = superior_mesenteric, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,left_renal), height_greater(H1,H2).
confidence_rules(N,6) :- N = superior_mesenteric, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,right_renal), height_greater(H1,H2).
%confidence_rules(N,7) :- N = superior_mesenteric, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,inf_mesenteric), height_greater(H1,H2+20).
confidence_rules(N,9) :- N = superior_mesenteric, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H2,H1).
confidence_rules(N,10) :- N = superior_mesenteric, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H2+10,H1).

%% LEFT RENAL
confidence_rules(N,7) :- N = left_renal, artery(_,R,_,_,_,_,_,_,_,_,A,N), quadrant_4(A), radius_l(R).
confidence_rules(N,0) :- N = left_renal, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_8(A).
confidence_rules(N,1) :- N = left_renal, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_20_25(R).
confidence_rules(N,1) :- N = left_renal, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_15_20(R).
confidence_rules(N,2) :- N = left_renal, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2+10).
confidence_rules(N,3) :- N = left_renal, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2).
confidence_rules(N,4) :- N = left_renal, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,superior_mesenteric), height_less(H1,H2).
confidence_rules(N,6) :- N = left_renal, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,right_renal), height_less(H1,H2+10).
confidence_rules(N,8) :- N = left_renal, artery(ID1,_,_,_,X1,_,_,_,_,_,_,N), artery(ID2,_,_,_,X2,_,_,_,_,_,_,right_renal), X1>X2.

%% RIGHT RENAL
confidence_rules(N,7) :- N = right_renal, artery(_,R,_,_,_,_,_,_,_,_,A,N), quadrant_2(A), radius_l(R).
confidence_rules(N,0) :- N = right_renal, artery(_,_,_,_,_,_,_,_,_,_,A,N), semiquadrant_4(A).
confidence_rules(N,1) :- N = right_renal, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_15_20(R).
confidence_rules(N,1) :- N = right_renal, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_20_25(R).
confidence_rules(N,2) :- N = right_renal, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2+10).
confidence_rules(N,3) :- N = right_renal, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2).
confidence_rules(N,4) :- N = right_renal, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,superior_mesenteric), height_less(H1,H2).
confidence_rules(N,6) :- N = right_renal, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,left_renal), height_greater(H1+10,H2).
confidence_rules(N,8) :- N = right_renal, artery(ID1,_,_,_,X1,_,_,_,_,_,_,N), artery(ID2,_,_,_,X2,_,_,_,_,_,_,left_renal), X1<X2.

%% accessory LEFT RENAL
confidence_rules(N,5) :- N = accessory_left_renal, artery(_,R,_,_,_,_,_,_,_,_,A,N), quadrant_4(A), radius_s(R).
confidence_rules(N,0) :- N = accessory_left_renal, artery(_,_,_,_,_,_,_,_,_,_,A,N), quadrant_4(A).
confidence_rules(N,1) :- N = accessory_left_renal, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_5_10(R).
confidence_rules(N,1) :- N = accessory_left_renal, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_10_15(R).
confidence_rules(N,2) :- N = accessory_left_renal, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2).
confidence_rules(N,4) :- N = accessory_left_renal, K = #count {ID2: edge(ID1,ID2)}, K = 0, out_artery(ID1,N).

%% accessory RIGHT RENAL
confidence_rules(N,6) :- N = accessory_right_renal, artery(_,R,_,_,_,_,_,_,_,_,A,N), quadrant_2(A), radius_s(R).
confidence_rules(N,1) :- N = accessory_right_renal, artery(_,_,_,_,_,_,_,_,_,_,A,N), quadrant_2(A).
confidence_rules(N,2) :- N = accessory_right_renal, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_5_10(R).
confidence_rules(N,2) :- N = accessory_right_renal, artery(_,R,_,_,_,_,_,_,_,_,_,N), radius_10_15(R).
confidence_rules(N,3) :- N = accessory_right_renal, artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_,celiac_trunk), height_less(H1,H2).
confidence_rules(N,5) :- N = accessory_right_renal, K = #count {ID2: edge(ID1,ID2)}, K = 0, out_artery(ID1,N).

%% intercostal
confidence_rules(N,1) :- N = left_intercostal_1, artery(_,R,_,_,_,_,_,_,_,_,A,N), quadrant_3(A), edge(aorta,N), radius_10_15(R).
confidence_rules(N,2) :- N = left_intercostal_1, artery(_,R,_,_,_,_,_,_,_,_,A,N), quadrant_3(A), edge(aorta,N), radius_5_10(R).

confidence_rules(N,1) :- N = right_intercostal_1, artery(_,R,_,_,_,_,_,_,_,_,A,N), quadrant_3(A), edge(aorta,N), radius_10_15(R).
confidence_rules(N,2) :- N = right_intercostal_1, artery(_,R,_,_,_,_,_,_,_,_,A,N), quadrant_3(A), edge(aorta,N), radius_5_10(R).

confidence_rules(pair(N1,N2),1) :- N1 = left_intercostal_1, N2 = right_intercostal_1,
				                   artery(ID1,_,_,_,X1,_,Z1,_,_,_,_,N1),
				                   artery(ID2,_,_,_,X2,_,Z2,_,_,_,_,N2), X1 > X2, Z2 < Z1+5, Z2 > Z1-5.

confidence_rules(N,1) :- N = left_intercostal_2, artery(_,R,_,_,_,_,_,_,_,_,A,N), quadrant_3(A), edge(aorta,N), radius_10_15(R).
confidence_rules(N,2) :- N = left_intercostal_2, artery(_,R,_,_,_,_,_,_,_,_,A,N), quadrant_3(A), edge(aorta,N), radius_5_10(R).

confidence_rules(N,1) :- N = right_intercostal_2, artery(_,R,_,_,_,_,_,_,_,_,A,N), quadrant_3(A), edge(aorta,N), radius_10_15(R).
confidence_rules(N,2) :- N = right_intercostal_2, artery(_,R,_,_,_,_,_,_,_,_,A,N), quadrant_3(A), edge(aorta,N), radius_5_10(R).

confidence_rules(pair(N1,N2),1) :- N1 = left_intercostal_2, N2 = right_intercostal_2,
				                   artery(ID1,_,_,_,X1,_,Z1,_,_,_,_,N1),
				                   artery(ID2,_,_,_,X2,_,Z2,_,_,_,_,N2), X1>X2, Z2<Z1+5, Z2>Z1-5.

confidence_rules(pair(N1,N2),1) :- N1 = left_intercostal_1, N2 = left_intercostal_2,
				                   artery(ID1,_,_,_,X1,_,Z1,_,_,_,_,N1),
				                   artery(ID2,_,_,_,X2,_,Z2,_,_,_,_,N2), Z1<Z2.

%%% Constraints
% Structural
:- artery(ID1,_,_,_,_,_,_,_,_,_,_,N1), artery(ID2,_,_,_,_,_,_,_,_,_,_,N2), ID1 != ID2, N1 == N2.
:- artery(ID1,_,_,_,_,_,_,_,_,_,_,N1), artery(ID2,_,_,_,_,_,_,_,_,_,_,N2), ID1 == ID2, N1 != N2.
:- out_artery(ID1,N1), out_artery(ID2,N2), ID1 != ID2, N1 == N2.
:- out_artery(ID1,N1), out_artery(ID2,N2), ID1 == ID2, N1 != N2.

%%% Solution Generation
0 {artery_gen(ID,N) : name(N)} 1   :- id(ID).
1 {model_gen(ID,N): model(ID,N)} 1 :- model(ID).

% Optimization
rule_count(K) :- K = 10*K1, K1 = #count {R: confidence_rules(anatomy,R)}.
rule_count(K) :- K = #count {N,R: confidence_rules(N,R), N != anatomy}.
#maximize {K:rule_count(K)}.

edge_out(aorta,N2) :- edge(aorta,ID2), out_artery(ID2, N2), id(ID2), name(N2).
edge_out(N1,N2)    :- edge(ID1,ID2), out_artery(ID1, N1), out_artery(ID2, N2), id(ID1), name(N1), id(ID2), name(N2).

% Remove to optimize, added to clean output
cleaned_cr(N,ID) :- N != anatomy, name(N), id(ID), confidence_rules(N,ID).

% Satisfiability (just to get unsatisfiable when 0 arteries are found -- remove for optimization)
%:- J = #count {ID: out_artery(ID,_)}, J == 0.

%#show artery/11.
%#show artery/12.
%#show model/2.
%#show model/4.
#show model_gen/2.
%#show test/4.
%#show name/1.
%#show params_artery/11.

% For Graphs
#show edge_out/2.

#show out_artery/2.
%#show confidence_rules/2.
#show cleaned_cr/2.