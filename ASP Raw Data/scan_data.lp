% ********** FACTS **********


%etichetta(0,'celiac trunk').
%etichetta(1,'superior mesenteric artery').
%etichetta(3,'left gastric artery').
%etichetta(4,'splenic artery').
%etichetta(5,'dorsal pancreatic artery').
%etichetta(7,'3rd right lumbar artery').
%etichetta(8,'3rd left lumbar artery').
%etichetta(9,'right renal mysterious artery').
%etichetta(11,'hepatic artery').
%etichetta(14,'inferior mesenteric artery').
%etichetta(26,'4th right lumbar artery').
%etichetta(27,'4th left lumbar artery').
%etichetta(31,'2nd left lumbar artery').
%etichetta(33,'right renal artery').
%etichetta(36,'2nd right lumbar artery').
%etichetta(37,'1st right lumbar artery').
%etichetta(38,'left renal artery').
%etichetta(39,'left renal mysterious artery').
%etichetta(44,'1st left lumbar artery').


%main_artery_in(ID, Z (increasing towards the head), angle (degrees), radius (medium in voxelx10 to remove floating point))
main_artery_in(0,  378, 62,  31).
main_artery_in(1,  351, 79,  37).
main_artery_in(6,  261, 335, 20).
main_artery_in(9,  295, 96,  28).
main_artery_in(14, 270, 60,  34).
main_artery_in(23, 232, 311, 39).
main_artery_in(26, 233, 255, 40).
main_artery_in(31, 289, 288, 30).
main_artery_in(32, 329, 300, 32).
main_artery_in(33, 339, 153, 28).
main_artery_in(36, 287, 250, 29).
main_artery_in(37, 327, 243, 25).
main_artery_in(38, 333, 347, 38).
main_artery_in(39, 361, 324, 29).
main_artery_in(44, 329, 300, 28).

%bif_artery_in(ID, radius (medium in voxelx10 to remove floating point))
bif_artery_in(2,  32).
bif_artery_in(3,  33).
bif_artery_in(4,  34).
bif_artery_in(5,  34).
bif_artery_in(7,  20).
bif_artery_in(8,  21).
bif_artery_in(10, 35).
bif_artery_in(11, 35).
bif_artery_in(12, 31).
bif_artery_in(13, 31).
bif_artery_in(15, 28).
bif_artery_in(16, 28).
bif_artery_in(17, 17).
bif_artery_in(18, 17).
bif_artery_in(19, 20).
bif_artery_in(20, 20).
bif_artery_in(21, 25).
bif_artery_in(22, 25).
bif_artery_in(24, 17).
bif_artery_in(25, 17).
bif_artery_in(27, 23).
bif_artery_in(28, 38).
bif_artery_in(29, 27).
bif_artery_in(30, 27).
bif_artery_in(34, 25).
bif_artery_in(35, 25).
bif_artery_in(40, 25).
bif_artery_in(41, 25).
bif_artery_in(42, 26).
bif_artery_in(43, 25).

%edge -- code -> name of ending node
edge(aorta,0).
edge(aorta,1).
edge(aorta,6).
edge(aorta,9).
edge(aorta,14).
edge(aorta,23).
edge(aorta,26).
edge(aorta,31).
edge(aorta,32).
edge(aorta,33).
edge(aorta,36).
edge(aorta,37).
edge(aorta,38).
edge(aorta,39).
edge(aorta,44).

edge(0,2).
edge(0,3).
edge(1,10).
edge(1,11).
edge(2,4).
edge(2,5).
edge(4,42).
edge(4,43).
edge(6,7).
edge(6,8).
edge(10,12).
edge(10,13).
edge(13,15).
edge(13,16).
edge(15,29).
edge(15,30).
edge(20,17).
edge(20,18).
edge(21,24).
edge(21,25).
edge(22,19).
edge(22,20).
edge(23,27).
edge(23,28).
edge(30,21).
edge(30,22).
edge(33,34).
edge(33,35).
edge(38,40).
edge(38,41).
