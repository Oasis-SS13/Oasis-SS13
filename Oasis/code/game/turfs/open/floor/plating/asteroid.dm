/turf/open/floor/plating/asteroid/cavesand
	name = "Sand floor"
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
		B.set_light(2, 0.6, LIGHT_COLOR_YELLOW) //Yellow light coming from the sun on cave sand???

/turf/open/floor/plating/asteroid/cavesand/cavesand_land_surface
	initial_gas_mix = DESERT_ATMOS
	planetary_atmos = TRUE
	baseturfs = /turf/open/floor/plating/asteroid/cavesand
