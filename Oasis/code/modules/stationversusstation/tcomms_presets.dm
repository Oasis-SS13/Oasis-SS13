/datum/outfit/job/svs
	name = "Station Versus Station Base Outfit"
	ears = /obj/item/radio/headset
	shoes = /obj/item/clothing/shoes/jackboots

///// BLUE TEAM /////

/datum/outfit/job/svs/blue
	name = "SVS Blue Team Outfit"
	uniform = /obj/item/clothing/under/rank/security/officer/blueshirt
	jobtype = /datum/job/svs/blue

/datum/outfit/job/svs/blue/miner
	name = "SVS Blue Miner Outfit"
	uniform = /obj/item/clothing/under/rank/security/officer/blueshirt
	jobtype = /datum/job/svs/blue/miner
	suit = /obj/item/clothing/suit/space/syndicate/blue
	head = /obj/item/clothing/head/helmet/space/syndicate/blue

/datum/outfit/job/svs/blue/admiral
	name = "SVS Blue Admiral Outfit"
	uniform = /obj/item/clothing/under/rank/civilian/head_of_personnel
	suit = /obj/item/clothing/suit/space/officer/svs/blue
	jobtype = /datum/job/svs/blue/admiral

/datum/outfit/job/svs/blue/post_equip(mob/living/carbon/human/H)
	..()
	var/obj/item/radio/R = H.ears
	R.set_frequency(FREQ_CTF_BLUE)
	R.freqlock = TRUE
	R.independent = TRUE

/datum/outfit/job/svs/blue/admiral/post_equip(mob/living/carbon/human/H)
	..()
	var/obj/item/radio/R = H.ears
	R.use_command = TRUE
	R.command = TRUE

///// RED TEAM /////

/datum/outfit/job/svs/red
	name = "SVS Red Team Outfit"
	uniform = /obj/item/clothing/under/rank/security/officer
	jobtype = /datum/job/svs/red

/datum/outfit/job/svs/red/miner
	name = "SVS Red Miner Outfit"
	uniform = /obj/item/clothing/under/rank/security/officer
	jobtype = /datum/job/svs/red/miner
	suit = /obj/item/clothing/suit/space/syndicate
	head = /obj/item/clothing/head/helmet/space/syndicate

/datum/outfit/job/svs/red/admiral
	name = "SVS Red Admiral Outfit"
	uniform = /obj/item/clothing/under/rank/security/head_of_security
	suit = /obj/item/clothing/suit/space/officer/svs/red
	jobtype = /datum/job/svs/red/admiral

/datum/outfit/job/svs/red/post_equip(mob/living/carbon/human/H)
	..()
	var/obj/item/radio/R = H.ears
	R.set_frequency(FREQ_CTF_RED)
	R.freqlock = TRUE
	R.independent = TRUE

/datum/outfit/job/svs/red/admiral/post_equip(mob/living/carbon/human/H)
	..()
	var/obj/item/radio/R = H.ears
	R.use_command = TRUE
	R.command = TRUE
