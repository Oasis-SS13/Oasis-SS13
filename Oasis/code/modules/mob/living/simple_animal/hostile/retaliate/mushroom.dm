
/mob/living/simple_animal/hostile/retaliate/spongy_mushroom
	name = "Spongy Mushroom"
	desc = "It's a massive spongy mushroom... with legs?"
	icon_state = "spongyshroom"
	icon_living = "spongyshroom"
	icon_dead = "spongyshroom_dead"
	speak_chance = 0
	turns_per_move = 1
	maxHealth = 80
	health = 80
	butcher_results = list(/obj/item/reagent_containers/food/snacks/hugemushroomslice = 1)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "whacks"
	obj_damage = 0
	melee_damage = 1
	attack_same = 0
	search_objects = 1
	wanted_objects = list(/mob/living/simple_animal/butterfly, /mob/living/simple_animal/cat, /mob/living/simple_animal/mouse)
	attacktext = "chomps"
	attack_sound = 'sound/weapons/bite.ogg'
	faction = list("mushroom")
	environment_smash = ENVIRONMENT_SMASH_NONE
	mouse_opacity = MOUSE_OPACITY_ICON
	vision_range = 11
	speed = 1
	a_intent = INTENT_HARM
	ventcrawler = VENTCRAWLER_ALWAYS
	robust_searching = 1
	unique_name = 1
	speak_emote = list("squeaks")
	deathmessage = "passed out and rotten."
	var/powerlevel = 0 //Tracks our general strength level gained from eating other shrooms
	var/recovery_cooldown = 0 //So you can't repeatedly revive it during a fight
	var/faint_ticker = 0 //If we hit three, another mushroom's gonna eat us
	var/datum/reagent/spongyent = list(/datum/reagent/drug/space_drugs = 5, /datum/reagent/drug/aranesp = 4, /datum/reagent/drug/happiness = 3)
	var/poison_per_bite1 = 5
	var/poison_type1 = /datum/reagent/drug/space_drugs
	var/poison_per_bite2 = 2
	var/poison_type2 = /datum/reagent/drug/aranesp
	var/poison_per_bite3 = 5
	var/poison_type3 = /datum/reagent/drug/happiness

/mob/living/simple_animal/hostile/retaliate/spongy_mushroom/examine(mob/user)
	. = ..()
	if(health >= maxHealth)
		. += "<span class='info'>It looks healthy and spongy.</span>"
	else
		. += "<span class='info'>It looks like it's been roughed up.</span>"

/mob/living/simple_animal/hostile/retaliate/spongy_mushroom/Life()
	if(!stat)//Mushrooms slowly regenerate if conscious, for people who want to save them from being eaten
		adjustBruteLoss(-2)

/mob/living/simple_animal/hostile/retaliate/spongy_mushroom/adjustHealth(amount, updating_health = TRUE, forced = FALSE) //Possibility to flee from a fight just to make it more visually interesting
	if(!retreat_distance && prob(33))
		retreat_distance = 5
		addtimer(CALLBACK(src, .proc/stop_retreat), 30)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/spongy_mushroom/proc/stop_retreat()
	retreat_distance = null

/mob/living/simple_animal/hostile/retaliate/spongy_mushroom/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(prob(33) && L.reagents)
			L.reagents.add_reagent(poison_type1, poison_per_bite1)
		else if(prob(50) && L.reagents)
			L.reagents.add_reagent(poison_type2, poison_per_bite2)
		else
			L.reagents.add_reagent(poison_type3, poison_per_bite3)


/mob/living/simple_animal/hostile/retaliate/spongy_mushroom/death(gibbed)
	..(gibbed)

/mob/living/simple_animal/hostile/retaliate/spongy_mushroom/attack_hand(mob/living/H)
	if(isliving(H))
		spongyent.reaction_mob(H, INJECT)
		H.reagents.add_reagent(spongyent, rand(1,5))

/*/mob/living/simple_animal/hostile/retaliate/spongy_mushroom/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	..()
	if(istype(AM, /obj/item))
		var/obj/item/T = AM
		if(T.throwforce)
*/

/mob/living/simple_animal/hostile/retaliate/spongy_mushroom/harvest()
	var/counter
	for(counter=0, counter<=powerlevel, counter++)
		var/obj/item/reagent_containers/food/snacks/hugemushroomslice/S = new /obj/item/reagent_containers/food/snacks/hugemushroomslice(src.loc)
		S.reagents.add_reagent(/datum/reagent/drug/mushroomhallucinogen, powerlevel)
		S.reagents.add_reagent(/datum/reagent/medicine/omnizine, powerlevel)
		S.reagents.add_reagent(/datum/reagent/medicine/synaptizine, powerlevel)
