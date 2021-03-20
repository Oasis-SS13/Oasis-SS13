/obj/item/storage/pill_bottle/dice
	name = "bag of dice"
	desc = "Contains all the luck you'll ever need."
	icon = 'icons/obj/dice.dmi'
	icon_state = "dicebag"
	pill_variance = 0

/obj/item/storage/pill_bottle/dice/Initialize()
	. = ..()
	var/special_die = pick("1","2","fudge","space","00","8bd20","4dd6","100")
	if(special_die == "1")
		new /obj/item/dice/d1(src)
	if(special_die == "2")
		new /obj/item/dice/d2(src)
	new /obj/item/dice/d4(src)
	new /obj/item/dice/d6(src)
	if(special_die == "fudge")
		new /obj/item/dice/fudge(src)
	if(special_die == "space")
		new /obj/item/dice/d6/space(src)
	new /obj/item/dice/d8(src)
	new /obj/item/dice/d10(src)
	if(special_die == "00")
		new /obj/item/dice/d00(src)
	new /obj/item/dice/d12(src)
	new /obj/item/dice/d20(src)
	if(special_die == "8bd20")
		new /obj/item/dice/eightbd20(src)
	if(special_die == "4dd6")
		new /obj/item/dice/fourdd6(src)
	if(special_die == "100")
		new /obj/item/dice/d100(src)

/obj/item/storage/pill_bottle/dice/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is gambling with death! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (OXYLOSS)

/obj/item/storage/pill_bottle/dice_cup
	name = "dice cup"
	desc = "For rolling several dice at once. A favorite of street urchins."
	icon = 'icons/obj/dice.dmi'
	icon_state = "dicecup"
	pill_variance = 0

/obj/item/storage/pill_bottle/dice_cup/attack_self(mob/user)
	var/turf/throw_target = get_step(loc,user.dir) //with telekinesis, throws the direction the user is facing
	for(var/obj/item/dice/die in src)
		die.forceMove(drop_location())
		die.throw_at(throw_target,1,1,user)

/obj/item/dice //depreciated d6, use /obj/item/dice/d6 if you actually want a d6
	name = "die"
	desc = "A die with six sides. Basic and serviceable."
	icon = 'icons/obj/dice.dmi'
	icon_state = "d6"
	w_class = WEIGHT_CLASS_TINY
	var/sides = 6
	var/result = null
	var/list/special_faces = list() //entries should match up to sides var if used
	var/microwave_riggable = TRUE

	var/rigged = DICE_NOT_RIGGED
	var/rigged_value

/obj/item/dice/Initialize()
	. = ..()
	if(!result)
		result = roll(sides)
	update_icon()

/obj/item/dice/examine(mob/user)
	. = ..()
	. += "<span class='notice'>[result] is face up.</span>"

/obj/item/dice/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is gambling with death! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (OXYLOSS)

/obj/item/dice/greed_die
	name = "Greed Die"
	desc = "The name may be more apt than one thinks. (Don't roll the die if you fear death, really.)"
	icon_state = "greed"
	sides = 6
	var/die_variance = 1/6 //probability floor has a different icon state
	var/die_type = "greed-"
	var/i
	var/special
	var/isgolem = FALSE
	var/is_ore = 0
	var/cooldown = 10 // 1 seconds
	var/last_used = 0

/obj/item/dice/greed_die/attack_self(mob/living/carbon/M)
	result = roll(1, 6)
	if((last_used + cooldown) < world.time)
		if(prob(1) && isgolem == FALSE)
			result = 7
			update_icon()
			to_chat(M, "<span class='userdanger'>Gotcha!</span>")
			M.set_species(/datum/species/golem/capitalist)
			isgolem = TRUE
		else
			update_icon()
			if(result == 1)
				var/turf/T = get_step(get_step(M, NORTH), NORTH)
				T.Beam(M, icon_state="lightning[rand(1,12)]", time = 5)
				M.adjustFireLoss(45)
				new /datum/hallucination/shock(M, TRUE)
				to_chat(M, "<span class='userdanger'>The die rolled a 1! Poor you...</span>")

			if(result == 2)
				to_chat(M, "<span class='userdanger'>The die rolled a 2! No luck.. huh ?</span>")
				//M.Stun(20, 1, 1)
				for(i=1; i<8; i++)
					new /obj/effect/temp_visual/target(get_turf(M))
					sleep(8-i*0.9)
				to_chat(M, "<span class='warning'>You slipped on the ground!</span>")
				M.emote("scream")
				M.Paralyze(10)
				new /obj/effect/temp_visual/target(get_turf(M))
				sleep(2)
				new /obj/effect/temp_visual/target(get_turf(M))
				sleep(2)
				new /obj/effect/temp_visual/target(get_turf(M))

			if(result == 3)
				to_chat(M, "<span class='userdanger'>The die rolled a 3! Try again, I'm sure you will gain something...</span>")
				for(i=0; i<9; i = i+1)
					new /datum/hallucination/oh_yeah(M, TRUE)
					M.adjustBruteLoss(5)
					sleep(10-i*1.1)

			if(result == 4)
				var/turf/T = get_turf(M)
				to_chat(M, "<span class='userdanger'>The die rolled a 4! Here is some iron.</span>")
				new /obj/item/stack/sheet/iron/twenty(T)

			if(result == 5)
				var/turf/T = get_turf(M)
				is_ore = rand(1,3)
				if(is_ore == 1)
					new /obj/item/stack/sheet/mineral/gold/ten(T)
					to_chat(M, "<span class='userdanger'>The die rolled a 5! Here is some gold, lucky!</span>")
				if(is_ore == 2)
					new /obj/item/stack/sheet/mineral/silver/ten(T)
					to_chat(M, "<span class='userdanger'>The die rolled a 5! Here is some silver?</span>")
				if(is_ore == 3)
					new /obj/item/stack/sheet/mineral/copper/ten(T)
					to_chat(M, "<span class='userdanger'>The die rolled a 5! Here is some copper!</span>")

			if(result == 6)
				var/turf/T = get_turf(M)
				is_ore = rand(1,4)
				if(is_ore == 1)
					new /obj/item/stack/sheet/mineral/diamond/five(T)
					to_chat(M, "<span class='userdanger'>The die rolled a 6! Here is some diamonds !</span>")
				if(is_ore == 2)
					new /obj/item/stack/sheet/mineral/bananium/five(T)
					to_chat(M, "<span class='userdanger'>The die rolled a 6! Here is some bananium, you wont stop 'til you get the real big prize ?!</span>")
				if(is_ore == 3)
					new /obj/item/stack/sheet/mineral/plasma/five(T)
					to_chat(M, "<span class='userdanger'>The die rolled a 6! Here is some plasma, I know you like it.</span>")
				if(is_ore == 4)
					new /obj/item/stack/sheet/mineral/uranium/five(T)
					to_chat(M, "<span class='userdanger'>The die rolled a 6! Here is some uranium, be aware of its radiations</span>")
		last_used = world.time

/obj/item/dice/d1
	name = "d1"
	desc = "A die with only one side. Deterministic!"
	icon_state = "d1"
	sides = 1

/obj/item/dice/d2
	name = "d2"
	desc = "A die with two sides. Coins are undignified!"
	icon_state = "d2"
	sides = 2

/obj/item/dice/d4
	name = "d4"
	desc = "A die with four sides. The nerd's caltrop."
	icon_state = "d4"
	sides = 4

/obj/item/dice/d4/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop, 4)

/obj/item/dice/d6
	name = "d6"

/obj/item/dice/d6/space
	name = "space cube"
	desc = "A die with six sides. 6 TIMES 255 TIMES 255 TILE TOTAL EXISTENCE, SQUARE YOUR MIND OF EDUCATED STUPID: 2 DOES NOT EXIST."
	icon_state = "spaced6"

/obj/item/dice/d6/space/Initialize()
	. = ..()
	if(prob(10))
		name = "spess cube"

/obj/item/dice/fudge
	name = "fudge die"
	desc = "A die with six sides but only three results. Is this a plus or a minus? Your mind is drawing a blank..."
	sides = 3 //shhh
	icon_state = "fudge"
	special_faces = list("minus","blank","plus")

/obj/item/dice/d8
	name = "d8"
	desc = "A die with eight sides. It feels... lucky."
	icon_state = "d8"
	sides = 8

/obj/item/dice/d10
	name = "d10"
	desc = "A die with ten sides. Useful for percentages."
	icon_state = "d10"
	sides = 10

/obj/item/dice/d00
	name = "d00"
	desc = "A die with ten sides. Works better for d100 rolls than a golf ball."
	icon_state = "d00"
	sides = 10

/obj/item/dice/d12
	name = "d12"
	desc = "A die with twelve sides. There's an air of neglect about it."
	icon_state = "d12"
	sides = 12

/obj/item/dice/d20
	name = "d20"
	desc = "A die with twenty sides. The preferred die to throw at the GM."
	icon_state = "d20"
	sides = 20

/obj/item/dice/d100
	name = "d100"
	desc = "A die with one hundred sides! Probably not fairly weighted..."
	icon_state = "d100"
	w_class = WEIGHT_CLASS_SMALL
	sides = 100

/obj/item/dice/d100/update_icon()
	return

/obj/item/dice/eightbd20
	name = "strange d20"
	desc = "A weird die with raised text printed on the faces. Everything's white on white so reading it is a struggle. What poor design!"
	icon_state = "8bd20"
	sides = 20
	special_faces = list("It is certain","It is decidedly so","Without a doubt","Yes, definitely","You may rely on it","As I see it, yes","Most likely","Outlook good","Yes","Signs point to yes","Reply hazy try again","Ask again later","Better not tell you now","Cannot predict now","Concentrate and ask again","Don't count on it","My reply is no","My sources say no","Outlook not so good","Very doubtful")

/obj/item/dice/eightbd20/update_icon()
	return

/obj/item/dice/fourdd6
	name = "4d d6"
	desc = "A die that exists in four dimensional space. Properly interpreting them can only be done with the help of a mathematician, a physicist, and a priest."
	icon_state = "4dd6"
	sides = 48
	special_faces = list("Cube-Side: 1-1","Cube-Side: 1-2","Cube-Side: 1-3","Cube-Side: 1-4","Cube-Side: 1-5","Cube-Side: 1-6","Cube-Side: 2-1","Cube-Side: 2-2","Cube-Side: 2-3","Cube-Side: 2-4","Cube-Side: 2-5","Cube-Side: 2-6","Cube-Side: 3-1","Cube-Side: 3-2","Cube-Side: 3-3","Cube-Side: 3-4","Cube-Side: 3-5","Cube-Side: 3-6","Cube-Side: 4-1","Cube-Side: 4-2","Cube-Side: 4-3","Cube-Side: 4-4","Cube-Side: 4-5","Cube-Side: 4-6","Cube-Side: 5-1","Cube-Side: 5-2","Cube-Side: 5-3","Cube-Side: 5-4","Cube-Side: 5-5","Cube-Side: 5-6","Cube-Side: 6-1","Cube-Side: 6-2","Cube-Side: 6-3","Cube-Side: 6-4","Cube-Side: 6-5","Cube-Side: 6-6","Cube-Side: 7-1","Cube-Side: 7-2","Cube-Side: 7-3","Cube-Side: 7-4","Cube-Side: 7-5","Cube-Side: 7-6","Cube-Side: 8-1","Cube-Side: 8-2","Cube-Side: 8-3","Cube-Side: 8-4","Cube-Side: 8-5","Cube-Side: 8-6")

/obj/item/dice/fourdd6/update_icon()
	return

/obj/item/dice/attack_self(mob/user)
	diceroll(user)

/obj/item/dice/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	diceroll(thrownby)
	. = ..()

/obj/item/dice/proc/diceroll(mob/user)
	result = roll(sides)
	if(rigged != DICE_NOT_RIGGED && result != rigged_value)
		if(rigged == DICE_BASICALLY_RIGGED && prob(CLAMP(1/(sides - 1) * 100, 25, 80)))
			result = rigged_value
		else if(rigged == DICE_TOTALLY_RIGGED)
			result = rigged_value

	. = result

	var/fake_result = roll(sides)//Daredevil isn't as good as he used to be
	var/comment = ""
	if(sides == 20 && result == 20)
		comment = "NAT 20!"
	else if(sides == 20 && result == 1)
		comment = "Ouch, bad luck."
	update_icon()
	if(initial(icon_state) == "d00")
		result = (result - 1)*10
	if(special_faces.len == sides)
		result = special_faces[result]
	if(user != null) //Dice was rolled in someone's hand
		user.visible_message("[user] has thrown [src]. It lands on [result]. [comment]", \
							 "<span class='notice'>You throw [src]. It lands on [result]. [comment]</span>", \
							 "<span class='italics'>You hear [src] rolling, it sounds like a [fake_result].</span>")
	else if(!src.throwing) //Dice was thrown and is coming to rest
		visible_message("<span class='notice'>[src] rolls to a stop, landing on [result]. [comment]</span>")

/obj/item/dice/update_icon()
	cut_overlays()
	add_overlay("[src.icon_state]-[src.result]")

/obj/item/dice/microwave_act(obj/machinery/microwave/M)
	if(microwave_riggable)
		rigged = DICE_BASICALLY_RIGGED
		rigged_value = result
	..(M)
