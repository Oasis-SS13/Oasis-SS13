/obj/item/projectile/bullet/shoepacabra_spit
	name = "shoepacabra spit"
	icon = 'Oasis/icons/obj/projectiles.dmi'
	icon_state = "shoepacabra_spit"
	var/reagent = /datum/reagent/cryptobiolin
	damage = 0

/obj/item/projectile/bullet/shoepacabra_spit/on_hit(atom/target, blocked = FALSE)
	nodamage = TRUE
	if(iscarbon(target))
		var/mob/living/carbon/human/H = target
		if(H.can_inject())
			H.reagents.add_reagent(reagent, SHOEPACABRA_SPIT_REAGENTS_AMOUNT)
	return ..()
