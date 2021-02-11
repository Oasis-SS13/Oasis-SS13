// 5.56mm (M-90gl Carbine)

/obj/item/projectile/bullet/a556
	name = "5.56mm bullet"
	damage = 35

// 7.62 (Nagant Rifle)

/obj/item/projectile/bullet/a762
	name = "7.62 bullet"
	damage = 60

/obj/item/projectile/bullet/a762_enchanted
	name = "enchanted 7.62 bullet"
	damage = 20
	stamina = 80

/obj/item/projectile/bullet/a44winchester
	name = ".44 bullet"
	damage = 25
	stamina = 10

/obj/item/projectile/bullet/a44winchester/Initialize()
	..()
	var/list/possible_sounds = list('Oasis/sound/44ricochet1.ogg', 'Oasis/sound/44ricochet2.ogg', 'Oasis/sound/44ricochet3.ogg', 'Oasis/sound/44ricochet4.ogg', 'Oasis/sound/44ricochet5.ogg', 'Oasis/sound/44ricochet6.ogg', 'Oasis/sound/44ricochet7.ogg')
	var/choosen_sound = pick(possible_sounds)
	hitsound_wall = choosen_sound