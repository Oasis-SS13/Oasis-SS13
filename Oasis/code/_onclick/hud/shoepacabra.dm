/* Just a reduced copy of monkey hud with Rest button added
*/

/datum/hud/shoepacabra/New(mob/living/carbon/shoepacabra/owner)
	..()
	var/atom/movable/screen/using

	action_intent = new /atom/movable/screen/act_intent()
	action_intent.icon = ui_style
	action_intent.icon_state = mymob.a_intent
	action_intent.screen_loc = ui_acti
	action_intent.hud = src
	static_inventory += action_intent

	using = new /atom/movable/screen/mov_intent()
	using.icon = ui_style
	using.icon_state = (mymob.m_intent == MOVE_INTENT_RUN ? "running" : "walking")
	using.screen_loc = ui_movi
	using.hud = src
	static_inventory += using

	using = new/atom/movable/screen/language_menu
	using.icon = ui_style
	using.hud = src
	static_inventory += using

	using = new/atom/movable/screen/drop()
	using.icon = ui_style
	using.screen_loc = ui_drop_throw
	using.hud = src
	static_inventory += using

	using = new/atom/movable/screen/rest()
	using.icon = ui_style
	using.screen_loc = ui_above_movement
	using.hud = src
	static_inventory += using

	build_hand_slots()

	using = new /atom/movable/screen/swap_hand()
	using.icon = ui_style
	using.icon_state = "swap_1_m"
	using.screen_loc = ui_swaphand_position(owner,1)
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/swap_hand()
	using.icon = ui_style
	using.icon_state = "swap_2"
	using.screen_loc = ui_swaphand_position(owner,2)
	using.hud = src
	static_inventory += using

	throw_icon = new /atom/movable/screen/throw_catch()
	throw_icon.icon = ui_style
	throw_icon.screen_loc = ui_drop_throw
	throw_icon.hud = src
	hotkeybuttons += throw_icon

	internals = new /atom/movable/screen/internals()
	internals.hud = src
	infodisplay += internals

	healths = new /atom/movable/screen/healths()
	healths.hud = src
	infodisplay += healths

	pull_icon = new /atom/movable/screen/pull()
	pull_icon.icon = ui_style
	pull_icon.update_icon()
	pull_icon.screen_loc = ui_above_movement
	pull_icon.hud = src
	static_inventory += pull_icon

	lingchemdisplay = new /atom/movable/screen/ling/chems()
	lingchemdisplay.hud = src
	infodisplay += lingchemdisplay

	lingstingdisplay = new /atom/movable/screen/ling/sting()
	lingstingdisplay.hud = src
	infodisplay += lingstingdisplay


	zone_select = new /atom/movable/screen/zone_sel()
	zone_select.icon = ui_style
	zone_select.update_icon()
	zone_select.hud = src
	static_inventory += zone_select

	mymob.client.screen = list()

	using = new /atom/movable/screen/resist()
	using.icon = ui_style
	using.screen_loc = ui_above_intent
	using.hud = src
	hotkeybuttons += using

	for(var/atom/movable/screen/inventory/inv in (static_inventory + toggleable_inventory))
		if(inv.slot_id)
			inv.hud = src
			inv_slots[inv.slot_id] = inv
			inv.update_icon()

/datum/hud/shoepacabra/persistent_inventory_update()
	if(!mymob)
		return
	var/mob/living/carbon/shoepacabra/M = mymob

	if(hud_version != HUD_STYLE_NOHUD)
		for(var/obj/item/I in M.held_items)
			I.screen_loc = ui_hand_position(M.get_held_index_of_item(I))
			M.client.screen += I
	else
		for(var/obj/item/I in M.held_items)
			I.screen_loc = null
			M.client.screen -= I
