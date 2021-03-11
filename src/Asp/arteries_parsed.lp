Model with ID: 0 and Variant: 1.
	Rule text: aorta is connected to celiac_trunk.

Model with ID: 3 and Variant: 2.
	Rule text: aorta is connected to left_renal.

Model with ID: 4 and Variant: 2.
	Rule text: aorta is connected to right_renal.

Model with ID: 5 and Variant: 1.
	Rule text: aorta is connected to left_intercostal_1.

Model with ID: 7 and Variant: 1.
	Rule text: aorta is connected to right_intercostal_1.

Model with ID: 6 and Variant: 1.
	Rule text: aorta is connected to left_intercostal_2.

Model with ID: 8 and Variant: 1.
	Rule text: aorta is connected to right_intercostal_2.

Model with ID: 1 and Variant: 1.
	Rule text: celiac_trunk is connected to left_gastric.

Model with ID: 2 and Variant: 1.
	Rule text: noname1 is connected to common_hepatic.

Artery with ID: 72 and Name: celiac_trunk.
	Confidence Rule with ID: 0 and Name: celiac_trunk.
	Rule text: celiac_trunk has angle between 45 and 90 degrees, or between 90 and 135 degrees.

	Confidence Rule with ID: 1 and Name: celiac_trunk.
	Rule text: celiac_trunk has radius greater than 20 voxels.

	Confidence Rule with ID: 2 and Name: celiac_trunk.
	Rule text: celiac_trunk has radius greater than 20 voxels.

	Confidence Rule with ID: 4 and Name: celiac_trunk.
	Rule text: celiac_trunk is connected to left_gastric.

	Confidence Rule with ID: 5 and Name: celiac_trunk.
	Rule text: celiac_trunk heigth+10 is less than superior_mesenteric heigth.

	Confidence Rule with ID: 6 and Name: celiac_trunk.
	Rule text: celiac_trunk heigth is less than superior_mesenteric heigth.

	Confidence Rule with ID: 11 and Name: celiac_trunk.
	Rule text: celiac_trunk is transitively connected to left_gastric.

Artery with ID: 6 and Name: noname1.


Artery with ID: 58 and Name: splenic.
	Confidence Rule with ID: 0 and Name: splenic.
	Rule text: splenic has radius greater than 20 voxels.

	Confidence Rule with ID: 2 and Name: splenic.
	Rule text: splenic has radius between 20 and 25 voxels.

	Confidence Rule with ID: 4 and Name: splenic.
	Rule text: splenic cog_z is greater than left_gastric cog_z.

	Confidence Rule with ID: 5 and Name: splenic.
	Rule text: splenic cog_x is greater than common_hepatic cog_x.

	Confidence Rule with ID: 6 and Name: splenic.
	Rule text: splenic cog_x is greater than left_hepatic cog_x.

	Confidence Rule with ID: 7 and Name: splenic.
	Rule text: splenic cog_x is greater than right_hepatic cog_x.

Artery with ID: 92 and Name: common_hepatic.


Artery with ID: 5 and Name: right_hepatic.


Artery with ID: 8 and Name: left_hepatic.


Artery with ID: 68 and Name: left_renal.
	Confidence Rule with ID: 0 and Name: left_renal.
	Rule text: left_renal has angle between 315 and 360 degrees, or between 0 and 45 degrees.

	Confidence Rule with ID: 1 and Name: left_renal.
	Rule text: left_renal has radius greater than 20 voxels.

	Confidence Rule with ID: 2 and Name: left_renal.
	Rule text: left_renal has angle between 315 and 360 degrees.

	Confidence Rule with ID: 3 and Name: left_renal.
	Rule text: left_renal has radius between 20 and 25 voxels.

	Confidence Rule with ID: 7 and Name: left_renal.
	Rule text: left_renal heigth is less than superior_mesenteric heigth.

	Confidence Rule with ID: 9 and Name: left_renal.
	Rule text: left_renal cog_x is greater than right_renal cog_x.

Artery with ID: 74 and Name: left_gastric.
	Confidence Rule with ID: 1 and Name: left_gastric.
	Rule text: left_gastric has radius between 10 and 20 voxels.

	Confidence Rule with ID: 3 and Name: left_gastric.
	Rule text: left_gastric has radius between 10 and 15 voxels.

	Confidence Rule with ID: 6 and Name: left_gastric.
	Rule text: left_gastric cog_z is less than splenic cog_z.

Artery with ID: 79 and Name: accessory_left_renal.
	Confidence Rule with ID: 0 and Name: accessory_left_renal.
	Rule text: accessory_left_renal has angle between 315 and 360 degrees, or between 0 and 45 degrees.

	Confidence Rule with ID: 1 and Name: accessory_left_renal.
	Rule text: accessory_left_renal has radius between 0 and 10 voxels.

	Confidence Rule with ID: 2 and Name: accessory_left_renal.
	Rule text: accessory_left_renal has angle between 315 and 360 degrees, or between 0 and 45 degrees.

	Confidence Rule with ID: 3 and Name: accessory_left_renal.
	Rule text: accessory_left_renal has radius between 5 and 10 voxels.

	Confidence Rule with ID: 6 and Name: accessory_left_renal.
	Rule text: accessory_left_renal has:  K = #count {ID2: edge(ID1,ID2)} K = 0 out_artery(ID1,N).

Artery with ID: 88 and Name: accessory_right_renal.
	Confidence Rule with ID: 4 and Name: accessory_right_renal.
	Rule text: accessory_right_renal has radius between 10 and 15 voxels.

	Confidence Rule with ID: 5 and Name: accessory_right_renal.
	Rule text: accessory_right_renal heigth is less than celiac_trunk heigth.

	Confidence Rule with ID: 6 and Name: accessory_right_renal.
	Rule text: accessory_right_renal has:  K = #count {ID2: edge(ID1,ID2)} K = 0 out_artery(ID1,N).

Artery with ID: 96 and Name: right_intercostal_1.
	Confidence Rule with ID: 0 and Name: right_intercostal_1.
	Rule text: right_intercostal_1 has angle between 225 and 270 degrees, or between 270 and 315 degrees.

	Confidence Rule with ID: 1 and Name: right_intercostal_1.
	Rule text: right_intercostal_1 has radius between 10 and 15 voxels.

	Confidence Rule with ID: 2 and Name: right_intercostal_1.
	Rule text: aorta is connected to right_intercostal_1.

	Confidence Rule with ID: 3 and Name: right_intercostal_1.
	Rule text: right_intercostal_1 has angle between 225 and 270 degrees, or between 270 and 315 degrees.

	Confidence Rule with ID: 5 and Name: right_intercostal_1.
	Rule text: aorta is connected to right_intercostal_1.

Artery with ID: 101 and Name: left_intercostal_1.
	Confidence Rule with ID: 0 and Name: left_intercostal_1.
	Rule text: left_intercostal_1 has angle between 225 and 270 degrees, or between 270 and 315 degrees.

	Confidence Rule with ID: 1 and Name: left_intercostal_1.
	Rule text: left_intercostal_1 has radius between 10 and 15 voxels.

	Confidence Rule with ID: 2 and Name: left_intercostal_1.
	Rule text: aorta is connected to left_intercostal_1.

	Confidence Rule with ID: 3 and Name: left_intercostal_1.
	Rule text: left_intercostal_1 has angle between 225 and 270 degrees, or between 270 and 315 degrees.

	Confidence Rule with ID: 5 and Name: left_intercostal_1.
	Rule text: aorta is connected to left_intercostal_1.

	Confidence Rule with ID: 6 and Name: left_intercostal_1.
	Rule text: left_intercostal_1 cog_x is greater than right_intercostal_1 cog_x.

Artery with ID: 107 and Name: left_intercostal_2.
	Confidence Rule with ID: 0 and Name: left_intercostal_2.
	Rule text: left_intercostal_2 has angle between 225 and 270 degrees, or between 270 and 315 degrees.

	Confidence Rule with ID: 2 and Name: left_intercostal_2.
	Rule text: aorta is connected to left_intercostal_2.

	Confidence Rule with ID: 3 and Name: left_intercostal_2.
	Rule text: left_intercostal_2 has angle between 225 and 270 degrees, or between 270 and 315 degrees.

	Confidence Rule with ID: 5 and Name: left_intercostal_2.
	Rule text: aorta is connected to left_intercostal_2.

	Confidence Rule with ID: 6 and Name: left_intercostal_2.
	Rule text: left_intercostal_2 cog_x is greater than right_intercostal_2 cog_x.

	Confidence Rule with ID: 7 and Name: left_intercostal_2.
	Rule text: left_intercostal_2 cog_z+5 is greater than right_intercostal_2 cog_z.

	Confidence Rule with ID: 8 and Name: left_intercostal_2.
	Rule text: left_intercostal_2 cog_z-5 is greater than right_intercostal_2 cog_z.

Artery with ID: 108 and Name: superior_mesenteric.
	Confidence Rule with ID: 0 and Name: superior_mesenteric.
	Rule text: superior_mesenteric has angle between 45 and 90 degrees, or between 90 and 135 degrees.

	Confidence Rule with ID: 1 and Name: superior_mesenteric.
	Rule text: superior_mesenteric has radius greater than 20 voxels.

	Confidence Rule with ID: 2 and Name: superior_mesenteric.
	Rule text: superior_mesenteric has radius between 20 and 25 voxels.

	Confidence Rule with ID: 3 and Name: superior_mesenteric.
	Rule text: superior_mesenteric heigth is greater than left_renal heigth.

	Confidence Rule with ID: 4 and Name: superior_mesenteric.
	Rule text: superior_mesenteric heigth is greater than right_renal heigth.

	Confidence Rule with ID: 5 and Name: superior_mesenteric.
	Rule text: celiac_trunk heigth is less than superior_mesenteric heigth.

	Confidence Rule with ID: 6 and Name: superior_mesenteric.
	Rule text: celiac_trunk heigth+10 is less than superior_mesenteric heigth.

Artery with ID: 21 and Name: proper_hepatic.


Artery with ID: 70 and Name: gastroduodenal.


Artery with ID: 50 and Name: right_renal.
	Confidence Rule with ID: 0 and Name: right_renal.
	Rule text: right_renal has angle between 135 and 180 degrees, or between 180 and 225 degrees.

	Confidence Rule with ID: 2 and Name: right_renal.
	Rule text: right_renal has angle between 130 and 180 degrees.

	Confidence Rule with ID: 3 and Name: right_renal.
	Rule text: right_renal has radius between 15 and 20 voxels.

	Confidence Rule with ID: 7 and Name: right_renal.
	Rule text: right_renal heigth is less than superior_mesenteric heigth.

	Confidence Rule with ID: 9 and Name: right_renal.
	Rule text: right_renal cog_x is less than left_renal cog_x.

Artery with ID: 110 and Name: right_intercostal_2.
	Confidence Rule with ID: 0 and Name: right_intercostal_2.
	Rule text: right_intercostal_2 has angle between 225 and 270 degrees, or between 270 and 315 degrees.

	Confidence Rule with ID: 1 and Name: right_intercostal_2.
	Rule text: right_intercostal_2 has radius between 10 and 15 voxels.

	Confidence Rule with ID: 2 and Name: right_intercostal_2.
	Rule text: aorta is connected to right_intercostal_2.

	Confidence Rule with ID: 3 and Name: right_intercostal_2.
	Rule text: right_intercostal_2 has angle between 225 and 270 degrees, or between 270 and 315 degrees.

	Confidence Rule with ID: 5 and Name: right_intercostal_2.
	Rule text: aorta is connected to right_intercostal_2.

Artery with ID: 97 and Name: dorsal_pancreatic.
	Confidence Rule with ID: 1 and Name: dorsal_pancreatic.
	Rule text: common_hepatic is transitively connected to dorsal_pancreatic.

