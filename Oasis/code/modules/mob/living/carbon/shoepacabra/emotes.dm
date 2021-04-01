/datum/emote/living/shoepacabra
	mob_type_allowed_typecache = list(/mob/living/carbon/shoepacabra)

/datum/emote/living/shoepacabra/hiss
	key = "hiss"
	key_third_person = "hisses"
	message = "hisses."

/datum/emote/living/shoepacabra/hiss/get_sound(mob/living/user)
	return "hiss"
