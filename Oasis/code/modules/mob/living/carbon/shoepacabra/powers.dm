/* This file describes the shoepacabra's unique abilities.
It is possible to decrease code duplication if the abilities are inherited from proc_holder/spell,
but there's an issue with activating the abilities in this case.
*/

/obj/effect/proc_holder/shoepacabra
	name = "Shoepacabra Power"
	panel = "Shoepacabra"
	has_action = TRUE
	action_icon = 'Oasis/icons/mob/shoepacabra/actions.dmi'
	action_icon_state = null
	action_background_icon_state = "bg_demon"  // Lest we multiply the bg icons without need
	var/toggleable_icon_state = null
	var/toggle_based_action = FALSE
	var/ready = TRUE
	var/cooldown = 0
	var/cooldown_min = 0

	// Mostly copied from proc_holder/spell
	var/mutable_appearance/timer_overlay
	var/mutable_appearance/text_overlay
	var/timer_overlay_active = FALSE
	var/timer_icon = 'icons/effects/cooldown.dmi'
	var/timer_icon_state_active = "second"

/obj/effect/proc_holder/shoepacabra/Click()
	if(!iscarbon(usr))
		return TRUE
	var/mob/living/carbon/user = usr
	if (!ready)
		to_chat(user, "<span class='warning'>[name] is not ready yet!</span>")
		return TRUE
	if(toggle_based_action)
		if(active)
			if (toggled_off(user))
				active = FALSE
		else
			if (toggled_on(user))
				active = TRUE
		update_icon()
	else
		fire(user)
		apply_cooldown()
	return TRUE

/obj/effect/proc_holder/shoepacabra/update_icon()
	..()
	if(toggle_based_action)
		to_chat()
		action.button_icon_state = "[toggleable_icon_state]_[active ? "on" : "off"]"
		action.UpdateButtonIcon()

/* Apply cooldown
Applies cooldown to the ability, making it unable to be used
*/
/obj/effect/proc_holder/shoepacabra/proc/apply_cooldown()
	if(ready)
		ready = FALSE
		cooldown = cooldown_min
		begin_timer_animation()

/* Toggled on
Handles actions taken when the ability is activated
Returns:
	TRUE if activated, FALSE otherwise
*/
/obj/effect/proc_holder/shoepacabra/proc/toggled_on(mob/living/carbon/shoepacabra/user)
	return TRUE

/* Toggled off
Handles actions taken when the ability is deactivated
Returns:
	TRUE if deactivated, FALSE otherwise
*/
/obj/effect/proc_holder/shoepacabra/proc/toggled_off(mob/living/carbon/shoepacabra/user)
	return TRUE

/* Begin timer animation
Initializes timer image and overlay,
mostly copied from the proc_holder/spell 
*/
/obj/effect/proc_holder/shoepacabra/proc/begin_timer_animation()
	if(!(action?.button) || timer_overlay_active)
		return

	timer_overlay_active = TRUE
	timer_overlay = mutable_appearance(timer_icon, timer_icon_state_active)
	timer_overlay.alpha = 180

	if(!text_overlay)
		text_overlay = image(loc = action.button, layer=ABOVE_HUD_LAYER)
		text_overlay.maptext_width = 64
		text_overlay.maptext_height = 64
		text_overlay.maptext_x = -8
		text_overlay.maptext_y = -6
		text_overlay.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

	if(action.owner?.client)
		action.owner.client.images += text_overlay

	action.button.add_overlay(timer_overlay, TRUE)
	action.has_cooldown_timer = TRUE
	update_timer_animation()

	START_PROCESSING(SSfastprocess, src)

/* Update timer animation
Handles timer animation, updates the timer text
mostly copied from the proc_holder/spell 
*/
/obj/effect/proc_holder/shoepacabra/proc/update_timer_animation()
	if(!(action?.button))
		return
	text_overlay.maptext = "<center><span class='chatOverhead' style='font-weight: bold;color: #eeeeee;'>[FLOOR((cooldown)/10, 1)]</span></center>"

/* End timer animation
End timer animation, deactivates the timer overlay and deletes text
mostly copied from the proc_holder/spell 
*/
/obj/effect/proc_holder/shoepacabra/proc/end_timer_animation()
	if(!(action?.button) || !timer_overlay_active)
		return
	timer_overlay_active = FALSE
	if(action.owner?.client)
		action.owner.client.images -= text_overlay
	action.button.cut_overlay(timer_overlay, TRUE)
	timer_overlay = null
	qdel(text_overlay)
	text_overlay = null
	action.has_cooldown_timer = FALSE

	STOP_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/shoepacabra/fire()
	return TRUE

/obj/effect/proc_holder/shoepacabra/process()
	if(!ready) 
		if(cooldown > 0)
			cooldown = max(cooldown - SHOEPACABRA_ABILITIES_COOLDOWN_SPEED, 0)
			update_timer_animation()
		else
			ready = TRUE
			end_timer_animation()

/obj/effect/proc_holder/shoepacabra/camouflage
	name = "Toggle camouflage"
	desc = "Hide yourself in the darkness."
	action_icon_state = "lesser_stealth_off"
	toggleable_icon_state = "lesser_stealth"
	active = FALSE
	toggle_based_action = TRUE
	cooldown_min = 30

/obj/effect/proc_holder/shoepacabra/camouflage/toggled_off(mob/living/carbon/shoepacabra/user)
	user.leave_camouflage()
	return TRUE

/obj/effect/proc_holder/shoepacabra/camouflage/toggled_on(mob/living/carbon/shoepacabra/user)
	if (!istype(user))
		to_chat(user, "<span class='notice'>Only a shoepacabra can use this kind of camouflage!</span>")
		return FALSE
	var/turf/T = user.loc
	if(!istype(T) || (movement_type & VENTCRAWLING))
		to_chat(user, "<span class='warning'>This is not a proper place for hiding!</span>")
		return FALSE
	var/light_amount = T.get_lumcount()
	if(light_amount > SHOEPACABRA_CAMOUFLAGE_LIGHT_AMOUNT_THRESHOLD)
		to_chat(user, "<span class='warning'>This place is too bright for hiding!</span>")
		return FALSE
	to_chat(user, "<span class='notice'>You start blending with the darkness...</span>")
	user.camouflage_enabled = TRUE
	return TRUE

/obj/effect/proc_holder/shoepacabra/lubricant_secretion
	name = "Secrete lubricant"
	desc = "Secrete lubricant on the floor beneath you."
	action_icon_state = "secrete_lube"
	active = FALSE

	cooldown_min = 100

/obj/effect/proc_holder/shoepacabra/lubricant_secretion/fire(mob/living/carbon/user)
	var/turf/open/T = get_turf(user.loc)
	if(!istype(T))
		to_chat(user, "<span class='notice'>You cannot secrete lube here!</span>")
		return FALSE
	to_chat(user, "<span class='notice'>You secrete lube on [T], making it slippery!</span>")
	T.MakeSlippery(TURF_WET_LUBE, min_wet_time = 15 SECONDS, wet_time_to_add = 5 SECONDS)
	return TRUE

/obj/effect/proc_holder/shoepacabra/evolve_to_greater
	name = "Evolve"
	desc = "Evolve to something more powerful."
	action_icon_state = "evolve"
	active = FALSE

/obj/effect/proc_holder/shoepacabra/evolve_to_greater/fire(mob/living/carbon/shoepacabra/shoepacabra_lesser/user)
	if(!istype(user))
		to_chat(user, "<span class='notice'>You're really not supposed to evolve like this.</span>")
		return FALSE

	if(!isturf(user.loc) || user.entered_light)
		to_chat(user, "<span class='notice'>You can't evolve here!</span>")
		return FALSE

	to_chat(user, "<span class='notice'><b>Your ascension finally begins!</b></span>")

	var/mob/living/carbon/shoepacabra/shoepacabra_greater/new_form = new(user.loc)
	new_form.setDir(user.dir)
	if(user.mind)
		user.mind.transfer_to(new_form)
	qdel(user)
	return TRUE

/obj/effect/proc_holder/shoepacabra/camouflage/greater
	desc = "Hide yourself in the darkness and ambush your prey."
	action_icon_state = "greater_stealth_off"
	toggleable_icon_state = "greater_stealth"
	cooldown_min = 50

/obj/effect/proc_holder/shoepacabra/camouflage/greater/toggled_off(mob/living/carbon/shoepacabra/user)
	if(istype(user) && user.camouflaged)
		user.visible_message("<span class='boldwarning'>[user] springs out from nowhere!</span>",
			"<span class='notice'><b>You instantly spring out from darkness, knocking out everyone nearby!</b></span>"
			)
		user.leave_camouflage()

		for(var/mob/living/target in view_or_range(SHOEPACABRA_AMBUSH_RANGE, user, "range"))
			if(target == user)
				continue
			to_chat(target, "<span class='userdanger'>[user] knocks you down!</span>")
			target.Knockdown(SHOEPACABRA_AMBUSH_KNOCKDOWN_AMOUNT)

		return TRUE
	else
		return ..()
	return TRUE

/obj/effect/proc_holder/shoepacabra/leap
	name = "Toggle leap"
	desc = "Leap at your prey to knock them down."
	action_icon_state = "leap_off"
	toggleable_icon_state = "leap"
	active = FALSE
	toggle_based_action = TRUE

/obj/effect/proc_holder/shoepacabra/spit
	name = "Spit"
	desc = "Disable your victims at range."
	action_icon_state = "spit_off"
	toggleable_icon_state = "spit"
	active = FALSE
	cooldown_min = 100
	toggle_based_action = TRUE

/obj/effect/proc_holder/shoepacabra/spit/toggled_on(mob/living/carbon/user)
	var/message = "<span class='notice'>You stress muscles around your glands, getting ready to spit!</span>"
	add_ranged_ability(user, message, TRUE)

/obj/effect/proc_holder/shoepacabra/spit/toggled_off(mob/living/carbon/user)
	remove_ranged_ability("<span class='notice'>You relax your gland muscles.</span>")

/obj/effect/proc_holder/shoepacabra/spit/InterceptClickOn(mob/living/caller, params, atom/target)
	if(..())
		return

	if(!iscarbon(ranged_ability_user) || ranged_ability_user.stat)
		remove_ranged_ability()
		return

	var/mob/living/carbon/user = ranged_ability_user

	var/turf/T = user.loc
	var/turf/U = get_step(user, user.dir)
	if(!isturf(U) || !isturf(T))
		return FALSE

	user.visible_message("<span class='danger'>[user] spits some weird substance!", \
		"<span class='notice'><b>You spit the disabling secrete.</b></span>")
	var/obj/item/projectile/bullet/shoepacabra_spit/A = new/obj/item/projectile/bullet/shoepacabra_spit(user.loc)
	A.preparePixelProjectile(target, user, params)
	A.fire()
	active = FALSE
	apply_cooldown() 
	remove_ranged_ability()

	user.newtonian_move(get_dir(U, T))

	return TRUE

/obj/effect/proc_holder/shoepacabra/leap
	name = "Leap"
	desc = "Knock down your victims by leapint at them!"
	action_icon_state = "leap_off"
	toggleable_icon_state = "leap"
	active = FALSE
	cooldown_min = 100
	toggle_based_action = TRUE

/obj/effect/proc_holder/shoepacabra/leap/toggled_on(mob/living/carbon/user)
	var/message = "<span class='notice'>You're getting ready to leap.</span>"
	add_ranged_ability(user, message, TRUE)

/obj/effect/proc_holder/shoepacabra/leap/toggled_off(mob/living/carbon/user)
	remove_ranged_ability("<span class='notice'>You won't leap anymore.</span>")

/obj/effect/proc_holder/shoepacabra/leap/InterceptClickOn(mob/living/caller, params, atom/target)
	if(..())
		return

	var/mob/living/carbon/shoepacabra/shoepacabra_greater/user = ranged_ability_user
	if(!istype(user) || user.stat)
		remove_ranged_ability()
		return	

	var/turf/T = user.loc
	var/turf/U = get_step(user, user.dir)
	if(!isturf(U) || !isturf(T))
		return FALSE

	user.leap_at(target)

	active = FALSE
	apply_cooldown() 
	remove_ranged_ability()

	return TRUE
