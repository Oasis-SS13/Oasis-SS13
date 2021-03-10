GLOBAL_VAR_INIT(svs_team_red_credits, 5000)
GLOBAL_VAR_INIT(svs_team_blue_credits, 5000)
// hacky as fuck but we have a tight deadline






/obj/item/circuitboard/machine/cargoTeleporter
	name = "cargo teleporter (Machine Board)"
	icon_state = "generic"
	build_path = /obj/machinery/svs/cargoTeleporter
	var/team = ""

/obj/machinery/svs/cargoTeleporter
	name = "cargo teleporter"
	desc = "State-of-the-art teleporter machine, designed to teleport various crates between pre-set locations. Due to safety concerns, is unable to teleport organic matter."
	var/team = ""
	

// sorry no cargo for now;
// tight deadline. maybe in the future

/obj/machinery/svs/nexus
	name = "Nexus"
	desc = "A nexus for one of the teams. If this is destroyed, it will net the opposing team a point."
	icon = 'icons/obj/device.dmi'
	icon_state = "syndbeacon"
	max_integrity = 600
	density = TRUE

/obj/machinery/svs/nexus/Destroy()
	to_chat(world, "<span class='command_headset>The [src] has been destroyed!</span>")
	return ..()

/obj/machinery/svs/nexus/red
	name = "Red Nexus"
	desc = "Red Team's nexus. If it is destroyed, Blue Team will earn a point."

/obj/machinery/svs/nexus/blue
	name = "Blue Nexus"
	desc = "Blue Team's nexus. If it is destroyed, Red Team will earn a point."
	icon_state = "bluebeacon"