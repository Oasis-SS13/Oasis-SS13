var/safety = TRUE
/obj/item/reagent_containers/food/drinks/soda_cans/proc/AltClick(mob/user)
	if(spillable = TRUE)
		to_chat(user, "\the [src]doesnt have enougth preasure.")
		return
	safety = !safety
	to_chat(user, "The safety is [safety ? "on" : "off"].")
	return

