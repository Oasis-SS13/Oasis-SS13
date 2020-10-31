/datum/emote/living/carbon/human/nya
	key = "nya"
	key_third_person = "lets out a nya"
	message = "lets out a nya!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/nya/get_sound(mob/living/carbon/human/H)
	if(H.gender == FEMALE)
		return 'Oasis/sound/misc/nya.ogg'
	else
		return // I dare you to add sound for this