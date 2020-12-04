/obj/item/lunarclock
	name = "lunar clock"
	desc = "You feel time slowdown"
	custom_price = 10
	icon = 'Oasis/icons/obj/lunar.dmi'
	icon_state = "closed"
	item_state = "closed"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	materials = list(/datum/material/iron=50, /datum/material/glass=20)
	var/open = FALSE
	var/cooldown = 0


/obj/item/lunarclock/AltClick(mob/user)
	if(open == TRUE)
		open = FALSE
		icon_state = "closed"
		playsound(src, 'sound/items/zippo_off.ogg', 25, 1)
		to_chat(user, "You close the watch")
	else
		open = TRUE
		playsound(src, 'sound/items/zippo_off.ogg', 25, 1)
		icon_state = "open"
		to_chat(user, "You open the watch")
/obj/item/lunarclock/attack_self(mob/user)
	if(open == FALSE)
		to_chat(user, "<span class='warning'>You must open the watch to use it!</span>")
	else
		new /obj/effect/timestop(get_turf(user), 2, 300,)
		playsound(src, 'sound/items/jojo.ogg', 30, 0)
