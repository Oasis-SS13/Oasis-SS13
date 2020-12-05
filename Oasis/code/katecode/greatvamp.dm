/datum/species/greatvamp
	name = "greatvamp"
	id = "great vampire"
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,DRINKSBLOOD,)
	inherent_traits = list(TRAIT_NOHUNGER,TRAIT_NOBREATH,TRAIT_LIGHT_STEP,TRAIT_FREERUNNING,MADE_UNCLONEABLE)
	inherent_biotypes = list(MOB_UNDEAD, MOB_HUMANOID)
	default_features = list("mcolor" = "FFF", "tail_human" = "None", "ears" = "None", "wings" = "None")
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | ERT_SPAWN
	exotic_bloodtype = "U"
	use_skintones = TRUE
	mutant_heart = /obj/item/organ/heart/vampire
	mutanttongue = /obj/item/organ/tongue/vampire
	limbs_id = "human"
	skinned_type = /obj/item/stack/sheet/animalhide/human
	burnmod = 2
	heatmod = 1.5
	brutemod = 0.8
	toxmod = 0
	clonemod = 0
	staminamod = 0.5
	var/info_text = "You are a <span class='danger'>Great vampire</span>. while you lack the cheap transmutation powers of young vampires, you pack enougth firepower to compensate."
	var/obj/effect/proc_holder/spell/aimed/space_bems,
	var/obj/effect/proc_holder/spell/targeted/touch/frezze,
	var/datum/martial_art/vampire,
/datum/species/greatvamp/on_species_gain(mob/living/carbon/human/C, datum/species/old_species)
	. = ..()
	var/datum/martial_art/vampire/martial_art = new(null)
		martial_art.teach(C)
	to_chat(C, "[info_text]")
	C.skin_tone = "albino"
	C.update_body(0)
	if(isnull(space_bems))
		space_bems = new /obj/effect/proc_holder/spell/aimed/space_bems
		C.AddSpell(space_bems)
	if(isnull(frezze))
		frezze = new /obj/effect/proc_holder/spell/targeted/touch/frezze
		C.AddSpell(frezze)
/datum/species/greatvamp/on_species_loss(mob/living/carbon/C)
	. = ..()
	to_chat(C, "<span class='spider'>You feel your souless body crumbling as the undead strength that kept you together dissapears</span>")
	C.dust()




/datum/species/greatvamp/spec_life(mob/living/carbon/human/C)
	. = ..()
	if(istype(C.loc, /obj/structure/closet/crate/coffin))
		C.heal_overall_damage(8,8,0, BODYPART_ORGANIC)
		C.adjustToxLoss(-4)
		C.adjustOxyLoss(-4)
		C.adjustCloneLoss(-4)
		return
	C.blood_volume -= 1.20
	if(C.blood_volume <= BLOOD_VOLUME_SURVIVE)
		to_chat(C, "<span class='danger'>You ran out of blood!</span>")
		var/obj/shapeshift_holder/H = locate() in C
		if(H)
			H.shape.dust() //make sure we're killing the bat if you are out of blood, if you don't it creates weird situations where the bat is alive but the caster is dusted.
		C.dust()
	var/area/A = get_area(C)
	if(istype(A, /area/chapel))
		to_chat(C, "<span class='danger'>You don't belong here!</span>")
		C.adjustFireLoss(20)
		C.adjust_fire_stacks(6)
		C.IgniteMob()

/datum/species/greatvamp/check_species_weakness(obj/item/weapon, mob/living/attacker)
	if(istype(weapon, /obj/item/nullrod/whip))
		return 1 //Whips deal 2x damage to vampires. Vampire killer.
	return 0

/obj/item/organ/tongue/vampire
	name = "vampire tongue"
	actions_types = list(/datum/action/item_action/organ_action/vampire)
	color = "#1C1C1C"
	drain_cooldown = 0

#define VAMP_DRAIN_AMOUNT 50

/datum/action/item_action/organ_action/vampire
	name = "Drain Victim"
	desc = "Leech blood from any carbon victim you are passively grabbing."

/datum/action/item_action/organ_action/vampire/Trigger()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/H = owner
		var/obj/item/organ/tongue/vampire/V = target
		if(V.drain_cooldown >= world.time)
			to_chat(H, "<span class='notice'>You just drained blood, wait a few seconds.</span>")
			return
		if(H.pulling && iscarbon(H.pulling))
			var/mob/living/carbon/victim = H.pulling
			if(H.blood_volume >= BLOOD_VOLUME_MAXIMUM)
				to_chat(H, "<span class='notice'>You're already full!</span>")
				return
			if(victim.stat == DEAD)
				to_chat(H, "<span class='notice'>You need a living victim!</span>")
				return
			if(!victim.blood_volume || (victim.dna && ((NOBLOOD in victim.dna.species.species_traits) || victim.dna.species.exotic_blood)))
				to_chat(H, "<span class='notice'>[victim] doesn't have blood!</span>")
				return
			V.drain_cooldown = world.time + 30
			if(victim.anti_magic_check(FALSE, TRUE, FALSE))
				to_chat(victim, "<span class='warning'>[H] tries to bite you, but stops before touching you!</span>")
				to_chat(H, "<span class='warning'>[victim] is blessed! You stop just in time to avoid catching fire.</span>")
				return
			if(victim?.reagents?.has_reagent(/datum/reagent/consumable/garlic))
				to_chat(victim, "<span class='warning'>[H] tries to bite you, but recoils in disgust!</span>")
				to_chat(H, "<span class='warning'>[victim] reeks of garlic! you can't bring yourself to drain such tainted blood.</span>")
				return
			if(!do_after(H, 30, target = victim))
				return
			var/blood_volume_difference = BLOOD_VOLUME_MAXIMUM - H.blood_volume //How much capacity we have left to absorb blood
			var/drained_blood = min(victim.blood_volume, VAMP_DRAIN_AMOUNT, blood_volume_difference)
			to_chat(victim, "<span class='danger'>[H] is draining your blood!</span>")
			to_chat(H, "<span class='notice'>You drain some blood!</span>")
			playsound(H, 'sound/items/drink.ogg', 30, 1, -2)
			victim.blood_volume = CLAMP(victim.blood_volume - drained_blood, 0, BLOOD_VOLUME_MAXIMUM)
			H.blood_volume = CLAMP(H.blood_volume + drained_blood, 0, BLOOD_VOLUME_MAXIMUM)
			if(!victim.blood_volume)
				to_chat(H, "<span class='warning'>You finish off [victim]'s blood supply!</span>")

#undef VAMP_DRAIN_AMOUNT

/obj/item/organ/heart/vampire
	name = "vampire heart"
	actions_types = list(/datum/action/item_action/organ_action/vampire_heart)
	color = "#1C1C1C"

/datum/action/item_action/organ_action/vampire_heart
	name = "Check Blood Level"
	desc = "Check how much blood you have remaining."

/datum/action/item_action/organ_action/vampire_heart/Trigger()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/H = owner
		to_chat(H, "<span class='notice'>Current blood level: [H.blood_volume]/[BLOOD_VOLUME_MAXIMUM].</span>")

