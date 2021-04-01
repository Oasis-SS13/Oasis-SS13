/mob/living/carbon/shoepacabra/death(gibbed)
	if(stat == DEAD)
		return

	leave_camouflage()
	light_exposure_cumulative = 0

	. = ..()

	update_icons()
