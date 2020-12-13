/obj/item/requiem_arrow
	name = "mysterious arrow"
	desc = "An ancient arrow. You feel poking yourself, or someone else with it would have... <span class='holoparasite'>unpredictable</span> results."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "requiemarrow"
	item_state = "requiemarrow"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	sharpness = IS_SHARP
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/kill_chance = 50 // people will still chuck these at the nearest security officer anyways, so who cares
	var/in_use = FALSE
	var/uses = 1
	var/users = list()

/obj/item/requiem_arrow/attack(mob/living/M, mob/living/user)
	if(in_use)
		return
	if(!M.client)
		return
	if(!isguardian(M))
		to_chat("<span class='italics warning'>You can't stab [M], it won't work!</span>")
		return
	if(M.stat == DEAD)
		to_chat("<span class='italics warning'>You can't stab [M], they're already dead!</span>")
		return
	var/mob/living/carbon/H = M
	var/mob/living/simple_animal/hostile/guardian/G = M
	user.visible_message("<span class='warning'>[user] prepares to stab [H] with \the [src]!</span>", "<span class='notice'>You raise \the [src] into the air.</span>")
	if(do_mob(user, H, 5 SECONDS, uninterruptible=FALSE))
		if(LAZYLEN(H.hasparasites()) || (H.mind && H.mind.has_antag_datum(/datum/antagonist/changeling)) || (isguardian(M) && (users[G] || G.requiem || G.transforming)))
			H.visible_message("<span class='holoparasite'>\The [src] rejects [H]!</span>")
			return
	if(isguardian(M))
		in_use = TRUE
		H.visible_message("<span class='holoparasite'>\The [src] embeds itself into [H], and begins to glow!</span>")
		user.dropItemToGround(src, TRUE)
		forceMove(H)
		INVOKE_ASYNC(src, .proc/requiem, M)
	if(!uses)
		visible_message("<span class='warning'>[src] falls apart!</span>")
		qdel(src)
/obj/item/requiem_arrow/proc/requiem(mob/living/simple_animal/hostile/guardian/G)
	G.range = 255
	G.transforming = TRUE
	G.visible_message("<span class='holoparasite'>[G] begins to melt!</span>")
	to_chat(G, "<span class='holoparasite'>This power... You can't handle it! RUN AWAY!</span>")
	log_game("[key_name(G)] was stabbed by a stand arrow, it is now becoming requiem.")
	var/i = 0
	var/flicker = TRUE
	while(i < 10)
		i++
		G.set_light(4, 10, rgb(rand(1, 127), rand(1, 127), rand(1, 127)))
		var/a = flicker ? 127 : 255
		flicker = !flicker
		animate(G, alpha = a, time = 5 SECONDS)
		sleep(5 SECONDS)
	G.stats.Unapply(G)
	G.requiem = TRUE
	G.name = "[G.name] Requiem"
	G.real_name = "[G.real_name] Requiem"
	G.mind.name = "[G.mind.name] Requiem"
	G.stats.damage = min(G.stats.damage + rand(1,3), 5)
	G.stats.defense = min(G.stats.defense + rand(1,3), 5)
	G.stats.speed = min(G.stats.speed + rand(1,3), 5)
	G.stats.potential = min(G.stats.potential + rand(1,3), 5)
	G.stats.range = min(G.stats.range + rand(1,3), 5)
	for(var/T in subtypesof(/datum/guardian_ability/minor))
		G.stats.TakeMinorAbility(T)
	QDEL_NULL(G.stats.ability)
	var/requiem_ability = null
	if(G.stats.ability == /datum/guardian_ability/major/explosive)
		requiem_ability = /datum/guardian_ability/major/special/explosive


	G.stats.ability = new requiem_ability
	G.stats.Apply(G)
	if(G.berserk)
		G.stats.ability.Berserk()
	else
		var/datum/antagonist/guardian/S = G.mind.has_antag_datum(/datum/antagonist/guardian)
		if(S)
			S.name = "Requiem Guardian"
	G.transforming = FALSE
	G.Recall(TRUE)
	G.visible_message("<span class='holoparasite'>\The [src] is absorbed into [G]!</span>")




