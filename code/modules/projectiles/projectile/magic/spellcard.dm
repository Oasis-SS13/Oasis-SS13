/obj/item/projectile/dagger
    name = "Arcane Dagger"
    desc = "A dagger enchanted to give it extreme durability and stiffness, along with edges sharp enough to slice anyone unfortunate enough to get hit by a charged one."
    icon_state = "dagger_1"
    damage_type = BRUTE
    damage = 2
    ricochet_chance = 100
    ricochets_max = 2
    
/obj/item/projectile/dagger/Initialize()
    . = ..()
    icon_state = "dagger_[rand(1, 3)]"
