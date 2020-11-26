/obj/item/projectile/bdagger
	name = "bouncing trowing dagger"
	desc = "a dagger bouncing at high speeds"
	icon_state = "dagger_4"
	damage_type = BRUTE
	damage = 15
	armour_penetration = 75
	speed =  0.4
	ricochet_chance = 100
	ricochets_max = 20

/obj/item/projectile/bdagger/check_ricochet_flag(atom/A)
    return TRUE

/obj/item/projectile/bdagger/on_ricochet(atom/A)
	. = ..()
	damage += 5


