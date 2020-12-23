/obj/structure/chair/gym
	name = "gym chair"
	desc = "Someone might want to lie on it. It depends on you, though."
	icon = 'Oasis/icons/obj/gymchairs.dmi'
	icon_state = "wooden"
	buckle_lying = 90
	resistance_flags = FLAMMABLE
	max_integrity = 80
	buildstacktype = /obj/item/stack/sheet/mineral/wood
	buildstackamount = 2
	item_chair = null

// We don't handle layer, too bad.
/obj/structure/chair/gym/handle_layer()
	return

/obj/structure/chair/gym/metal
	name = "metal gym chair"
	desc = "Now this is metal. Nobody will like lying on it."
	icon_state = "metal"
	resistance_flags = NONE
	max_integrity = 200
	buildstacktype = /obj/item/stack/sheet/iron
