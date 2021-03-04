#define MOUSE_GHOST_ROLE_ENABLED TRUE

/mob/living/simple_animal/mouse
	name = "mouse"
	desc = "It's a nasty, ugly, evil, disease-ridden rodent."
	icon_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	speak = list("Squeak!","SQUEAK!","Squeak?")
	speak_emote = list("squeaks")
	emote_hear = list("squeaks.")
	emote_see = list("runs in a circle.", "shakes.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 5
	health = 5
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab/mouse = 1)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "splats"
	density = FALSE
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	var/body_color //brown, gray and white, leave blank for random
	gold_core_spawnable = FRIENDLY_SPAWN
	var/chew_probability = 1
	var/time_to_chew = 5
	mobsay_color = "#82AF84"
	var/list/ratdisease = list()
	can_be_held = TRUE
	held_state = "mouse_gray"

/mob/living/simple_animal/mouse/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, list('sound/effects/mousesqueek.ogg'=1), 100)
	if(!body_color)
		body_color = pick( list("brown","gray","white") )
	icon_state = "mouse_[body_color]"
	icon_living = "mouse_[body_color]"
	icon_dead = "mouse_[body_color]_dead"
	if(prob(40))
		var/datum/disease/advance/R = new /datum/disease/advance/random(rand(2, 4))
		ratdisease += R

	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE //make mice see in the dark
	if(MOUSE_GHOST_ROLE_ENABLED && is_maintenance_mouse())
		add_to_spawner_menu()
	RegisterSignal(src, COMSIG_MOB_SAY, .proc/handle_speech) //make mice unable to communicate

/mob/living/simple_animal/mouse/sentience_act()
	. = ..()
	UnregisterSignal(src, COMSIG_MOB_SAY) //though when sentience is applied, mice should regain their ability of speech 

/mob/living/simple_animal/mouse/ghostize(can_reenter_corpse = TRUE)
	. = ..()
	if(. && stat != DEAD)
		add_to_spawner_menu()

/mob/living/simple_animal/mouse/proc/is_maintenance_mouse()
	var/turf/T = get_turf(src)
	if(!T || !is_station_level(T.z) || !is_station_level(z))
		return FALSE
	if(gold_core_spawnable == NO_SPAWN) //since Tom isn't a pet and we can not check the unique_pet variable, we will use gold_core_spawnable check as a kludge
		return FALSE
	return TRUE

/mob/living/simple_animal/mouse/proc/add_to_spawner_menu()
	LAZYADD(GLOB.mob_spawners["Maintenance mouse"], src)
	GLOB.poi_list |= src

/mob/living/simple_animal/mouse/get_spawner_desc()
	return "Do your business with the cheese and squeaking." //a mild reference to the hitchhiker's guide to the galaxy

/mob/living/simple_animal/mouse/get_spawner_flavour_text()
	return "You are a maintenance mouse. Cooperate with your fellow mice to go on a holy crusade for some cheese or just get toasted by gnawing the first cable you find."

/mob/living/simple_animal/mouse/attack_ghost(mob/user)
	. = ..()
	if(key || stat || !MOUSE_GHOST_ROLE_ENABLED)
		return
	var/mouse_ask = alert("Do you really want to become a mouse?", "Become a mouse?", "Yes", "No")
	if(mouse_ask == "No" || QDELETED(src))
		return
	if(key)
		to_chat(user, "<span class='warning'>Someone else already took this mouse!</span>")
		return
	key = user.key
	remove_from_spawner_menu()
	log_game("[key_name(src)] took control of [name].")

/mob/living/simple_animal/mouse/proc/remove_from_spawner_menu()
	for(var/spawner in GLOB.mob_spawners)
		LAZYREMOVE(GLOB.mob_spawners[spawner], src)
	GLOB.poi_list -= src

/mob/living/simple_animal/mouse/proc/handle_speech(datum/source, list/speech_args)
	speech_args[SPEECH_MESSAGE] = pick(speak)
	playsound(src, 'sound/effects/mousesqueek.ogg', 100, 1)

/mob/living/simple_animal/mouse/extrapolator_act(mob/user, var/obj/item/extrapolator/E, scan = TRUE)
	if(!ratdisease.len)
		return FALSE
	if(scan)
		E.scan(src, ratdisease, user)
	else
		E.extrapolate(src, ratdisease, user)
	return TRUE

/mob/living/simple_animal/mouse/proc/splat()
	src.health = 0
	src.icon_dead = "mouse_[body_color]_splat"
	death()

/mob/living/simple_animal/mouse/death(gibbed, toast)
	var/list/data = list("viruses" = ratdisease)
	if(!ckey)
		..(1)
		if(!gibbed)
			var/obj/item/reagent_containers/food/snacks/deadmouse/M = new(loc)
			M.icon_state = icon_dead
			M.name = name
			M.reagents.add_reagent(/datum/reagent/blood, 2, data)
			if(toast)
				M.add_atom_colour("#3A3A3A", FIXED_COLOUR_PRIORITY)
				M.desc = "It's toast."
		qdel(src)
	else
		..(gibbed)

/mob/living/simple_animal/mouse/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			to_chat(M, "<span class='notice'>[icon2html(src, M)] Squeak!</span>")
	..()

/mob/living/simple_animal/mouse/handle_automated_action()
	if(prob(chew_probability))
		var/turf/open/floor/F = get_turf(src)
		if(istype(F) && !F.intact)
			var/obj/structure/cable/C = locate() in F
			if(C && prob(15))
				chew_cable(C)

obj/structure/cable/attack_animal(mob/living/simple_animal/mouse/user)
	. = ..()
	to_chat(user, "<span class='notice'>You begin ravenously shredding insulation on [src] with your teeth...</span>")
	if(do_after(user, user.time_to_chew, TRUE, src))
		user.chew_cable(src)

/mob/living/simple_animal/mouse/proc/chew_cable(var/obj/structure/cable/C)
	if(C.avail())
		visible_message("<span class='warning'>[src] chews through [C]. It's toast!</span>")
		playsound(src, 'sound/effects/sparks2.ogg', 100, 1)
		C.deconstruct()
		death(toast=1)
	else
		C.deconstruct()
		visible_message("<span class='warning'>[src] chews through [C].</span>")

/*
 * Mouse types
 */

/mob/living/simple_animal/mouse/white
	body_color = "white"
	icon_state = "mouse_white"
	held_state = "mouse_white"

/mob/living/simple_animal/mouse/gray
	body_color = "gray"
	icon_state = "mouse_gray"

/mob/living/simple_animal/mouse/brown
	body_color = "brown"
	icon_state = "mouse_brown"
	held_state = "mouse_brown"

//TOM IS ALIVE! SQUEEEEEEEE~K :)
/mob/living/simple_animal/mouse/brown/Tom
	name = "Tom"
	desc = "Jerry the cat is not amused."
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "splats"
	gold_core_spawnable = NO_SPAWN

/obj/item/reagent_containers/food/snacks/deadmouse
	name = "dead mouse"
	desc = "It looks like somebody dropped the bass on it. A lizard's favorite meal. May contain diseases."
	icon = 'icons/mob/animal.dmi'
	icon_state = "mouse_gray_dead"
	bitesize = 3
	eatverb = "devour"
	list_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	foodtype = GROSS | MEAT | RAW
	grind_results = list(/datum/reagent/blood = 20, /datum/reagent/liquidgibs = 5)


/obj/item/reagent_containers/food/snacks/deadmouse/attackby(obj/item/I, mob/user, params)
	if(I.is_sharp() && user.a_intent == INTENT_HARM)
		if(isturf(loc))
			new /obj/item/reagent_containers/food/snacks/meat/slab/mouse(loc)
			to_chat(user, "<span class='notice'>You butcher [src].</span>")
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You need to put [src] on a surface to butcher it!</span>")
	else
		return ..()

/obj/item/reagent_containers/food/snacks/deadmouse/on_grind()
	reagents.clear_reagents()
