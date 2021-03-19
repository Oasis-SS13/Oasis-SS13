//Santa spells!
/obj/effect/proc_holder/spell/aoe_turf/conjure/presents
	name = "Conjure Presents!"
	desc = "This spell lets you reach into S-space and retrieve presents! Yay!"
	school = "santa"
	charge_max = 600
	clothes_req = FALSE
	antimagic_allowed = TRUE
	invocation = "HO HO HO"
	invocation_type = "shout"
	range = 3
	cooldown_min = 50

	summon_type = list("/obj/item/a_gift")
	summon_lifespan = 0
	summon_amt = 5

/obj/effect/proc_holder/spell/aoe_turf/conjure/createmoney
	name = "Conjure Money!"
	desc = "You can summon anything, but only money matters!"
	action_icon_state = "money"
	summon_type = list("/obj/item/stack/spacecash/c1000")
	invocation_type = "shout"
	cooldown_min = 60
	clothes_req = FALSE
	antimagic_allowed = TRUE
	range = 1
	charge_max = 500
	invocation = "Hello, I like money!"
	summon_lifespan = 0
	summon_amt = 1

