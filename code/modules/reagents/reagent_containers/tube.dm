// It's essentially for the Krytox meme (aka lube)

/obj/item/reagent_containers/glass/tube
	name = "tube container"
	desc = "A one use tube."
	icon_state = "tube"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	item_state = "tube"
	possible_transfer_amounts = list(1, 2, 5)
	amount_per_transfer_from_this = 5
	volume = 20
	var/proper_icon
	var/lube_variance = 100 //probability lube_tube has a different icon state. Put at 0 for no variance
	var/lube_type = "Krytox_"

/obj/item/reagent_containers/glass/tube/Initialize()
	. = ..()
	if(prob(lube_variance))
		icon_state = "[lube_type][rand(0,5)]"
	update_icon()
	proper_icon = icon_state

/obj/item/reagent_containers/glass/tube/on_reagent_change(changetype)
	update_icon()

/obj/item/reagent_containers/glass/tube/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/glass/tube/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/glass/tube/on_reagent_change(changetype)
	. = ..()
	if(reagents.reagent_list.len)
		icon_state = proper_icon
	else
		icon_state =  "Krytox_out"

/obj/item/reagent_containers/glass/tube/krytox
	name = "Krytox tube"
	icon_state = "Krytox_0"
	desc = "A small tube. Contains Krytox - used to relax people, it's a one use. WARNING: KEEP AWAY FROM CLUHWN."
	list_reagents = list(/datum/reagent/lube = 15, /datum/reagent/drug/happiness = 5)
