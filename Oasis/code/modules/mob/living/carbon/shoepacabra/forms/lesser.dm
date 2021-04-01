/mob/living/carbon/shoepacabra/shoepacabra_lesser
	name = "\the el pequeño shoepacabra"
	article = "el"
	icon_state = "shoepacabra_lesser"
	pass_flags = PASSTABLE
	ventcrawler = VENTCRAWLER_ALWAYS

	bodyparts = list(/obj/item/bodypart/chest/shoepacabra_lesser, /obj/item/bodypart/head/shoepacabra_lesser, /obj/item/bodypart/l_arm/shoepacabra_lesser,
					 /obj/item/bodypart/r_arm/shoepacabra_lesser, /obj/item/bodypart/r_leg/shoepacabra_lesser, /obj/item/bodypart/l_leg/shoepacabra_lesser)

/mob/living/carbon/shoepacabra/shoepacabra_lesser/update_stage()
	switch(points)
		if(0)
			consume_verb = "nibble"
			staging_message = "You feel yourself a little stronger... You want more!"
		if(5)
			to_chat(src, "<span class='notice'>You are now able to camouflage yourself in the darkness! Set up a decoy for your next victim!</span>")
			consume_verb = "gnaw"
			staging_message = "You feel stronger, but your hunger is insatiable..."

			AddAbility(new/obj/effect/proc_holder/shoepacabra/camouflage)
		if(10)
			to_chat(src, "<span class='notice'>You notice a new organ appear in your body. You are able to secrete slippery liquid on floor now.</span>")
			consume_verb = "gobble"
			staging_message = "You feel more powerful. The ascension is near..."
			
			var/obj/item/organ/lubricant_cyst/cyst = new()
			cyst.Insert(src, TRUE, FALSE)
		if(15)
			to_chat(src, "<span class='notice'>You are ready to evolve!</span>")
			consume_verb = "eat"
			staging_message = "You've reached the maximum capacity of this feeble body and food doesn't feel so satiable anymore. Time to evolve!"

			AddAbility(new/obj/effect/proc_holder/shoepacabra/evolve_to_greater)
