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

/datum/emote/living/meow
	key = "meow"
	key_third_person = "mrowls"
	message = "mrowls!"
	emote_type = EMOTE_AUDIBLE
    sound = 'modular_citadel/sound/voice/meow1.ogg'

/datum/emote/living/purr
	key = "purr"
	key_third_person = "purrs softly"
	message = "purrs softly."
	emote_type = EMOTE_AUDIBLE
	sound = 'modular_citadel/sound/voice/purr.ogg'
