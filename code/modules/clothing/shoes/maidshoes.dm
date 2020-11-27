/obj/item/clothing/shoes/maidshoes
	var/list/spelltypes = list	(
								/obj/effect/proc_holder/spell/aimed/spell_cards,
								/obj/effect/proc_holder/spell/aimed/triple_daggers,
								/obj/effect/proc_holder/spell/aimed/ricodagger,
								)
	var/list/spells = list()


/obj/item/clothing/shoes/maidshoes/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(slot == SLOT_SHOES)
		spells = new
		for(var/spell in spelltypes)
			var/obj/effect/proc_holder/spell/S = new spell
			spells += S
			S.charge_counter = 0
			S.start_recharge()
			H.mind.AddSpell(S)

/obj/item/clothing/shoes/maidshoes/dropped(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(SLOT_SHOES) == src)
		for(var/spell in spells)
			var/obj/effect/proc_holder/spell/S = spell
			H.mind.spell_list.Remove(S)
			qdel(S)
