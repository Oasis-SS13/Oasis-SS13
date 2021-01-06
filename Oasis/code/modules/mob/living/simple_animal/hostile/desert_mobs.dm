
//CIVILIAN//

/mob/living/simple_animal/hostile/retaliate/cowboy
	name = "Angry civilian"
	desc = "A civilian of a small place that was forgotten by god ages ago."
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "cowboy"
	icon_living = "cowboy"
	mob_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	del_on_death = TRUE
	faction = list("cowboy")
	icon_dead = null
	in_melee = TRUE
	minbodytemp = 0
	maxbodytemp = 1500
	dodge_prob = 50
	sidestep_per_cycle = 3
	deathsound = 'sound/voice/human/wilhelm_scream.ogg'
	speak_chance = 5
	speak = list("Yeehaw!")
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 0
	deathmessage = "collapses"
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	approaching_target = TRUE
	maxHealth = 100
	health = 100
	melee_damage = 11
	attacktext = "punches"
	attack_sound = 'sound/weapons/punch1.ogg'
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 0
	status_flags = CANPUSH
	search_objects = 1
	var/cooldown = 0
	do_footstep = TRUE
	loot = list(/obj/effect/mob_spawn/human/corpse/cowboy)

/mob/living/simple_animal/hostile/retaliate/cowboy/Aggro()
	..()
	if (cooldown < world.time)
		cooldown = world.time + 300
		summon_backup(20)
		var/list/possible_phrases = list("That's it, you will die now!", "Oh, fuck you!", "You'll pay for this!")
		var/chosen_phrase = pick(possible_phrases)
		say(chosen_phrase)
	else
		return

/mob/living/simple_animal/hostile/retaliate/cowboy/Life()
	..()
	if(health <= 35)
		in_melee = FALSE
		rapid_melee = 3
		approaching_target = FALSE
		dodging = TRUE
		speed = -1
		move_to_delay = 1
		retreat_distance = 15
		speak_chance = 50
		speak = list("No!", "You won't get me!", "I'm not dying today!", "I need help!")
	else
		return

/mob/living/simple_animal/hostile/retaliate/cowboy/rifle
	name = "Angry cowboy with a rifle"
	desc = "This one got a long gun."
	icon_state = "cowboyrifle"
	icon_living = "cowboyrifle"
	melee_damage = 15
	attacktext = "beats"
	speed = 5
	attack_sound = 'sound/weapons/genhit.ogg'
	speak_chance = 0
	check_friendly_fire = 1
	melee_queue_distance = 4
	minimum_distance = 9
	in_melee = FALSE
	ranged = TRUE
	dodging = FALSE
	approaching_target = FALSE
	ranged_cooldown_time = 15
	casingtype = /obj/item/ammo_casing/a44winchester
	loot = list(/obj/effect/mob_spawn/human/corpse/cowboy, /obj/item/gun/ballistic/winchester)
	var/mag_count = 14

/mob/living/simple_animal/hostile/retaliate/cowboy/rifle/Shoot(atom/targeted_atom)
	if(mag_count <= 0)
		return
	var/list/possible_sounds = list('Oasis/sound/winchestershot.ogg', 'Oasis/sound/winchestershot2.ogg', 'Oasis/sound/winchestershot3.ogg')
	var/choosen_sound = pick(possible_sounds)
	playsound(get_turf(src), choosen_sound, 80, 0, 0)
	mag_count = mag_count - 1
	..()
	sleep(5)
	playsound(get_turf(src), 'Oasis/sound/winchesterrack.ogg', 50, 0, 0)

/mob/living/simple_animal/hostile/retaliate/cowboy/rifle/OpenFire(atom/A)
	if(mag_count == 0)
		var/list/possible_phrases = list("Cover me, I'm reloading!", "I'm empty, reloading!", "Gotta reload!", "I'm reloading!")
		var/chosen_phrase = pick(possible_phrases)
		say(chosen_phrase)
		ranged = FALSE
		retreat_distance = 6
		minimum_distance = 15
		var/datum/callback/cb = CALLBACK(src, .proc/Load)
		for(var/i in 1 to initial(mag_count))
			addtimer(cb, (i - 1)*3)
	else
		..()

/mob/living/simple_animal/hostile/retaliate/cowboy/rifle/proc/Load()
	if(mag_count == initial(mag_count))
		return
	else
		mag_count = mag_count + 1
		playsound(get_turf(src), 'sound/weapons/shotguninsert.ogg', 70, 0, 0)
		if(mag_count == initial(mag_count))
			sleep(10)
			ranged = TRUE
			retreat_distance = initial(retreat_distance)
			minimum_distance = initial(minimum_distance)
			playsound(get_turf(src), 'Oasis/sound/winchesterrack.ogg', 70, 0, 0)

/mob/living/simple_animal/hostile/retaliate/cowboy/rifle/Life()
	. = ..()
	if(health <= 20)
		speak_chance = 35
		speak = list("Argh! I'm hurt!", "You will die next!", "Shit...")
	else
		return

/mob/living/simple_animal/hostile/retaliate/cowboy/rifle/Aggro()
	. = ..()
	if (cooldown < world.time)
		cooldown = world.time + 300
		summon_backup(5)
		var/list/possible_phrases = list("Shoot this bitch!", "You better dodge now!", "Shoot them!")
		var/chosen_phrase = pick(possible_phrases)
		say(chosen_phrase)
	else
		return

/mob/living/simple_animal/hostile/retaliate/sheriff
	name = "Sheriff"
	desc = "You are going to jail, dead or alive."
	maxHealth = 250
	health = 250
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "sheriff"
	icon_living = "sheriff"
	mob_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	del_on_death = TRUE
	projectiletype = /obj/item/projectile/bullet/n762
	projectilesound = 'sound/weapons/revolver357shot.ogg'
	move_to_delay = 2
	speed = 2
	dodging = TRUE
	dodge_prob = 80
	minbodytemp = 0
	maxbodytemp = 1500
	melee_damage = 12
	ranged = TRUE
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 0
	rapid_fire_delay = 5
	deathmessage = "collapses"
	ranged_cooldown_time = 20
	melee_queue_distance = 3
	rapid_melee = 3
	minimum_distance = 5
	in_melee = FALSE
	faction = list("cowboy")
	loot = list(/obj/effect/mob_spawn/human/corpse/cowboy/sheriff, /obj/item/gun/ballistic/revolver/nagant)
	var/ability_cooldown = 0
	var/ability_cooldown_time = 200
	var/ability_prob = 50
	var/mag_count = 7
	var/cooldown = 0

//Ability - shoot with revolver rel fast

/mob/living/simple_animal/hostile/retaliate/sheriff/Aggro()
	..()
	if (cooldown < world.time)
		cooldown = world.time + 300
		summon_backup_nosound(20)
		playsound(get_turf(src), 'Oasis/sound/whistle.ogg', 70, 0, 0)
		var/list/possible_phrases = list("Get this criminal!", "You're going down!", "Know the law you bastard!", "Wanna kill an old man, huh?")
		var/chosen_phrase = pick(possible_phrases)
		say(chosen_phrase)
	else
		return

/mob/living/simple_animal/hostile/retaliate/sheriff/Life()
	. = ..()
	if(health < 50)
		speak = list("Damn it...", "Ah, they got me!", "I guess today's the day", "I'm too old for this...", "Oh no...")
		speak_chance = 30
	else
		return

/mob/living/simple_animal/hostile/retaliate/sheriff/proc/Load()
	if(mag_count == initial(mag_count))
		return
	else
		mag_count = mag_count + 1
		playsound(get_turf(src), 'sound/weapons/revolverload.ogg', 50, 0, 0)
		if(mag_count == initial(mag_count))
			sleep(5)
			var/list/possible_sounds = list('sound/weapons/revolverspin1.ogg', 'sound/weapons/revolverspin2.ogg', 'sound/weapons/revolverspin3.ogg')
			var/chosen_sound = pick(possible_sounds)
			playsound(get_turf(src), chosen_sound, 70, 1, 0)
			ranged = TRUE
			retreat_distance = initial(retreat_distance)
			minimum_distance = initial(minimum_distance)

/mob/living/simple_animal/hostile/retaliate/sheriff/proc/summon_backup_nosound(distance, exact_faction_match)
	do_alert_animation(src)
	for(var/mob/living/simple_animal/hostile/M in oview(distance, targets_from))
		if(faction_check_mob(M, TRUE))
			if(M.AIStatus == AI_OFF)
				return
			else
				M.Goto(src,M.move_to_delay,M.minimum_distance)

/mob/living/simple_animal/hostile/retaliate/sheriff/death(gibbed)
	var/list/possible_sounds = list('sound/magic/curse.ogg', 'sound/voice/human/malescream_5.ogg', 'sound/voice/human/wilhelm_scream.ogg', 'sound/voice/lizard/deathsound.ogg')
	var/chosen_sound = pick(possible_sounds)
	playsound(get_turf(src), chosen_sound, 80, 0, 0)
	..()

/mob/living/simple_animal/hostile/retaliate/sheriff/OpenFire(atom/A)
	if(mag_count <= 0)
		var/list/possible_phrases = list("I've got more bullets for ya!", "It's alright I've got enough bullets!", "More bullets for your skull, mate!", "Don't go anywhere while I'm reloading!")
		var/chosen_phrase = pick(possible_phrases)
		say(chosen_phrase)
		ranged = FALSE
		retreat_distance = 6
		minimum_distance = 9
		var/datum/callback/ul = CALLBACK(src, .proc/Unload)
		for(var/i in 1 to initial(mag_count))
			addtimer(ul, (i - 1)*0.1)
		playsound(get_turf(src), 'sound/weapons/revolverempty.ogg', 60, 0, 0)
		sleep(10)
		var/datum/callback/cb = CALLBACK(src, .proc/Load)
		for(var/i in 1 to initial(mag_count))
			addtimer(cb, (i - 1)*4)
	if (ability_cooldown < world.time && prob(ability_prob) && mag_count == initial(mag_count))
		var/list/possible_phrases = list("I will make you calm!", "Justice!", "Don't move, freak!", "This one will go right between the eyes.")
		var/chosen_phrase = pick(possible_phrases)
		say(chosen_phrase)
		var/list/possible_sounds = list('sound/weapons/revolverspin1.ogg', 'sound/weapons/revolverspin2.ogg', 'sound/weapons/revolverspin3.ogg')
		var/chosen_sound = pick(possible_sounds)
		playsound(get_turf(src), chosen_sound, 70, 1, 0)
		sleep(30)
		var/datum/callback/cb = CALLBACK(src, .proc/Shoot, A)
		for(var/i in 1 to mag_count)
			addtimer(cb, (i - 1)*2)
		ability_cooldown = world.time + ability_cooldown_time
	else
		..()

/mob/living/simple_animal/hostile/retaliate/sheriff/proc/Unload()
	var/obj/item/ammo_casing/spent/C = new
	C.forceMove(drop_location())
	C.bounce_away(FALSE, NONE)

/mob/living/simple_animal/hostile/retaliate/sheriff/Shoot(atom/targeted_atom)
	if(mag_count <= 0)
		return
	else
		mag_count = mag_count - 1
	..()

//BANDIT//

//Some of them have a chance to toss a dynamite and then go on cooldown//

/mob/living/simple_animal/hostile/western_bandit
	name = "Bandit"
	desc = "A kind of person that usually likes to rob and kill."
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "raider"
	icon_living = "raider"
	del_on_death = TRUE
	faction = list("bandit")
	icon_dead = null
	in_melee = TRUE
	mob_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	minbodytemp = 0
	maxbodytemp = 1500
	dodge_prob = 25
	sidestep_per_cycle = 2
	speak_chance = 10
	speak = list("I will kill you!", "His suit is expensive, take it!", "You won't escape now!")
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 0
	deathmessage = "collapses"
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	approaching_target = TRUE
	maxHealth = 130
	health = 130
	melee_damage = 10
	attacktext = "punches"
	attack_sound = 'sound/weapons/punch1.ogg'
	a_intent = INTENT_HARM
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 0
	status_flags = CANPUSH
	search_objects = 1
	var/cooldown = 0
	do_footstep = TRUE
	loot = list(/obj/effect/mob_spawn/human/corpse/western_bandit)

/mob/living/simple_animal/hostile/western_bandit/Aggro()
	..()
	if (cooldown < world.time)
		cooldown = world.time + 300
		summon_backup(10)
	else
		return

/mob/living/simple_animal/hostile/western_bandit/death(gibbed)
	var/list/possible_sounds = list('sound/voice/human/malescream_1.ogg', 'sound/voice/human/malescream_2.ogg', 'sound/voice/human/malescream_3.ogg', 'sound/voice/human/malescream_4.ogg', 'sound/voice/human/malescream_5.ogg')
	var/chosen_sound = pick(possible_sounds)
	playsound(get_turf(src), chosen_sound, 60, 1, 0)
	..()

/mob/living/simple_animal/hostile/western_bandit/grenade
	minimum_distance = 6
	retreat_distance = 6
	var/grenade = new /obj/item/grenade/syndieminibomb/dynamite
	var/ability_prob = 15
	var/ability_cooldown = 0
	var/ability_cooldown_time = 150

//Ability - throw a dynamite

/mob/living/simple_animal/hostile/western_bandit/grenade/Goto(target, delay, minimum_distance)
	..()
	if (ability_cooldown < world.time && prob(ability_prob))
		ability_cooldown = world.time + ability_cooldown_time
		var/list/possible_phrases = list("I'll fuck you up!", "Grenade!", "Fire in the hole!")
		var/chosen_phrase = pick(possible_phrases)
		say(chosen_phrase)
		addtimer(CALLBACK(src, .proc/TossGrenade, target, src), 20)

/mob/living/simple_animal/hostile/western_bandit/grenade/proc/TossGrenade(atom/A)
	var/obj/item/grenade/G = grenade
	G.forceMove(src.loc)
	G.throw_at(A, 30, 2, src)
	G.active = 1
	G.icon_state = initial(G.icon_state) + "_active"
	playsound(src.loc, 'sound/effects/fuse.ogg', 75, 1, -3)
	addtimer(CALLBACK(G, /obj/item/grenade.proc/prime), 30)

/mob/living/simple_animal/hostile/western_bandit/grenade/shotgun_sawn
	minimum_distance = 2
	speed = 1
	ranged = TRUE
	check_friendly_fire = 1
	in_melee = FALSE
	casingtype = /obj/item/ammo_casing/shotgun/buckshot
	rapid = 2
	ability_prob = 30
	ability_cooldown_time = 200
	rapid_fire_delay = 0.1
	icon_state = "raidershottie"
	icon_living = "raidershottie"
	projectilesound = 'sound/weapons/shotgunshot.ogg'
	ranged_cooldown_time = 30
	ability_prob = 30
	ability_cooldown = 0
	ability_cooldown_time = 150
	loot = list(/obj/effect/mob_spawn/human/corpse/western_bandit, /obj/item/gun/ballistic/shotgun/doublebarrel/sawnoff)

/mob/living/simple_animal/hostile/western_bandit/grenade/shotgun_sawn/Shoot(atom/targeted_atom)
	..()
	sleep(20)
	playsound(get_turf(src), 'sound/weapons/shotguninsert.ogg', 70, 0, 0)
	sleep(10)
	playsound(get_turf(src), 'sound/weapons/shotguninsert.ogg', 70, 0, 0)

/mob/living/simple_animal/hostile/western_bandit/grenade/shotgun_sawn/OpenFire(atom/A)
	..()
	if (ability_cooldown < world.time && prob(ability_prob))
		ability_cooldown = world.time + ability_cooldown_time
		var/list/possible_phrases = list("I'll get them out!", "Run, bitch!", "You're dead!")
		var/chosen_phrase = pick(possible_phrases)
		say(chosen_phrase)
		addtimer(CALLBACK(src, .proc/TossGrenade, A, src), 20)