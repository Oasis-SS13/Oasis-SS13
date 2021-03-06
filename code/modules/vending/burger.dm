/obj/machinery/vending/burger
	name = "\improper Fat n' Juicy"
	desc = "Buy all sorts of Burgers now!"
	product_slogans = "The best burgers in all the galaxy!"
	product_ads = "The best burgers in all the galaxy!;What are you waiting for?;Such a good taste!;Don't be shy lil' guy!;"
	icon_state = "burger"
	light_color = LIGHT_COLOR_BLUE
	products = list(/obj/item/reagent_containers/food/snacks/burger/cheese = 5,
				   /obj/item/reagent_containers/food/snacks/burger/baconburger = 5,
				   /obj/item/reagent_containers/food/snacks/burger/fish = 5,
				   /obj/item/reagent_containers/food/snacks/burger/chicken = 5,
				   /obj/item/reagent_containers/food/snacks/burger/mcguffin = 5,
				   /obj/item/reagent_containers/food/snacks/burger/rat = 3,
				   /obj/item/reagent_containers/food/snacks/burger/appendix = 2,
				   /obj/item/reagent_containers/food/snacks/burger/rib = 1,
				   /obj/item/reagent_containers/food/snacks/burger/tofu = 4)
	contraband = list(/obj/item/reagent_containers/food/snacks/burger/clown = 3,
				   /obj/item/reagent_containers/food/snacks/burger/mime = 3,
				   /obj/item/reagent_containers/food/snacks/burger/spell = 3)
	premium = list(/obj/item/reagent_containers/food/snacks/burger/crazy = 2)
	refill_canister = /obj/item/vending_refill/burger
	default_price = 10
	extra_price = 50
	payment_department = ACCOUNT_SRV

/obj/machinery/vending/burger/red
	icon_state = "burger-red"
	light_color = LIGHT_COLOR_RED

/obj/item/vending_refill/burger
	machine_name = "Fat n' Juicy"
	icon_state = "refill_custom"
