obj/effect/projectile/tracer/vampire
	name = "spaceshoot"
	icon_state = "vampire"

/obj/effect/projectile/muzzle/vampire
	icon_state = "muzzle_vamp"

/obj/effect/projectile/impact/vampire
	name = "spaceshoot_hit"
	icon_state = "impact_vamp"

/obj/item/projectile/space_beam
    name = "space beam"
    icon_state = "spacebeam"
    damage_type = BURN
    damage = 20
    range = 20
    dismemberment = 30
    hitscan = TRUE
    impact_effect_type = /obj/effect/temp_visual/impact_effect/purple_laser
    tracer_type = /obj/effect/projectile/tracer/vampire
    muzzle_type = /obj/effect/projectile/muzzle/vampire
    impact_type = /obj/effect/projectile/impact/vampire

/datum/status_effect/freon/vampire
	duration = 50
	can_melt = FALSE




obj/effect/proc_holder/spell/aimed/space_bems
	name = "Space beams"
	desc = "You shoot gama radiation from your eyes"
	school = "evocation"
	charge_max = 150
	clothes_req = FALSE
	invocation = "Fool!!"
	invocation_type = "shout"
	range = 40
	cooldown_min = 150
	projectile_amount = 1
	projectiles_per_fire = 1
	projectile_type = /obj/item/projectile/space_beam
	base_icon_state = "spacebeam"
	action_icon_state = "spacebeam0"


/obj/effect/proc_holder/spell/targeted/touch/frezze
	name = "Frost body"
	desc = "You cool your body enougth to frezze people alive"
	hand_path = /obj/item/melee/touch_attack/frezze

	school = "transmutation"
	charge_max = 200
	clothes_req = FALSE
	cooldown_min = 200 //100 deciseconds reduction per rank

	action_icon_state = "Frezze"
	sound = 'sound/magic/fleshtostone.ogg'




/obj/item/melee/touch_attack/frezze
	name = "\improper Frezzing temperature"
	desc = "Cold..."
	catchphrase = "Frezze pesant!!"
	on_use_sound = 'sound/magic/fleshtostone.ogg'
	icon_state = "frezze"
	item_state = "frezze"

/obj/item/melee/touch_attack/frezze/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity || target == user || !isliving(target) || !iscarbon(user)) //getting hard after touching yourself would also be bad
		return
	if(!(user.mobility_flags & MOBILITY_USE))
		to_chat(user, "<span class='warning'>You can't reach out!</span>")
		return
	if(istype(target, /mob/living))
		var/mob/living/M = target
		M.apply_status_effect(/datum/status_effect/freon/vampire)
		M.Stun(40)
		M.bodytemperature = -40
		return ..()
#define BLOODSUCKERMARTIAL "Vampire style"
#define DONUT "DH" //Donuts your oponent whit a heavy punch, takes 3 seconds to charge
#define THEWORLD "GHHDGH" //a high damaging timestop combo
#define BARRAGE "HHH" //barrages the victim
#define EYE_GAUGE "GHD" //EYE GAUGE - short confusion and blurred eyes

/datum/martial_art/vampire
	name = "Vampire style"
	id = BLOODSUCKERMARTIAL
	no_guns = TRUE
	block_chance = 75
	smashes_tables = TRUE
	allow_temp_override = FALSE
	help_verb = /mob/living/carbon/human/proc/vampire_help

/datum/martial_art/vampire/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(findtext(streak,DONUT))
		streak = ""
		donut(A,D)
		return 1
	if(findtext(streak,THEWORLD))
		streak = ""
		the_world(A,D)
		return 1
	if(findtext(streak,BARRAGE))
		streak = ""
		barrage(A,D)
		return 1
	if(findtext(streak,EYE_GAUGE))
		streak = ""
		eye_gauge(A,D)
		return 1
	return 0
/datum/martial_art/vampire/proc/barrage(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat)
		A.say("THIS IS THE GREATEST HIGH!!")
		log_combat(A, D, "Barraged (Vampire)")
		D.visible_message("<span class='warning'>[A] Barraged [D] !</span>", \
							"<span class='userdanger'>[A] Barraged you!</span>", null, COMBAT_MESSAGE_RANGE)
		for(var/i in 1 to 3)
			basic_hit(A,D)
			playsound(A.loc, 'sound/weapons/punch1.ogg', 15, 1, -1)
			sleep(1)
		D.apply_damage(20, BRUTE)
		return 1
	else
		log_combat(A, D, "Kick barraged(vampire)")
		A.say("USELESS USELESS USELESS!!")
		for(var/E in 1 to 4)
			A.do_attack_animation(D, ATTACK_EFFECT_KICK)
			basic_hit(A,D)
			D.apply_damage(4)
			playsound(A.loc, 'sound/weapons/punch1.ogg', 40, 1, -1)
			sleep(1)
		return 1
//Stops time whit a low dmg combo
/datum/martial_art/vampire/proc/the_world(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat)
		A.say("This is where the fun begins!")
		log_combat(A, D, "Punched (Vampire)")
		D.visible_message("<span class='warning'>Stopped Time!</span>", null, COMBAT_MESSAGE_RANGE)
		playsound(get_turf(D), 'sound/weapons/theworld.ogg', 100, 1, -1)
		new /obj/effect/timestop(get_turf(A), 2, 50, list(A))
		A.do_attack_animation(D, ATTACK_EFFECT_KICK)
		return 1
	return basic_hit(A,D)


/datum/martial_art/vampire/proc/donut(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat)
		var/atk_verb
		to_chat(A, "<span class='spider'>You prepare your fist</span>")
		A.say("DIE [D]!!")
		if(!do_after(A, 40, target = D))
			to_chat(A, "<span class='spider'><b>Your attack was interrupted!</b></span>")
			return TRUE //martial art code was a mistake
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		atk_verb = pick("punches", "smashes", "ruptures", "cracks")
		D.visible_message("<span class='danger'>[A] [atk_verb] [D] with inhuman strength, sending [D.p_them()] flying backwards!</span>", \
						"<span class='userdanger'>[A] [atk_verb] you with inhuman strength, sending you flying backwards!</span>")
		D.apply_damage(rand(80), A.dna.species.attack_type)
		playsound(D, 'sound/misc/splort.ogg', 70, 1, -1)
		D.Paralyze(20)
		var/obj/item/bodypart/chest = D.get_bodypart(BODY_ZONE_CHEST)
		chest.dismember()
		var/throwtarget = get_edge_target_turf(A, get_dir(A, get_step_away(D, A)))
			D.throw_at(throwtarget, 30, 2, A)//So stuff gets tossed around at the same time.
		if(atk_verb)
			log_combat(A, D, "[atk_verb] (vampire)")
		return TRUE
	else
		var/atk_verb
		to_chat(A, "<span class='spider'>Juse to be sure fist</span>")
		A.say("ALL RIGTH? [D]!!")
		D.visible_message("<span class='warning'>[A] Prepares to chop [D] head off!</span>")
		if(!do_after(A, 30, target = D))
			to_chat(A, "<span class='spider'><b>W-WHAT!</b></span>")
			return TRUE //martial art code was a mistake
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		atk_verb = pick("punches", "smashes", "ruptures", "cracks")
		D.visible_message("<span class='danger'>[A] [atk_verb] [D] Skull whit inhumane strength Destroying it!</span>", \
						"<span class='userdanger'>[A] [atk_verb] your skull  with inhuman strength, Killing you!</span>")
		D.apply_damage(rand(80), A.dna.species.attack_type)
		playsound(D, 'sound/misc/splort.ogg', 70, 1, -1)
		D.Paralyze(20)
		var/obj/item/bodypart/head = D.get_bodypart(BODY_ZONE_HEAD)
		head.dismember()
		if(atk_verb)
			log_combat(A, D, "[atk_verb] (vampire)")
		return TRUE
// Vampire Chop - short confusion and blurred eyes
/datum/martial_art/vampire/proc/eye_gauge(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D.stat)
		log_combat(A, D, "Blinded (Vampire)")
		D.visible_message("<span class='warning'>[A] jabbed  [D] in eye!</span>", \
							"<span class='userdanger'>[A] vampire chopped you in the neck!</span>", null, COMBAT_MESSAGE_RANGE)
		playsound(get_turf(A), 'sound/weapons/thudswoosh.ogg', 75, 1, -1)
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		D.blur_eyes(20)
		D.confused += 4
		D.Stun(30)
		D.emote("scream")
		return 1
	return basic_hit(A,D)

/datum/martial_art/vampire/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("H",D)
	if(check_streak(A,D))
		return 1
	return ..()

/datum/martial_art/vampire/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("G",D)
	if(check_streak(A,D))
		return 1
	return ..()

/datum/martial_art/vampire/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	add_to_streak("D",D)
	if(check_streak(A,D))
		return 1
	return ..()
/mob/living/carbon/human/proc/vampire_help()
	set name = "sharpen your fangs"
	set desc = "You sharpen your fangs and perpare for a figth"
	set category = "Vampire Style"

	to_chat(usr, "<b><i>You remember the Vampire Style</i></b>")

	to_chat(usr, "<span class='notice'>Donut</span>: Disarm Harm . Donuts your oponent whit a heavy punch, takes 3 seconds to charge.")
	to_chat(usr, "<span class='notice'>The World </span>: Grab Harm Harm Disarm Grab Harm. A low damage timestop combo.")
	to_chat(usr, "<span class='notice'>Barrage</span>:Harm Harm Harm. barrages the victim.")
	to_chat(usr, "<span class='notice'>Eye Gauge</span>: Grab Harm Disarm.short confusion and blurred eyes .")



















