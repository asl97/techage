--[[

	TechAge
	=======

	Copyright (C) 2019 Joachim Stolberg

	LGPLv2.1+
	See LICENSE.txt for more information
	
	Gravel Sieve basis functions
	
]]--

-- Increase the probability over the natural occurrence
local PROBABILITY_FACTOR = 2

-- Ore probability table  (1/n)
local ore_probability = {
}

local ProbabilityCorrections = {
	["default:coal_lump"] = 0.3,  -- extensively used
	["default:iron_lump"] = 0.4,  -- extensively used
	["techage:baborium_lump"] = 99999,  -- mining required
}

-- collect all registered ores and calculate the probability
local function add_ores()
	for _,item in  pairs(minetest.registered_ores) do
		if minetest.registered_nodes[item.ore] then
			local drop = minetest.registered_nodes[item.ore].drop
			if type(drop) == "string"
			and drop ~= item.ore
			and drop ~= ""
			and item.ore_type == "scatter"
			and item.wherein == "default:stone"
			and item.clust_scarcity ~= nil and item.clust_scarcity > 0 
			and item.clust_num_ores ~= nil and item.clust_num_ores > 0 
			and item.y_max ~= nil and item.y_min ~= nil then
				local probability = (techage.ore_rarity / PROBABILITY_FACTOR) * item.clust_scarcity /
						(item.clust_num_ores * ((item.y_max - item.y_min) / 65535))
				if ore_probability[drop] == nil then
					ore_probability[drop] = probability
				else
					-- harmonic sum
					ore_probability[drop] = 1.0 / ((1.0 / ore_probability[drop]) +
							(1.0 / probability))
				end
			end
		end
	end
	-- some corrections
	for key, correction in pairs(ProbabilityCorrections) do
		if ore_probability[key] then
			ore_probability[key] = ore_probability[key] * correction
		end
	end
	local overall_probability = 0.0
	for name,probability in pairs(ore_probability) do
		minetest.log("info", string.format("[techage] %-32s %u", name, probability))
		overall_probability = overall_probability + 1.0/probability
	end
	minetest.log("info", string.format("[techage] Overall probability %g", overall_probability))
end	

minetest.after(1, add_ores)


-- determine ore based on the calculated probability
function techage.gravelsieve_get_random_gravel_ore()
	for ore, probability in pairs(ore_probability) do
		if math.random(probability) == 1 then
			return ItemStack(ore)
		end
	end
	if math.random(2) == 1 then
		return ItemStack("default:gravel")
	else
		return ItemStack("techage:sieved_gravel")
	end
end

function techage.gravelsieve_get_random_basalt_ore()
	if math.random(40) == 1 then
		return ItemStack("default:coal_lump")
	elseif math.random(40) == 1 then
		return ItemStack("default:iron_lump")
	elseif math.random(2) == 1 then
		return ItemStack("techage:basalt_gravel")
	else
		return ItemStack("techage:sieved_basalt_gravel")
	end
end

