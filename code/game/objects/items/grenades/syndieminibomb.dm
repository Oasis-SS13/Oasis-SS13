/obj/item/grenade/syndieminibomb
	desc = "A syndicate manufactured explosive used to sow destruction and chaos."
	name = "syndicate minibomb"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "syndicate"
	item_state = "flashbang"

/obj/item/grenade/syndieminibomb/prime()
	update_mob()
	explosion(src.loc,1,2,4,flame_range = 2)
	qdel(src)

/obj/item/grenade/syndieminibomb/concussion
	name = "HE Grenade"
	desc = "A compact shrapnel grenade meant to devastate nearby organisms and cause some damage in the process. Pull pin and throw opposite direction."
	icon_state = "concussion"

/obj/item/grenade/syndieminibomb/concussion/prime()
	update_mob()
	explosion(src.loc,0,2,3,flame_range = 3)
	qdel(src)

/obj/item/grenade/syndieminibomb/concussion/frag
	name = "frag grenade"
	desc = "Fire in the hole."
	icon_state = "frag"

/obj/item/grenade/syndieminibomb/dynamite
	desc = "An old tool to get something ripped apart. If you see sparks coming out of it then it's a good idea to run."
	name = "dynamite"
	det_time = 30
	icon = 'icons/obj/grenade.dmi'
	icon_state = "dynamite"
	item_state = "flashbang"

/obj/item/grenade/syndieminibomb/dynamite/examine(mob/user)
	. = ..()
	. += "No, you can't change the timer on it with a screwdriver."

/obj/item/grenade/syndieminibomb/dynamite/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_SCREWDRIVER)
		to_chat(user, "<span class='warning'>You can't change the detonation time on this!</span>")
	else
		return ..()

/obj/item/grenade/syndieminibomb/dynamite/preprime(mob/user, delayoverride, msg = TRUE, volume = 60)
	var/turf/T = get_turf(src)
	log_grenade(user, T) //Inbuilt admin procs already handle null users
	if(user)
		add_fingerprint(user)
		if(msg)
			to_chat(user, "<span class='warning'>You prime [src]! [DisplayTimeText(det_time)]!</span>")
	playsound(src, 'sound/effects/fuse.ogg', 60, 1)
	active = TRUE
	icon_state = initial(icon_state) + "_active"
	addtimer(CALLBACK(src, .proc/prime), isnull(delayoverride)? det_time : delayoverride)

/obj/item/grenade/syndieminibomb/dynamite/prime()
	update_mob()
	explosion(src.loc,1,3,5,flame_range = 2)
	qdel(src)

/obj/item/grenade/gluon
	desc = "An advanced grenade that releases a harmful stream of gluons inducing radiation in those nearby. These gluon streams will also make victims feel exhausted, and induce shivering. This extreme coldness will also likely wet any nearby floors."
	name = "gluon frag grenade"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "bluefrag"
	item_state = "flashbang"
	var/freeze_range = 4
	var/rad_damage = 350
	var/stamina_damage = 30

/obj/item/grenade/gluon/prime()
	update_mob()
	playsound(loc, 'sound/effects/empulse.ogg', 50, 1)
	radiation_pulse(src, rad_damage)
	for(var/turf/open/floor/F in view(freeze_range,loc))
		F.MakeSlippery(TURF_WET_PERMAFROST, 6 MINUTES)
		for(var/mob/living/carbon/L in F)
			L.adjustStaminaLoss(stamina_damage)
			L.adjust_bodytemperature(-230)
	qdel(src)
