//Caves level sand (darker red sand) used in ScorchStation
/turf/open/floor/plating/asteroid/cavesand
	name = "Caves sand"
	baseturfs = /turf/open/floor/plating/asteroid/cavesand
	icon = 'icons/turf/floors.dmi'
	icon_state = "ironsand1"
	icon_plating = "ironsand1"
	environment_type = "ironsand"
	initial_gas_mix = DESERT_ATMOS
	floor_variance = 50
	digResult = /obj/item/stack/sheet/mineral/sandstone

/turf/open/floor/plating/asteroid/cavesand/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/plating/asteroid/cavesand/Initialize()
	. = ..()
	set_cavesand_light(src)
	var/proper_name = name
	name = proper_name
	if(prob(floor_variance))
		icon_state = "[environment_type][rand(1,15)]"

/proc/set_cavesand_light(turf/open/floor/B)
		B.set_light(1.5, 0.6, LIGHT_COLOR_RED) //RED light coming from the cave sand

/turf/open/floor/plating/asteroid/cavesand/cavesand_land_surface
	initial_gas_mix = DESERT_ATMOS
	planetary_atmos = TRUE
	baseturfs = /turf/open/floor/plating/asteroid/cavesand/cavesand_land_surface

#define SPAWN_MEGAFAUNA "bluh bluh huge boss"
#define SPAWN_BUBBLEGUM 6

/turf/open/floor/plating/asteroid/cavesand
	var/length = 100
	var/list/mob_spawn_list
	var/list/megafauna_spawn_list
	var/list/flora_spawn_list
	var/list/terrain_spawn_list
	var/sanity = 1
	var/forward_cave_dir = 1
	var/backward_cave_dir = 2
	var/going_backwards = TRUE
	turf_type = /turf/open/floor/plating/asteroid/cavesand

/turf/open/floor/plating/asteroid/cavesand
	mob_spawn_list = list(/mob/living/simple_animal/hostile/asteroid/goliath/beast/random = 50, /obj/structure/spawner/lavaland/goliath = 3, \
		/mob/living/simple_animal/hostile/asteroid/basilisk/watcher/random = 40, /obj/structure/spawner/lavaland = 2, \
		/mob/living/simple_animal/hostile/asteroid/hivelord/legion/random = 30, /obj/structure/spawner/lavaland/legion = 3, \
		SPAWN_MEGAFAUNA = 6, /mob/living/simple_animal/hostile/asteroid/goldgrub = 10, )

	turf_type = /turf/open/floor/plating/asteroid/cavesand
	initial_gas_mix = DESERT_ATMOS


/turf/open/floor/plating/asteroid/cavesand/Initialize()
	if (!mob_spawn_list)
		mob_spawn_list = list(/mob/living/simple_animal/hostile/asteroid/goldgrub = 1, /mob/living/simple_animal/hostile/asteroid/goliath = 5, /mob/living/simple_animal/hostile/asteroid/basilisk = 4, /mob/living/simple_animal/hostile/asteroid/hivelord = 3)
	if (!megafauna_spawn_list)
		megafauna_spawn_list = list(/mob/living/simple_animal/hostile/megafauna/dragon = 4, /mob/living/simple_animal/hostile/megafauna/colossus = 2, /mob/living/simple_animal/hostile/megafauna/bubblegum = SPAWN_BUBBLEGUM)
	if (!flora_spawn_list)
		flora_spawn_list = list(/obj/structure/flora/ash/leaf_shroom = 2 , /obj/structure/flora/ash/cap_shroom = 2 , /obj/structure/flora/ash/stem_shroom = 2 , /obj/structure/flora/ash/cacti = 1, /obj/structure/flora/ash/tall_shroom = 2)
	if(!terrain_spawn_list)
		terrain_spawn_list = list(/obj/structure/geyser/random = 1)
	. = ..()


//Station level sand (normal sand)
/turf/open/floor/plating/asteroid/sand
	name = "Sand"
	baseturfs = /turf/open/floor/plating/asteroid/sand
	icon = 'icons/turf/floors.dmi'
	icon_state = "asteroid0"
	icon_plating = "asteroid0"
	environment_type = "asteroid"
	initial_gas_mix = DESERT_ATMOS
	floor_variance = 50
	digResult = /obj/item/stack/sheet/mineral/sandstone

/turf/open/floor/plating/asteroid/sand/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/plating/asteroid/sand/Initialize()
	. = ..()
	set_sand_light(src)
	var/proper_name = name
	name = proper_name
	if(prob(floor_variance))
		icon_state = "[environment_type][rand(0,12)]"

/proc/set_sand_light(turf/open/floor/B)
		B.set_light(2, 0.6, LIGHT_COLOR_YELLOW) //Yellow light coming from the sun on the sand

/turf/open/floor/plating/asteroid/sand/sand_land_surface
	initial_gas_mix = DESERT_ATMOS
	planetary_atmos = TRUE
	baseturfs = /turf/open/floor/plating/asteroid/sand

