//desert mob corpses

/obj/effect/mob_spawn/human/corpse/cowboy
	name = "western corpse"
	outfit = /datum/outfit/cowboy
	skin_tone = "caucasian1"
	brute_damage = 100

/obj/effect/mob_spawn/human/corpse/cowboy/equip(mob/living/carbon/human/H)
	H.undershirt = "shirt_grey"
	..()

/datum/outfit/cowboy
	name = "Cowboy"
	head = /obj/item/clothing/head/franks_hat
	uniform = /obj/item/clothing/under/pants/classicjeans
	shoes = /obj/item/clothing/shoes/workboots
	suit = /obj/item/clothing/suit/security/officer/russian

/obj/effect/mob_spawn/human/corpse/cowboy/sheriff
	outfit = /datum/outfit/sheriff
	hair_style = "Bald"
	mob_gender = MALE
	facial_hair_style = "Goatee"

/datum/outfit/sheriff
	name = "Sheriff"
	mask = /obj/item/clothing/mask/cigarette/pipe
	head = /obj/item/clothing/head/franks_hat
	shoes = /obj/item/clothing/shoes/workboots
	suit = /obj/item/clothing/suit/armor/vest/det_suit
	uniform = /obj/item/clothing/under/rank/security/detective/grey
	gloves = /obj/item/clothing/gloves/fingerless

/obj/effect/mob_spawn/human/corpse/western_bandit
	name = "western bandit corpse"
	outfit = /datum/outfit/western_bandit
	skin_tone = "caucasian1"
	hair_style = "Bald"
	facial_hair_style = "Shaved"
	brute_damage = 100

/obj/effect/mob_spawn/human/corpse/western_bandit/equip(mob/living/carbon/human/H)
	H.undershirt = "shirt_grey"
	..()

/datum/outfit/western_bandit
	name = "Wild West Bandit"
	head = /obj/item/clothing/head/franks_hat
	uniform = /obj/item/clothing/under/pants/classicjeans
	shoes = /obj/item/clothing/shoes/workboots
	suit = /obj/item/clothing/suit/det_suit
	mask = /obj/item/clothing/mask/bandana/red
	gloves = /obj/item/clothing/gloves/fingerless
