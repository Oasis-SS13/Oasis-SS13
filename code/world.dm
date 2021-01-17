//This file is just for the necessary /world definition
//Try looking in game/world.dm

/world
	mob = /mob/dead/new_player
	area = /area/sandland
	//turf = /turf/open/space/basic 	//Ask Kryyto if you want the space back
	turf = /turf/open/sand_land/basic   // ScorchStation
	view = "17x15"
	hub = "Exadv1.spacestation13"
	hub_password = "kMZy3U5jJHSiBQjr"
	name = "OasisStation 13"
	fps = 20
#ifdef FIND_REF_NO_CHECK_TICK
	loop_checks = FALSE
#endif
