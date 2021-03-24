/obj/machinery/door/poddoor/attack_animal(mob/living/simple_animal/user)
	if(istype(user, /mob/living/simple_animal/hostile/statue/scp_173))
		add_fingerprint(user)
		user.visible_message("<span class='warning'>[src] refuses to budge!</span>")
		return
	else
		..()
