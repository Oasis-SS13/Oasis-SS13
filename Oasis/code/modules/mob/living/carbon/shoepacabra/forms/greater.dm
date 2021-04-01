/mob/living/carbon/shoepacabra/shoepacabra_greater
	name = "\the el grando shoepacabra"
	article = "el"
	icon_state = "shoepacabra_greater"
	form = "greater"

	clawed = TRUE
	can_tackle = TRUE
	can_aggrograb = TRUE

	shoes_healing_amount = 15

	light_amount_threshold = 0.5
	light_amount_threshold_delta = 0.034
	light_amount_threshold_max = 1

	movespeed_buff_stage = 0

	shoes_consumption_delay = 0

	shoes_strip_delay_multiplier = 0.5
	shoes_strip_delay_multiplier_min = 0

	bodyparts = list(/obj/item/bodypart/chest/shoepacabra_greater, /obj/item/bodypart/head/shoepacabra_greater, /obj/item/bodypart/l_arm/shoepacabra_greater,
					 /obj/item/bodypart/r_arm/shoepacabra_greater, /obj/item/bodypart/r_leg/shoepacabra_greater, /obj/item/bodypart/l_leg/shoepacabra_greater)

/mob/living/carbon/shoepacabra/shoepacabra_greater/create_internal_organs()
	internal_organs += new /obj/item/organ/lubricant_cyst //the greater form should have this by default
	. = ..()

/mob/living/carbon/shoepacabra/shoepacabra_greater/update_stage()
	switch(points)
		if(0)
			consume_verb = "ingest"
			staging_message = "You can feel your body getting stronger again..."
			
			AddAbility(new/obj/effect/proc_holder/shoepacabra/camouflage/greater)
		if(5)
			to_chat(src, "<span class='notice'>As your power grows, you gain the ability to leap at your prey.</span>")
			consume_verb = "consume"
			staging_message = "Your body keeps improving with each meal..."

			AddAbility(new/obj/effect/proc_holder/shoepacabra/leap)
		if(10)
			to_chat(src, "<span class='notice'>You feel some strange sacks grow in your throat, filled with mysterious liquid. You are now able to spit at your prey!</span>")
			consume_verb = "swallow"
			staging_message = "You're getting closer and closer to the perfection..."

			var/obj/item/organ/shoepacabra_secrete_gland/gland = new()
			gland.Insert(src, TRUE, FALSE)
		if(15)
			to_chat(src, "<span class='notice'>At last, you reach the most perfect shape your lifeform could ever reach. You are an unstoppable brute! <b>Eat their shoes, EAT THEM ALL!!!</b></span>")
			consume_verb = "devour"
			staging_message = null

			bloodthirsty = TRUE

/* Leap at
Leaping mechanics, duplicated from the hunter xenomorph
but with cooldown handled by the /obj/effect/proc_holder/shoepacabra/leap
*/
/mob/living/carbon/shoepacabra/shoepacabra_greater/proc/leap_at(atom/A)
	if((mobility_flags & (MOBILITY_MOVE | MOBILITY_STAND)) != (MOBILITY_MOVE | MOBILITY_STAND) || is_leaping)
		return

	if(!has_gravity() || !A.has_gravity())
		to_chat(src, "<span class='alertalien'>It is unsafe to leap without gravity!</span>")
		return

	else
		is_leaping = TRUE
		weather_immunities += "lava"
		update_icons()
		throw_at(A, SHOEPACABRA_LEAP_DISTANCE, 1, src, FALSE, TRUE, callback = CALLBACK(src, .proc/leap_end))

/* Leap end
Leaping mechanics, duplicated from the hunter xenomorph
but with adapted ability disabling
*/
/mob/living/carbon/shoepacabra/shoepacabra_greater/proc/leap_end()
	is_leaping = FALSE
	weather_immunities -= "lava"
	update_icons()

/mob/living/carbon/shoepacabra/shoepacabra_greater/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!is_leaping)
		return ..()

	var/obj/effect/proc_holder/shoepacabra/leap/ability = locate() in abilities
	if(!istype(ability))
		return ..()

	if(hit_atom)
		if(isliving(hit_atom))
			var/mob/living/L = hit_atom
			var/blocked = FALSE
			if(ishuman(hit_atom))
				var/mob/living/carbon/human/H = hit_atom
				if(H.check_shields(src, 0, "the [name]", attack_type = LEAP_ATTACK))
					blocked = TRUE
			if(!blocked)
				L.visible_message("<span class ='danger'>[src] pounces on [L]!</span>", "<span class ='userdanger'>[src] pounces on you!</span>")
				L.Paralyze(100)
				sleep(2)
				step_towards(src,L)
			else
				Paralyze(40, 1, 1)
			ability.active = FALSE
			ability.update_icon()
		else if(hit_atom.density && !hit_atom.CanPass(src))
			visible_message("<span class ='danger'>[src] smashes into [hit_atom]!</span>",
				"<span class ='danger'>You smash into [hit_atom]!</span>")
			Paralyze(40, 1, 1)

		if(is_leaping)
			ability.active = FALSE
			ability.update_icon()
			update_mobility()

/mob/living/carbon/shoepacabra/shoepacabra_greater/float(on)
	if(is_leaping)
		return
	..()
