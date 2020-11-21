Artery with ID: [0] and Name: [celiac_trunk].
	Confidence Rule with ID: [0] and Name: [celiac_trunk].
		Fact: celiac_trunk is a main artery.
		Rule: celiac_trunk has angle between 45 and 90 degrees.

	Confidence Rule with ID: [1] and Name: [celiac_trunk].
		Fact: celiac_trunk is a main artery.
		Rule: celiac_trunk has radius between 30 and 35 voxels.

	Confidence Rule with ID: [2] and Name: [celiac_trunk].
		Fact: celiac_trunk is a main artery.
		Fact: aorta is a main artery.
		Rule: aorta is connected to celiac_trunk

	Confidence Rule with ID: [3] and Name: [celiac_trunk].
		Fact: celiac_trunk is a main artery.
		Fact: gastricL is a biforcation artery.
		Rule: celiac_trunk is connected to gastricL

	Confidence Rule with ID: [4] and Name: [celiac_trunk].
		Fact: celiac_trunk is a main artery.
		Fact: gastricL is a biforcation artery.
		Rule: celiac_trunk is connected to gastricL

	Confidence Rule with ID: [7] and Name: [celiac_trunk].
		Fact: celiac_trunk is a main artery.
		Fact: sup_mesenteric is a main artery.
		Rule: celiac_trunk heigth+10 is greater than sup_mesenteric heigth.

	Confidence Rule with ID: [12] and Name: [celiac_trunk].
		Fact: celiac_trunk is a main artery.
		Fact: renalR is a main artery.
		Rule: celiac_trunk heigth is greater than renalR heigth.


Artery with ID: [1] and Name: [sup_mesenteric].
	Confidence Rule with ID: [0] and Name: [sup_mesenteric].
		Fact: sup_mesenteric is a main artery.
		Rule: sup_mesenteric has angle between 45 and 90 degrees.

	Confidence Rule with ID: [1] and Name: [sup_mesenteric].
		Fact: sup_mesenteric is a main artery.
		Rule: sup_mesenteric has radius between 35 and 40 voxels.

	Confidence Rule with ID: [2] and Name: [sup_mesenteric].
		Fact: sup_mesenteric is a main artery.
		Fact: aorta is a main artery.
		Rule: aorta is connected to sup_mesenteric

	Confidence Rule with ID: [3] and Name: [sup_mesenteric].
		Fact: sup_mesenteric is a main artery.
		Fact: hepatic is a biforcation artery.
		Rule: sup_mesenteric is connected to hepatic

	Confidence Rule with ID: [5] and Name: [sup_mesenteric].
		Fact: sup_mesenteric is a main artery.
		Fact: celiac_trunk is a main artery.
		Rule: sup_mesenteric heigth is less than sup_mesenteric heigth+10.

	Confidence Rule with ID: [8] and Name: [sup_mesenteric].
		Fact: sup_mesenteric is a main artery.
		Fact: renalR is a main artery.
		Rule: sup_mesenteric heigth is greater than renalR heigth.


Artery with ID: [2] and Name: [splenic].
	Confidence Rule with ID: [0] and Name: [splenic].
		Fact: splenic is a biforcation artery.
		Rule: splenic has radius between 30 and 35 voxels.


Artery with ID: [3] and Name: [gastricL].
	Confidence Rule with ID: [0] and Name: [gastricL].
		Fact: gastricL is a biforcation artery.
		Rule: gastricL has radius between 30 and 35 voxels.

	Confidence Rule with ID: [1] and Name: [gastricL].
		Fact: gastricL is a biforcation artery.
		Fact: celiac_trunk is a main artery.
		Rule: celiac_trunk is connected to gastricL


Artery with ID: [5] and Name: [dorsal_pancreatic].
	Confidence Rule with ID: [0] and Name: [dorsal_pancreatic].
		Fact: dorsal_pancreatic is a biforcation artery.
		Rule: dorsal_pancreatic has radius between 30 and 35 voxels.

	Confidence Rule with ID: [1] and Name: [dorsal_pancreatic].
		Rule: dorsal_pancreatic has:  K = #count {ID2: edge(ID1,ID2)} K = 0 bif_artery(ID1,_,N).


Artery with ID: [9] and Name: [renalR_mysterious].
	Confidence Rule with ID: [1] and Name: [renalR_mysterious].
		Fact: renalR_mysterious is a main artery.
		Rule: renalR_mysterious has angle between 90 and 135 degrees.

	Confidence Rule with ID: [2] and Name: [renalR_mysterious].
		Fact: renalR_mysterious is a main artery.
		Rule: renalR_mysterious has radius between 25 and 30 voxels.

	Confidence Rule with ID: [3] and Name: [renalR_mysterious].
		Fact: renalR_mysterious is a main artery.
		Fact: aorta is a main artery.
		Rule: aorta is connected to renalR_mysterious

	Confidence Rule with ID: [4] and Name: [renalR_mysterious].
		Fact: renalR_mysterious is a main artery.
		Fact: celiac_trunk is a main artery.
		Rule: renalR_mysterious heigth is less than celiac_trunk heigth.

	Confidence Rule with ID: [6] and Name: [renalR_mysterious].
		Rule: renalR_mysterious has:  K = #count {ID2: edge(ID1,ID2)} K = 0 artery(ID1,N).


Artery with ID: [10] and Name: [hepatic].
	Confidence Rule with ID: [0] and Name: [hepatic].
		Fact: hepatic is a biforcation artery.
		Rule: hepatic has radius between 30 and 35 voxels.

	Confidence Rule with ID: [2] and Name: [hepatic].
		Fact: hepatic is a biforcation artery.
		Fact: sup_mesenteric is a main artery.
		Rule: sup_mesenteric is connected to hepatic


Artery with ID: [14] and Name: [inf_mesenteric].
	Confidence Rule with ID: [0] and Name: [inf_mesenteric].
		Fact: inf_mesenteric is a main artery.
		Rule: inf_mesenteric has angle between 45 and 90 degrees.

	Confidence Rule with ID: [1] and Name: [inf_mesenteric].
		Fact: inf_mesenteric is a main artery.
		Rule: inf_mesenteric has radius between 30 and 35 voxels.

	Confidence Rule with ID: [2] and Name: [inf_mesenteric].
		Fact: inf_mesenteric is a main artery.
		Fact: aorta is a main artery.
		Rule: aorta is connected to inf_mesenteric

	Confidence Rule with ID: [3] and Name: [inf_mesenteric].
		Fact: inf_mesenteric is a main artery.
		Fact: celiac_trunk is a main artery.
		Rule: inf_mesenteric heigth is less than inf_mesenteric heigth+50.

	Confidence Rule with ID: [4] and Name: [inf_mesenteric].
		Fact: inf_mesenteric is a main artery.
		Fact: celiac_trunk is a main artery.
		Rule: inf_mesenteric heigth is less than inf_mesenteric heigth+20.

	Confidence Rule with ID: [5] and Name: [inf_mesenteric].
		Fact: inf_mesenteric is a main artery.
		Fact: renalL is a main artery.
		Rule: inf_mesenteric heigth is less than renalL heigth.

	Confidence Rule with ID: [7] and Name: [inf_mesenteric].
		Fact: inf_mesenteric is a main artery.
		Fact: sup_mesenteric is a main artery.
		Rule: inf_mesenteric heigth is less than inf_mesenteric heigth+50.

	Confidence Rule with ID: [8] and Name: [inf_mesenteric].
		Fact: inf_mesenteric is a main artery.
		Fact: sup_mesenteric is a main artery.
		Rule: inf_mesenteric heigth is less than inf_mesenteric heigth+20.


Artery with ID: [26] and Name: [lumbarR4].
	Confidence Rule with ID: [0] and Name: [lumbarR4].
		Fact: lumbarR4 is a main artery.
		Rule: lumbarR4 has angle between 225 and 270 degrees.

	Confidence Rule with ID: [3] and Name: [lumbarR4].
		Fact: lumbarR4 is a main artery.
		Fact: aorta is a main artery.
		Rule: aorta is connected to lumbarR4


Artery with ID: [31] and Name: [lumbarL3].
	Confidence Rule with ID: [0] and Name: [lumbarL3].
		Fact: lumbarL3 is a main artery.
		Rule: lumbarL3 has angle between 270 and 315 degrees.

	Confidence Rule with ID: [2] and Name: [lumbarL3].
		Fact: lumbarL3 is a main artery.
		Rule: lumbarL3 has radius between 25 and 30 voxels.

	Confidence Rule with ID: [3] and Name: [lumbarL3].
		Fact: lumbarL3 is a main artery.
		Fact: aorta is a main artery.
		Rule: aorta is connected to lumbarL3

	Confidence Rule with ID: [4] and Name: [lumbarL3].
		Fact: lumbarL3 is a main artery.
		Fact: lumbarL1 is a main artery.
		Rule: lumbarL3 heigth is less than lumbarL1 heigth.

	Confidence Rule with ID: [11] and Name: [lumbarL3].
		Fact: lumbarL3 is a main artery.
		Fact: renalL is a main artery.
		Rule: lumbarL3 heigth is less than renalL heigth.

	Confidence Rule with ID: [12] and Name: [lumbarL3].
		Fact: lumbarL3 is a main artery.
		Fact: celiac_trunk is a main artery.
		Rule: lumbarL3 heigth is less than celiac_trunk heigth.

	Confidence Rule with ID: [13] and Name: [lumbarL3].
		Fact: lumbarL3 is a main artery.
		Fact: lumbarR3 is a main artery.
		Rule: lumbarL3 heigth is less than lumbarL3 heigth+5.

	Confidence Rule with ID: [14] and Name: [lumbarL3].
		Fact: lumbarL3 is a main artery.
		Fact: lumbarR3 is a main artery.
		Rule: lumbarL3 heigth+5 is greater than lumbarR3 heigth.


Artery with ID: [32] and Name: [lumbarL1].
	Confidence Rule with ID: [0] and Name: [lumbarL1].
		Fact: lumbarL1 is a main artery.
		Rule: lumbarL1 has angle between 270 and 315 degrees.

	Confidence Rule with ID: [3] and Name: [lumbarL1].
		Fact: lumbarL1 is a main artery.
		Fact: aorta is a main artery.
		Rule: aorta is connected to lumbarL1

	Confidence Rule with ID: [4] and Name: [lumbarL1].
		Fact: lumbarL1 is a main artery.
		Fact: lumbarL2 is a main artery.
		Rule: lumbarL1 heigth is greater than lumbarL2 heigth.

	Confidence Rule with ID: [5] and Name: [lumbarL1].
		Fact: lumbarL1 is a main artery.
		Fact: lumbarL3 is a main artery.
		Rule: lumbarL1 heigth is greater than lumbarL3 heigth.

	Confidence Rule with ID: [7] and Name: [lumbarL1].
		Fact: lumbarL1 is a main artery.
		Fact: lumbarR2 is a main artery.
		Rule: lumbarL1 heigth is greater than lumbarR2 heigth.

	Confidence Rule with ID: [8] and Name: [lumbarL1].
		Fact: lumbarL1 is a main artery.
		Fact: lumbarR3 is a main artery.
		Rule: lumbarL1 heigth is greater than lumbarR3 heigth.

	Confidence Rule with ID: [11] and Name: [lumbarL1].
		Fact: lumbarL1 is a main artery.
		Fact: renalL is a main artery.
		Rule: lumbarL1 heigth is less than renalL heigth.


Artery with ID: [33] and Name: [renalR].
	Confidence Rule with ID: [0] and Name: [renalR].
		Fact: renalR is a main artery.
		Rule: renalR has angle between 130 and 180 degrees.

	Confidence Rule with ID: [1] and Name: [renalR].
		Fact: renalR is a main artery.
		Rule: renalR has radius between 25 and 30 voxels.

	Confidence Rule with ID: [2] and Name: [renalR].
		Fact: renalR is a main artery.
		Fact: aorta is a main artery.
		Rule: aorta is connected to renalR

	Confidence Rule with ID: [5] and Name: [renalR].
		Fact: renalR is a main artery.
		Fact: celiac_trunk is a main artery.
		Rule: renalR heigth is less than renalR heigth+10.

	Confidence Rule with ID: [6] and Name: [renalR].
		Fact: renalR is a main artery.
		Fact: celiac_trunk is a main artery.
		Rule: renalR heigth is less than celiac_trunk heigth.

	Confidence Rule with ID: [7] and Name: [renalR].
		Fact: renalR is a main artery.
		Fact: sup_mesenteric is a main artery.
		Rule: renalR heigth is less than sup_mesenteric heigth.


Artery with ID: [36] and Name: [lumbarR3].
	Confidence Rule with ID: [0] and Name: [lumbarR3].
		Fact: lumbarR3 is a main artery.
		Rule: lumbarR3 has angle between 225 and 270 degrees.

	Confidence Rule with ID: [2] and Name: [lumbarR3].
		Fact: lumbarR3 is a main artery.
		Rule: lumbarR3 has radius between 25 and 30 voxels.

	Confidence Rule with ID: [3] and Name: [lumbarR3].
		Fact: lumbarR3 is a main artery.
		Fact: aorta is a main artery.
		Rule: aorta is connected to lumbarR3

	Confidence Rule with ID: [4] and Name: [lumbarR3].
		Fact: lumbarR3 is a main artery.
		Fact: lumbarL1 is a main artery.
		Rule: lumbarR3 heigth is less than lumbarL1 heigth.

	Confidence Rule with ID: [5] and Name: [lumbarR3].
		Fact: lumbarR3 is a main artery.
		Fact: lumbarL3 is a main artery.
		Rule: lumbarR3 heigth is less than lumbarL3 heigth.

	Confidence Rule with ID: [11] and Name: [lumbarR3].
		Fact: lumbarR3 is a main artery.
		Fact: renalL is a main artery.
		Rule: lumbarR3 heigth is less than renalL heigth.

	Confidence Rule with ID: [12] and Name: [lumbarR3].
		Fact: lumbarR3 is a main artery.
		Fact: celiac_trunk is a main artery.
		Rule: lumbarR3 heigth is less than celiac_trunk heigth.

	Confidence Rule with ID: [13] and Name: [lumbarR3].
		Fact: lumbarR3 is a main artery.
		Fact: lumbarL3 is a main artery.
		Rule: lumbarR3 heigth is less than lumbarR3 heigth+5.

	Confidence Rule with ID: [14] and Name: [lumbarR3].
		Fact: lumbarR3 is a main artery.
		Fact: lumbarL3 is a main artery.
		Rule: lumbarR3 heigth+5 is greater than lumbarL3 heigth.


Artery with ID: [37] and Name: [lumbarR2].
	Confidence Rule with ID: [0] and Name: [lumbarR2].
		Fact: lumbarR2 is a main artery.
		Rule: lumbarR2 has angle between 225 and 270 degrees.

	Confidence Rule with ID: [3] and Name: [lumbarR2].
		Fact: lumbarR2 is a main artery.
		Fact: aorta is a main artery.
		Rule: aorta is connected to lumbarR2

	Confidence Rule with ID: [4] and Name: [lumbarR2].
		Fact: lumbarR2 is a main artery.
		Fact: lumbarL1 is a main artery.
		Rule: lumbarR2 heigth is less than lumbarL1 heigth.

	Confidence Rule with ID: [10] and Name: [lumbarR2].
		Fact: lumbarR2 is a main artery.
		Fact: renalR is a main artery.
		Rule: lumbarR2 heigth is less than renalR heigth.

	Confidence Rule with ID: [11] and Name: [lumbarR2].
		Fact: lumbarR2 is a main artery.
		Fact: renalL is a main artery.
		Rule: lumbarR2 heigth is less than renalL heigth.

	Confidence Rule with ID: [12] and Name: [lumbarR2].
		Fact: lumbarR2 is a main artery.
		Fact: celiac_trunk is a main artery.
		Rule: lumbarR2 heigth is less than celiac_trunk heigth.

	Confidence Rule with ID: [13] and Name: [lumbarR2].
		Fact: lumbarR2 is a main artery.
		Fact: lumbarL2 is a main artery.
		Rule: lumbarR2 heigth is less than lumbarR2 heigth+5.

	Confidence Rule with ID: [14] and Name: [lumbarR2].
		Fact: lumbarR2 is a main artery.
		Fact: lumbarL2 is a main artery.
		Rule: lumbarR2 heigth+5 is greater than lumbarL2 heigth.


Artery with ID: [38] and Name: [renalL].
	Confidence Rule with ID: [0] and Name: [renalL].
		Fact: renalL is a main artery.
		Rule: renalL has angle between 315 and 360 degrees.

	Confidence Rule with ID: [1] and Name: [renalL].
		Fact: renalL is a main artery.
		Rule: renalL has radius between 35 and 40 voxels.

	Confidence Rule with ID: [2] and Name: [renalL].
		Fact: renalL is a main artery.
		Fact: aorta is a main artery.
		Rule: aorta is connected to renalL

	Confidence Rule with ID: [3] and Name: [renalL].
		Fact: renalL is a main artery.
		Fact: celiac_trunk is a main artery.
		Rule: renalL heigth is less than renalL heigth+10.

	Confidence Rule with ID: [7] and Name: [renalL].
		Fact: renalL is a main artery.
		Fact: renalR is a main artery.
		Rule: renalL heigth is less than renalL heigth+10.


Artery with ID: [39] and Name: [renalL_mysterious].
	Confidence Rule with ID: [0] and Name: [renalL_mysterious].
		Fact: renalL_mysterious is a main artery.
		Rule: renalL_mysterious has angle between 315 and 360 degrees.

	Confidence Rule with ID: [1] and Name: [renalL_mysterious].
		Fact: renalL_mysterious is a main artery.
		Rule: renalL_mysterious has radius between 25 and 30 voxels.

	Confidence Rule with ID: [2] and Name: [renalL_mysterious].
		Fact: renalL_mysterious is a main artery.
		Fact: aorta is a main artery.
		Rule: aorta is connected to renalL_mysterious

	Confidence Rule with ID: [3] and Name: [renalL_mysterious].
		Fact: renalL_mysterious is a main artery.
		Fact: celiac_trunk is a main artery.
		Rule: renalL_mysterious heigth is less than celiac_trunk heigth.

	Confidence Rule with ID: [5] and Name: [renalL_mysterious].
		Rule: renalL_mysterious has:  K = #count {ID2: edge(ID1,ID2)} K = 0 artery(ID1,N).


Artery with ID: [44] and Name: [lumbarL2].
	Confidence Rule with ID: [0] and Name: [lumbarL2].
		Fact: lumbarL2 is a main artery.
		Rule: lumbarL2 has angle between 270 and 315 degrees.

	Confidence Rule with ID: [2] and Name: [lumbarL2].
		Fact: lumbarL2 is a main artery.
		Rule: lumbarL2 has radius between 25 and 30 voxels.

	Confidence Rule with ID: [3] and Name: [lumbarL2].
		Fact: lumbarL2 is a main artery.
		Fact: aorta is a main artery.
		Rule: aorta is connected to lumbarL2

	Confidence Rule with ID: [4] and Name: [lumbarL2].
		Fact: lumbarL2 is a main artery.
		Fact: lumbarL1 is a main artery.
		Rule: lumbarL2 heigth is less than lumbarL1 heigth.

	Confidence Rule with ID: [11] and Name: [lumbarL2].
		Fact: lumbarL2 is a main artery.
		Fact: renalL is a main artery.
		Rule: lumbarL2 heigth is less than renalL heigth.

	Confidence Rule with ID: [12] and Name: [lumbarL2].
		Fact: lumbarL2 is a main artery.
		Fact: celiac_trunk is a main artery.
		Rule: lumbarL2 heigth is less than celiac_trunk heigth.

	Confidence Rule with ID: [13] and Name: [lumbarL2].
		Fact: lumbarL2 is a main artery.
		Fact: lumbarR2 is a main artery.
		Rule: lumbarL2 heigth is less than lumbarL2 heigth+5.

	Confidence Rule with ID: [14] and Name: [lumbarL2].
		Fact: lumbarL2 is a main artery.
		Fact: lumbarR2 is a main artery.
		Rule: lumbarL2 heigth+5 is greater than lumbarR2 heigth.


