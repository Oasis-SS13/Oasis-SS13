/* The only purpose of this little kludgy thing is to break open the rooms where the abandoned taco stand (/obj/effect/mob_spawn/shoepacabra) is spawned.
Since random rooms .dmm files only determine the contents of the rooms but not their entrances,
I had to break glasses and airlocks with this object so shoepacabras don't get stuck inside when spawned.

Any more elegant solution is welcome.
*/

/obj/effect/door_breaker
	name = "door breaker"

/obj/effect/door_breaker/Initialize()
	for(var/atom/O in view_or_range(2, src, "range"))
		var/obj/machinery/door/airlock/A = O
		if(istype(A))
			A.open()
			sleep(1)
			A.bolt()
			continue
		var/obj/structure/window/W = O
		if(istype(W))
			W.take_damage(1000, BRUTE, "melee", 0)
	del(src)