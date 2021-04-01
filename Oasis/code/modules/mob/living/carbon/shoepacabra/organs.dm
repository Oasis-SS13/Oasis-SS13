/obj/item/organ/lubricant_cyst
	name = "lubricant cyst"
	icon_state = "acid"
	zone = BODY_ZONE_PRECISE_GROIN
	slot = "lubricantcyst"
	var/power = new/obj/effect/proc_holder/shoepacabra/lubricant_secretion

/obj/item/organ/lubricant_cyst/Insert(mob/living/carbon/M, special = 0)
	..()
	M.AddAbility(power)

/obj/item/organ/lubricant_cyst/Remove(mob/living/carbon/M, special = 0)
	M.RemoveAbility(power)
	..()

/obj/item/organ/shoepacabra_secrete_gland
	name = "shoepacabra secrete gland"
	icon_state = "acid"
	zone = BODY_ZONE_PRECISE_MOUTH
	slot = "secretegland"
	var/power = new/obj/effect/proc_holder/shoepacabra/spit

/obj/item/organ/shoepacabra_secrete_gland/Insert(mob/living/carbon/M, special = 0)
	..()
	M.AddAbility(power)

/obj/item/organ/shoepacabra_secrete_gland/Remove(mob/living/carbon/M, special = 0)
	M.RemoveAbility(power)
	..()

/obj/item/organ/tongue/shoepacabra
	name = "shoepacabrian tongue"
	desc = "A strange tongue found only in footwearvorous creatures."
	icon_state = "tonguexeno"

/obj/item/organ/tongue/shoepacabra/Initialize(mapload)
	. = ..()
	languages_possible = typecacheof(list(/datum/language/shoepacabrish))
