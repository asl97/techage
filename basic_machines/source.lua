--[[

	TechAge
	=======

	Copyright (C) 2019 Joachim Stolberg

	LGPLv2.1+
	See LICENSE.txt for more information

	TA2/TA3/TA4 Power Source
	
]]--

-- for lazy programmers
local S = function(pos) if pos then return minetest.pos_to_string(pos) end end
local P = minetest.string_to_pos
local M = minetest.get_meta

-- Load support for intllib.
local MP = minetest.get_modpath("techage")
local I,_ = dofile(MP.."/intllib.lua")

local TA2_Power = techage.Axle
local TA3_Power = techage.SteamPipe
local TA4_Power = techage.ElectricCable

local STANDBY_TICKS = 4
local COUNTDOWN_TICKS = 4
local CYCLE_TIME = 16
local POWER_CAPACITY = 50

local function formspec(self, pos, mem)
	return "size[8,7]"..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		"image[6,0.5;1,2;"..techage.power.formspec_power_bar(POWER_CAPACITY, mem.power_result).."]"..
		"image_button[5,1;1,1;".. self:get_state_button_image(mem) ..";state_button;]"..
		"button[2.5,1;1.8,1;update;"..I("Update").."]"..
		"list[current_player;main;0,3;8,4;]"..
		default.get_hotbar_bg(0, 3)
end

local function start_node(pos, mem, state)
	techage.power.power_distribution(pos)
end

local function stop_node(pos, mem, state)
	techage.power.power_distribution(pos)
end

local State2 = techage.NodeStates:new({
	node_name_passive = "techage:t2_source",
	cycle_time = CYCLE_TIME,
	standby_ticks = STANDBY_TICKS,
	formspec_func = formspec,
	start_node = start_node,
	stop_node = stop_node,
})

local State3 = techage.NodeStates:new({
	node_name_passive = "techage:t3_source",
	cycle_time = CYCLE_TIME,
	standby_ticks = STANDBY_TICKS,
	formspec_func = formspec,
	start_node = start_node,
	stop_node = stop_node,
})

local State4 = techage.NodeStates:new({
	node_name_passive = "techage:t4_source",
	cycle_time = CYCLE_TIME,
	standby_ticks = STANDBY_TICKS,
	formspec_func = formspec,
	start_node = start_node,
	stop_node = stop_node,
})

local tStates = {0, State2, State3, State4}

-- Pass1: Power balance calculation
local function on_power_pass1(pos, mem)
	local state = tStates[mem.state_num or 2]
	if state:is_active(mem) then
		return -POWER_CAPACITY
	end
	return 0
end	
		
-- Pass2: Power balance adjustment
local function on_power_pass2(pos, mem, sum)
	return 0
end

-- Pass3: Power balance result
local function on_power_pass3(pos, mem, sum)
	mem.power_result = sum
end

local function node_timer(pos, elapsed)
	local mem = tubelib2.get_mem(pos)
	local state = tStates[mem.state_num or 2]
	return state:is_active(mem)
end

local function on_receive_fields(pos, formname, fields, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return
	end
	local mem = tubelib2.get_mem(pos)
	local state = tStates[mem.state_num or 2]
	state:state_button_event(pos, mem, fields)
	
	if fields.update then
		M(pos):set_string("formspec", formspec(state, pos, mem))
	end
end

local function on_rightclick(pos)
	local mem = tubelib2.get_mem(pos)
	local state = tStates[mem.state_num or 2]
	M(pos):set_string("formspec", formspec(state, pos, mem))
end

minetest.register_node("techage:t2_source", {
	description = "Axle Power Source",
	tiles = {
		-- up, down, right, left, back, front
		"techage_filling_ta2.png^techage_frame_ta2_top.png",
		"techage_filling_ta2.png^techage_frame_ta2.png",
		"techage_filling_ta2.png^techage_axle_clutch.png^techage_frame_ta2.png",
		"techage_filling_ta2.png^techage_frame_ta2.png^techage_appl_source.png",
		"techage_filling_ta2.png^techage_frame_ta2.png^techage_appl_source.png",
		"techage_filling_ta2.png^techage_frame_ta2.png^techage_appl_source.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=2, crumbly=2, choppy=2},
	on_rotate = screwdriver.disallow,
	is_ground_content = false,

	on_construct = tubelib2.init_mem,
	after_place_node = function(pos, placer)
		local mem = tubelib2.get_mem(pos)
		State2:node_init(pos, mem, "")
		mem.state_num = 2
		on_rightclick(pos)
	end,
	
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		State2:after_dig_node(pos, oldnode, oldmetadata, digger)
	end,
	
	on_receive_fields = on_receive_fields,
	on_rightclick = on_rightclick,
	on_timer = node_timer,
})

minetest.register_node("techage:t3_source", {
	description = "Steam Power Source",
	tiles = {
		-- up, down, right, left, back, front
		"techage_filling_ta3.png^techage_frame_ta3_top.png",
		"techage_filling_ta3.png^techage_frame_ta3.png",
		"techage_filling_ta3.png^techage_steam_hole.png^techage_frame_ta3.png",
		"techage_filling_ta3.png^techage_frame_ta3.png^techage_appl_source.png",
		"techage_filling_ta3.png^techage_frame_ta3.png^techage_appl_source.png",
		"techage_filling_ta3.png^techage_frame_ta3.png^techage_appl_source.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=2, crumbly=2, choppy=2},
	on_rotate = screwdriver.disallow,
	is_ground_content = false,

	on_construct = tubelib2.init_mem,
	after_place_node = function(pos, placer)
		local mem = tubelib2.get_mem(pos)
		State3:node_init(pos, mem, "")
		mem.state_num = 3
		on_rightclick(pos)
	end,
	
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		State3:after_dig_node(pos, oldnode, oldmetadata, digger)
	end,
	
	on_receive_fields = on_receive_fields,
	on_rightclick = on_rightclick,
	on_timer = node_timer,
})

minetest.register_node("techage:t4_source", {
	description = "Ele Power Source",
	tiles = {
		-- up, down, right, left, back, front
		"techage_filling_ta4.png^techage_frame_ta4_top.png",
		"techage_filling_ta4.png^techage_frame_ta4.png",
		"techage_filling_ta4.png^techage_appl_hole_electric.png^techage_frame_ta4.png",
		"techage_filling_ta4.png^techage_frame_ta4.png^techage_appl_source.png",
		"techage_filling_ta4.png^techage_frame_ta4.png^techage_appl_source.png",
		"techage_filling_ta4.png^techage_frame_ta4.png^techage_appl_source.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=2, crumbly=2, choppy=2},
	on_rotate = screwdriver.disallow,
	is_ground_content = false,

	on_construct = tubelib2.init_mem,
	after_place_node = function(pos, placer)
		local mem = tubelib2.get_mem(pos)
		State4:node_init(pos, mem, "")
		mem.state_num = 4
		on_rightclick(pos)
	end,
	
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		State4:after_dig_node(pos, oldnode, oldmetadata, digger)
	end,
	
	on_receive_fields = on_receive_fields,
	on_rightclick = on_rightclick,
	on_timer = node_timer,
})

techage.power.register_node({"techage:t2_source"}, {
	on_power_pass1 = on_power_pass1,
	on_power_pass2 = on_power_pass2,
	on_power_pass3 = on_power_pass3,
	conn_sides = {"R"},
	power_network  = TA2_Power,
})

techage.power.register_node({"techage:t3_source"}, {
	on_power_pass1 = on_power_pass1,
	on_power_pass2 = on_power_pass2,
	on_power_pass3 = on_power_pass3,
	conn_sides = {"R"},
	power_network  = TA3_Power,
})

techage.power.register_node({"techage:t4_source"}, {
	on_power_pass1 = on_power_pass1,
	on_power_pass2 = on_power_pass2,
	on_power_pass3 = on_power_pass3,
	conn_sides = {"R"},
	power_network  = TA4_Power,
})