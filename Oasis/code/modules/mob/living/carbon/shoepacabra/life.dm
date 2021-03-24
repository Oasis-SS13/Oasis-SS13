/mob/living/carbon/shoepacabra/Life()
	if(stat == DEAD)
		return ..()

	var/light_amount = 0
	var/turf/T = loc
	if(istype(T) && !(movement_type & VENTCRAWLING))
		light_amount = T.get_lumcount()
	handle_light(light_amount)
	handle_camouflage(light_amount)
	handle_regeneration()

	. = ..()

/* Handle light
Controls all light-related mechanics of the creature and calls according procs under certain circumstances
Accepts:
	light_amount, the amount of light at the creature's location
*/
/mob/living/carbon/shoepacabra/proc/handle_light(light_amount)
	if(light_amount > light_amount_threshold)
		if (!entered_light)
			entered_light = TRUE
			on_entered_light(light_amount > (light_amount_threshold + SHOEPACABRA_BLINDING_LIGHT_OFFSET))
		var/overflow = light_amount - light_amount_threshold
		light_exposure_cumulative = min(
			light_exposure_cumulative + overflow,
			SHOEPACABRA_MAX_EXPOSURE_PUNISHMENT_LENGTH
			)
		light_amount_punishment(overflow)
	else
		if (entered_light)
			entered_light = FALSE
			on_left_light()
		light_exposure_cumulative = max(light_exposure_cumulative - light_exposure_recover_speed, 0)

	if(light_exposure_cumulative > light_exposure_threshold)
		if (!overexposure)
			overexposure = TRUE
			on_overexposure()
		light_exposure_punishment(light_exposure_cumulative - light_exposure_threshold)
	else
		if (overexposure)
			overexposure = FALSE
			on_overexposure_recover()

/* On entered light
Responsible for actions performed when the creature enters open light.
Used mostly for printing warning message.
*/
/mob/living/carbon/shoepacabra/proc/on_entered_light(blinding = FALSE)
	to_chat(src, "<span class='boldwarning'>Your eyes burn with unbearable pain as you enter the blindingly bright light. Seek shelter!</span>")
	set_speedmod(0)
	if (blinding)
		flash_act()

/* On left light
Responsible for actions performed when the creature returns to the darkness.
Used mostly for clearing light_amount_punishment debuffs.
*/
/mob/living/carbon/shoepacabra/proc/on_left_light()
	to_chat(src, "<span class='notice'>Your eyes start to recover as you return into the arms of darkness.</span>")
	set_speedmod(movespeed_buff)
	cure_blind(SHOEPACABRA_LIGHT_EXPOSURE)

/* Light amount punishment
Slightly punishes the creature for being exposed to open light.
Accepts:
	strength, the measure of punishment strength as a number
*/
/mob/living/carbon/shoepacabra/proc/light_amount_punishment(strength)
	strength = clamp(strength, 0, SHOEPACABRA_MAX_PUNISHMENT_SEVERITY)
	become_blind(SHOEPACABRA_LIGHT_EXPOSURE)

/* On overexposure
Responsible for actions performed when the creature exceeds the light exposure time limit.
*/
/mob/living/carbon/shoepacabra/proc/on_overexposure()
	//to_chat(src, "<span class='danger'>on_overexposure called!!</span>")
	visible_message("<span class='danger'>[src] twists in burning agony as its skin begins to blister!</span>")
	//if src is blind, he doesn't see the self_message for some reason, may be the proc is bugged
	to_chat(src, "<span class='userdanger'>You feel waves of burning agony sweeping across your skin! This is too much light for you to sustain!</span>")
	emote("hiss")

/* On overexposure recover
Responsible for actions performed when the creature recovers from the exposure in the darkness.
*/
/mob/living/carbon/shoepacabra/proc/on_overexposure_recover()
	to_chat(src, "<span class='notice'>You feel better as you recover from the recent exposure to the open light. You may now sleep to heal your injuries.</span>")

/* Light exposure punishment
Severly punishes the creature for being exposed to open light for too long.
Accepts:
	strength, the measure of punishment strength as a number
*/
/mob/living/carbon/shoepacabra/proc/light_exposure_punishment(strength)
	strength = clamp(strength, 0, SHOEPACABRA_MAX_PUNISHMENT_SEVERITY)
	if (entered_light)
		take_overall_damage(burn = strength * SHOEPACABRA_PUNISHMENT_DAMAGE_MULTIPLIER)
		to_chat(src, "<span class='danger'>Your skin burns!</span>")
		emote("hiss")
	Dizzy(strength)
	confused = max(confused, strength)

/* Handle camouflage
Controls the camouflage of the creature, how it becomes transparent and how it can be disturbed by light
Accepts:
	light_amount, the amount of light at the creature's location
*/
/mob/living/carbon/shoepacabra/proc/handle_camouflage(light_amount)
	if (!camouflage_enabled)
		return
	if(light_amount > SHOEPACABRA_CAMOUFLAGE_LIGHT_AMOUNT_THRESHOLD)
		to_chat(src, "<span class='warning'>This place has became too bright for hiding!</span>")
		leave_camouflage()
		return
	alpha = max(alpha - SHOEPACABRA_CAMOUFLAGE_SPEED, SHOEPACABRA_CAMOUFLAGED_TRANSPARENCY)
	if(alpha <= SHOEPACABRA_CAMOUFLAGED_TRANSPARENCY && !camouflaged)
		to_chat(src, "<span class='notice'>You're completely hidden now.</span>")
		camouflaged = TRUE

/mob/living/carbon/shoepacabra/Move()
	. = ..()
	if(camouflage_enabled)
		leave_camouflage()

/* Handle regeneration
Controls the regeneration of the creature when it sleeps
*/
/mob/living/carbon/shoepacabra/proc/handle_regeneration()
	if(!entered_light && IsSleeping())
		var/healing_amount = shoes_healing_amount * SHOEPACABRA_REGENERATION_MULTIPLIER
		heal_overall_damage(healing_amount, healing_amount, healing_amount)
