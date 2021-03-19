/mob/living/carbon/shoepacabra
	name = "shoepacabra"
	icon = 'Oasis/icons/mob/shoepacabra/shoepacabra.dmi'	
	var/leaping_icon = 'Oasis/icons/mob/shoepacabra/shoepacabra_leaping.dmi'
	icon_state = null
	gender = MALE
	possible_a_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_HARM)
	mob_biotypes = list(MOB_ORGANIC)
	var/form = "lesser"  // The postfix used generally for icon state determination
	var/clawed = FALSE  // Determines if the creature is using xeno-like claws
	var/can_tackle = FALSE  // Determines if the creature is capable of tackling the opponent instead of pushing it
	var/can_aggrograb = FALSE  // Determines if the creature is capable of aggressively grabbing the opponent <TODO> NOT IMPLEMENTED YET
	var/bloodthirsty = FALSE  // Determines if the creature should maim people when stealing shoes with harm intent

	article = "el"
	unique_name = TRUE
	verb_say = "hisses"
	initial_language_holder = /datum/language_holder/shoepacabrish
	bubble_icon = "alien"  // Sombrero icon when
	mobchatspan = "alienmobsay"

	dna = null
	see_in_dark = 4
	type_of_meat = /obj/item/reagent_containers/food/snacks/meat/slab/xeno
	gib_type = /obj/effect/decal/cleanable/xenoblood/xgibs

	hud_type = /datum/hud/shoepacabra

	var/consume_verb = "eat"
	var/staging_message = null

	var/points = 0  // How many pairs of shoes the creature has eaten
	var/stage = 0  // Current creature development stage

	var/entered_light = FALSE  // Determines if the creature has entered the light
	var/light_amount_threshold = 0.2  // Determines how much amount of light the creature is capable to be exposed to without harm
	var/light_amount_threshold_delta = 0.02  // Determines how much the light_amount_threshold rises with points
	var/light_amount_threshold_max = 0.5  // Determines light_amount_threshold maximal level
	var/immune_to_light = FALSE  // Determines if the creature is immune to light

	var/overexposure = FALSE  // Determines if the creature has stayed in the light for too long
	var/light_exposure_cumulative = 0  // How long did the creature stay in the open light
	var/light_exposure_recover_speed = 0.2  // How fast the creature recovers after being exposed to the open light
	var/light_exposure_threshold = 1  // How long the creature is capable to stay in the open light

	var/shoes_healing_amount = 5  // How much health does consumption regenerate
	var/shoes_consumption_delay = 25  // How much time does it take to consume shoes
	var/shoes_consumption_delta = 5  // How much the delay is reduced with every point
	var/shoes_consumption_reduction_stage = 0  // the points value after which the consumption delay begins to reduce
	
	var/shoes_strip_delay_multiplier = 1  // Usual strip_delay is multiplied by this value when the creature tries to steal the footwear
	var/shoes_strip_delay_multiplier_delta = 0.05  // How much the delay multiplier is reduced with every point
	var/shoes_strip_delay_reduction_stage = 5  // The points value after which the shoes_strip_delay_multiplier delay begins to reduce
	var/shoes_strip_delay_multiplier_min = 0.5  // Minimal level of strip_delay_multiplier

	var/damage_resistance_buff = 0  // How much the damage resistance is increased
	var/damage_resistance_buff_max = 0  // How much the resistance can possibly be increased
	var/damage_resistance_buff_delta = 0  // How much the damage_resistance_buff is increased with every point
	var/damage_resistance_buff_stage = 0  // The points value after which the damage resistance buff begins to be applied

	var/movespeed_buff = 0  // How much the creature is boosted
	var/movespeed_buff_max = 0.5  // How much the creature can possibly be boosted
	var/movespeed_buff_delta = 0.1  // How much the movespeed_buff is increased with every point
	var/movespeed_buff_stage = 10  // The points value after which the movement speed buff begins to be applied
	
	// These are abilities related vars
	var/camouflage_enabled = FALSE  // Determines if the creature has started hiding
	var/camouflaged = FALSE  // Determines if the creature is hidden
	var/is_leaping = FALSE  // Determines if the creature is leaping (used by the greater form)

/mob/living/carbon/shoepacabra/Initialize()
	add_verb(/mob/living/proc/mob_sleep)
	add_verb(/mob/living/proc/lay_down)

	create_bodyparts()
	create_internal_organs()

	update_stage()

	. = ..()

/mob/living/carbon/shoepacabra/slip()
	return FALSE

/mob/living/carbon/shoepacabra/create_internal_organs()
	internal_organs += new /obj/item/organ/brain/alien  // Let's hope nothing goes wrong with that
	internal_organs += new /obj/item/organ/tongue/shoepacabra
	internal_organs += new /obj/item/organ/eyes/night_vision
	internal_organs += new /obj/item/organ/liver
	internal_organs += new /obj/item/organ/ears
	internal_organs += new /obj/item/organ/lungs

	..()

/mob/living/carbon/shoepacabra/IsAdvancedToolUser()
	return FALSE

/mob/living/carbon/shoepacabra/can_use_guns(obj/item/G)
	return FALSE

/mob/living/carbon/shoepacabra/can_hold_items()
	return TRUE

/proc/is_consumable_footwear(obj/item/clothing/shoes/F)
	if (F.resistance_flags & (ACID_PROOF | INDESTRUCTIBLE))  // Make sure our little rascal doesn't ruin some antag's day
		return FALSE
	if (istype(F, /obj/item/clothing/shoes/bronze))
		return FALSE
	if (istype(F, /obj/item/clothing/shoes/magboots))
		return FALSE
	return TRUE

/* Consume footwear
Creature makes an attempt to consume the given footwear.
Accepts:
	F, the footwear that the creature should consume, deleted in case of success.
*/
/mob/living/carbon/shoepacabra/proc/consume_footwear(obj/item/clothing/shoes/F, instantly = FALSE)
	if (!is_consumable_footwear(F))
		to_chat(src, "<span class='notice'>As you take a bite you notice that [F] is way too robust for you to consume!</span>")

	instantly = instantly || (shoes_consumption_delay <= 0)
	if (!instantly)  // meh double check
		visible_message("<span class='danger'>[src] starts to [consume_verb] [F]!</span>", \
			"<span class='notice'>You start to [consume_verb] [F]...</span>")
	if (instantly || do_after(src, shoes_consumption_delay, target = F))
		visible_message("<span class='danger'>[src] [consume_verb]s [F]!</span>", \
			"<span class='notice'>You [consume_verb] [F]!</span>")
		stage_increment()
		adjust_nutrition(20)
		qdel(F)
		playsound(loc,'sound/items/eatfood.ogg', rand(10,50), 1)

/obj/item/clothing/shoes/attack(mob/living/carbon/shoepacabra/S, mob/living/carbon/shoepacabra/user)
	if (user == S)
		user.consume_footwear(src)
		return
	. = ..()

/* Stage increment
Updates the development stage.
Heals the creature.
Intended to be overriden.
*/
/mob/living/carbon/shoepacabra/proc/stage_increment()
	if (staging_message)
		to_chat(src, "<span class='notice'>[staging_message]</span>")
	points += 1

	movespeed_buff = -clamp((points-movespeed_buff_stage) * movespeed_buff_delta, 0, movespeed_buff_max)
	if (!entered_light)
		set_speedmod(movespeed_buff)
		light_exposure_cumulative = max(light_exposure_cumulative - shoes_healing_amount, 0)
		heal_overall_damage(shoes_healing_amount, shoes_healing_amount, shoes_healing_amount)

	if(points > shoes_consumption_reduction_stage)
		shoes_consumption_delay = max(shoes_consumption_delay - shoes_consumption_delta, 0)
	if(points > shoes_strip_delay_reduction_stage)
		shoes_strip_delay_multiplier = max(shoes_strip_delay_multiplier - shoes_strip_delay_multiplier_delta, shoes_strip_delay_multiplier_min)

	if(!immune_to_light)
		light_amount_threshold = min(light_amount_threshold + light_amount_threshold_delta, light_amount_threshold_max)
		if(light_amount_threshold >= 1)
			immune_to_light = TRUE
			light_exposure_cumulative = 0  // Make sure our creature won't stuck hurting for no reason when it becomes immune

	update_stage()

/* Update stage
Intended to be overriden.
Must check if current points value matches some development stage and apply the changes accordingly.
Preferably with "if" statements cascade but "switch" block should work too.
*/
/mob/living/carbon/shoepacabra/proc/update_stage()
	return

/* Steal shoes
The creature attempts to steal the target's footwear.
With grab intent, it will only put the shoes in the creatures hands.
With harm intent, it will make the creature try to consume the footwear in place.
Accepts:
	target, the human to steal footwear from
	aggressive, if it should eat the footwear in place and maim the target
Returns:
	TRUE if any action has been taken (even if it failed), FALSE otherwise
*/
/mob/living/carbon/shoepacabra/proc/steal_shoes(mob/living/carbon/human/target, aggressive = FALSE)
	var/obj/item/I = target.shoes
	if(aggressive)
		var/instantly = (shoes_strip_delay_multiplier <= 0 && shoes_consumption_delay <= 0)
		if(bloodthirsty)
			var/obj/item/bodypart/bodypart = target.get_bodypart(zone_selected)
			if (bodypart)
				var/armor_block = run_armor_check(bodypart, "melee","","",10)
				target.apply_damage(rand(SHOEPACABRA_LEG_DAMAGE_MIN, SHOEPACABRA_LEG_DAMAGE_MAX), BRUTE, bodypart, armor_block)
				playsound(loc, 'sound/weapons/slice.ogg', 25, 1, -1)
				if (rand(1, 100) <= SHOEPACABRA_LEG_DISMEMBERMENT_CHANCE)
					bodypart.dismember()
					visible_message("<span class='danger'>[src] tears [target]'s leg away with its powerful jaws!</span>", \
						"<span class='warning'>You tear [target]'s leg away!</span>")
				else
					visible_message("<span class='danger'>[src] fiercely bites [target]'s leg!</span>", \
						"<span class='warning'>You bite [target]'s leg!</span>")
			else
				return FALSE  // If there was no leg, return, for there would be no shoes aswell 
		if(I)
			if (!instantly && !bloodthirsty)  // Prevent double message from appearing
				visible_message("<span class='warning'>[src] starts to [consume_verb] [target]'s shoes right from their feet!</span>", \
					"<span class='warning'>You start to [consume_verb] [target]'s shoes right from their feet!</span>")
			if(instantly || do_after(src, (I.strip_delay*shoes_strip_delay_multiplier) + shoes_consumption_delay, TRUE, target, TRUE))
				target.doUnEquip(I, TRUE)
				consume_footwear(I, TRUE)
			return TRUE
		else
			return FALSE
	else if(I)
		var/instantly = shoes_strip_delay_multiplier <= 0
		if (!instantly)
			visible_message("<span class='warning'>[src] starts pulling [target]'s shoes off!</span>", \
				"<span class='warning'>You start pulling [target]'s shoes off!</span>")
		if(instantly || do_after(src, I.strip_delay * shoes_strip_delay_multiplier, TRUE, target, TRUE))
			target.dropItemToGround(I, TRUE)
			put_in_hands(I)
			visible_message("<span class='warning'>[src] stole your [I]!</span>", \
				"<span class='warning'>You steal [I] from [target]'s legs!</span>")
		return TRUE
	return FALSE

/* Set speedmod
Helper function created for easy access to the creature's speed modifier
Accepts:
	value, the multiplicative_slowdown
*/
/mob/living/carbon/shoepacabra/proc/set_speedmod(value)
	add_movespeed_modifier(MOVESPEED_ID_SHOEPACABRA_SPEEDMOD, TRUE, 100, override = TRUE, multiplicative_slowdown = value)

/* Leave camouflage
Ceases the creatures camouflage state
*/
/mob/living/carbon/shoepacabra/proc/leave_camouflage()
	camouflage_enabled = FALSE
	camouflaged = FALSE
	alpha = SHOEPACABRA_DEFAULT_TRANSPARENCY

	var/obj/effect/proc_holder/shoepacabra/camouflage/C = locate() in abilities
	if(istype(C))
		C.apply_cooldown()
		C.active = FALSE
		C.update_icon()
