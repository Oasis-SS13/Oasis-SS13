/obj/item/projectile/straycat
	name = "Air bubble"
	desc = "A bubble infused whit explosive power"
	icon_state = "straycat"
	speed = 4
	damage_type = BURN
	damage = 0

var/exp_heavy = 0
var/exp_light = 0.5
var/exp_flash = 1
var/exp_fire = 0

/obj/item/projectile/straycat/on_hit(target)
	. = ..()
	var/mob/living/M = target
	if(ismob(target))
		M.take_overall_damage(0,10) //between this 10 burn, the 10 brute, the explosion brute, and the onfire burn, your at about 65 damage if you stop drop and roll immediately
	var/turf/T = get_turf(target)
	explosion(T, -1, exp_heavy, exp_light, exp_flash, 0, flame_range = exp_fire)
	if(M.health <0)
		M.dust()



/obj/effect/proc_holder/spell/aimed/straycat
	name = "Airbomb"
	desc = "A airbubble charged whit explosive power"
	school = "evocation"
	charge_max = 200
	clothes_req = FALSE
	invocation = ""
	invocation_type = "shout"
	range = 40
	cooldown_min = 30
	projectile_type = /obj/item/projectile/straycat
	base_icon_state = "mdagger"
	action_icon_state = "mdagger0"
