/mob/living/carbon/shoepacabra/regenerate_icons()
	. = ..()
	update_icons()
	cut_overlays()

/mob/living/carbon/shoepacabra/update_damage_overlays()
	return

/mob/living/carbon/shoepacabra/update_body()
	return

/mob/living/carbon/shoepacabra/update_body_parts()
	return

/mob/living/carbon/shoepacabra/update_icons()
	. = ..()
	var/asleep = IsSleeping()
	if(stat == DEAD)
		icon_state = "shoepacabra_[form]_dead"
	else if(asleep)
		icon_state = "shoepacabra_[form]_sleeping"
	else if(resting)
		icon_state = "shoepacabra_[form]_lying"
	else if(is_leaping)
		if (icon != leaping_icon)
			icon = leaping_icon
			icon_state = "shoepacabra_[form]_leaping"
			pixel_x = -32
			pixel_y = -32
	else
		if (icon != initial(icon))
			icon = initial(icon)
			pixel_x = get_standard_pixel_x_offset(mobility_flags & MOBILITY_STAND)
			pixel_y = get_standard_pixel_y_offset(mobility_flags & MOBILITY_STAND) + SHOEPACABRA_LEAP_ICON_Y_OFFSET
		icon_state = "shoepacabra_[form]"

/mob/living/carbon/shoepacabra/update_transform()
	if(lying)
		lying = 90
	..()
	update_icons()

/* We don't want to draw the held items.
It's uneccessary, for the specter of the items possibly held by the creatures it rather narrow.
*/
/mob/living/carbon/shoepacabra/update_inv_hands()
	..()
	remove_overlay(HANDS_LAYER)
