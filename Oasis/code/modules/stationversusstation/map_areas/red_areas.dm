/area/svs
	has_gravity = TRUE

/area/svs/red/engine
	ambient_effects = ENGINEERING
	lighting_colour_tube = "#ffce93"
	lighting_colour_bulb = "#ffbc6f"

/area/svs/red/engine/engineering
	name = "Red Engineering"
	icon_state = "engine"

/area/svs/red/engine/atmos
	name = "Red Atmospherics"
	icon_state = "atmos"
	flags_1 = NONE

/area/svs/red/engine/engine_room
	name = "Red Engine Room"
	icon_state = "atmos_engine"

/area/svs/red/engine/storage
	name = "Red Engineering Storage"
	icon_state = "engi_storage"

/area/svs/red/security
	name = "Red Security"
	icon_state = "security"
	ambient_effects = HIGHSEC
	lighting_colour_tube = "#ffeee2"
	lighting_colour_bulb = "#ffdfca"

/area/svs/red/security/armory
	name = "Red Armory"

/area/svs/red/security/vault
	name = "Red Vault"
	icon_state = "nuke_storage"

/area/svs/red/security/vault/ore 
	name = "Red ORM"

/area/svs/red/security/vault/server
	name = "Red Server Room"

/area/svs/red/bridge
	name = "Red Bridge"
	icon_state = "bridge"
	ambient_effects = list('sound/ambience/signal.ogg')

	lighting_colour_tube = "#ffce99"
	lighting_colour_bulb = "#ffdbb4"
	lighting_brightness_tube = 8

/area/svs/red/bridge/admiral 
	name = "Red Admiral's Quarters"

/area/svs/red/science
	name = "Red Science Division"
	icon_state = "toxlab"
	lighting_colour_tube = "#f0fbff"
	lighting_colour_bulb = "#e4f7ff"

/area/svs/red/science/lab
	name = "Red Research and Development"
	icon_state = "toxlab"

/area/svs/red/cargo
	name = "Red Cargo Bay"
	icon_state = "cargo_bay"
	lighting_colour_tube = "#ffe3cc"
	lighting_colour_bulb = "#ffdbb8"

/area/svs/red/hallway
	name = "Red Primary Hallway"
	icon_state = "hallC"
	lighting_colour_tube = "#ffce99"
	lighting_colour_bulb = "#ffdbb4"
	lighting_brightness_tube = 8

/area/svs/red/break_room
	name = "Red Break Room"
	icon_state = "fitness"

/area/svs/red/nexus
	name = "Red Nexus"
	icon_state = "bridge"