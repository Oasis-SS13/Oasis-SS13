//sandstorms happen frequently on lavaland. They heavily obscure vision, and cause high fire damage to anyone caught outside.
/datum/weather/sand_storm
	name = "sandstorm"
	desc = "An intense atmospheric storm lifts sand off of the planet's surface and billows it down across the area, dealing intense fire and brute damage to the unprotected."

	telegraph_message = "<span class='boldwarning'>An eerie moan rises on the wind. A wall of sand coats the horizon. Seek shelter.</span>"
	telegraph_duration = 300
	telegraph_overlay = "light_ash" // Changed to light_sand from light_ash

	weather_message = "<span class='userdanger'><i>Smoldering clouds of scorching sand billow down around you! Get inside!</i></span>"
	weather_duration_lower = 600
	weather_duration_upper = 1200
	weather_overlay = "sand_storm" // Changed to sand_storm from sand_storm

	end_message = "<span class='boldannounce'>The shrieking wind whips away the last of the sandstorm and falls to its usual murmur. It should be safe to go outside now.</span>"
	end_duration = 300
	end_overlay = "light_sand" // Changed to light_sand from light_ash

	area_type = /area/scorch/surface/outdoors // Change to /area/scorch/surface/outdoors or similar

	target_trait = ZTRAIT_SCORCHSTATION // The z-level trait to affect when run randomly or when not overridden. //Oasis

	immunity_type = "ash"  // ash or sand if we make sand immunity

	probability = 90

	barometer_predictable = TRUE



	var/datum/looping_sound/active_outside_ashstorm/sound_ao = new(list(), FALSE, TRUE)
	var/datum/looping_sound/active_inside_ashstorm/sound_ai = new(list(), FALSE, TRUE)
	var/datum/looping_sound/weak_outside_ashstorm/sound_wo = new(list(), FALSE, TRUE)
	var/datum/looping_sound/weak_inside_ashstorm/sound_wi = new(list(), FALSE, TRUE)

/datum/weather/sand_storm/telegraph()
	. = ..()
	var/list/inside_areas = list()
	var/list/outside_areas = list()
	var/list/eligible_areas = list()
	for (var/z in impacted_z_levels)
		eligible_areas += SSmapping.areas_in_z["[z]"]
	for(var/i in 1 to eligible_areas.len)
		var/area/place = eligible_areas[i]
		if(place.outdoors)
			outside_areas += place
		else
			inside_areas += place
		CHECK_TICK

	sound_ao.output_atoms = outside_areas
	sound_ai.output_atoms = inside_areas
	sound_wo.output_atoms = outside_areas
	sound_wi.output_atoms = inside_areas

	sound_wo.start()
	sound_wi.start()

/datum/weather/sand_storm/start()
	. = ..()
	sound_wo.stop()
	sound_wi.stop()

	sound_ao.start()
	sound_ai.start()

/datum/weather/sand_storm/wind_down()
	. = ..()
	sound_ao.stop()
	sound_ai.stop()

	sound_wo.start()
	sound_wi.start()

/datum/weather/sand_storm/end()
	. = ..()
	sound_wo.stop()
	sound_wi.stop()

/datum/weather/sand_storm/proc/is_ash_immune(atom/L)
	while (L && !isturf(L))
		if(ismecha(L)) //Mechs are immune
			return TRUE
		if(ishuman(L)) //Are you immune?
			var/mob/living/carbon/human/H = L
			var/thermal_protection = H.get_thermal_protection()
			if(thermal_protection >= FIRE_IMMUNITY_MAX_TEMP_PROTECT)
				return TRUE
		if(isliving(L))// if we're a non immune mob inside an immune mob we have to reconsider if that mob is immune to protect ourselves
			var/mob/living/the_mob = L
			if("ash" in the_mob.weather_immunities)
				return TRUE
		L = L.loc //Check parent items immunities (recurses up to the turf)
	return FALSE //RIP you

/datum/weather/sand_storm/weather_act(mob/living/L)
	if(is_ash_immune(L))
		return
	L.adjustFireLoss(2)
	L.adjustBruteLoss(2)
