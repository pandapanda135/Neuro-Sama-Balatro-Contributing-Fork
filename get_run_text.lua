
--- @class GetRunText
local getRunText = {}

local function get_planet_args(name, effect_config)
    sendDebugMessage("effect_config" .. tprint(effect_config,1))
    local loc_args = {}
    if name == "Ceres" then loc_args = {effect_config.config}
    elseif name == "Earth" then loc_args = {effect_config.config}
    elseif name == "Eris" then loc_args = {effect_config.config}
    elseif name == "Jupiter" then loc_args = {effect_config.config}
	elseif name == "Mars" then loc_args = {effect_config.config}
	elseif name == "Mercury" then loc_args = {effect_config.config}
	elseif name == "Neptune" then loc_args = {effect_config.config}
	elseif name == "Planet X" then loc_args = {effect_config.config}
	elseif name == "Pluto" then loc_args = {effect_config.config}
	elseif name == "Saturn" then loc_args = {effect_config.config}
	elseif name == "Uranus" then loc_args = {effect_config.config}
	elseif name == "Venus" then loc_args = {effect_config.config}
	end

    return loc_args
end

-- G.shop_booster might be related to how boosters in the bottom right of the shop ui are loaded

function getRunText:get_planet_details()
    local cards = {}

    sendDebugMessage(tprint(G.pack_cards.cards,1,5))

	sendDebugMessage("start get_planet_details") -- G.consumeables.highlighted
	for pos, card in ipairs(G.pack_cards.cards) do -- this might need to be changed from G.hand.cards
		sendDebugMessage("start for loop")
		local planet_desc = ""

		sendDebugMessage("Pos: " .. pos .. " Card: " .. card.ability.name)


        if card.ability.set == "Planet" then
            local key_override = nil
            for _, v in pairs(G.P_CENTER_POOLS.Planet) do -- card.ability.effect card.ability.name
                -- local loc_args,loc_nodes = get_planet_args(card.ability.name,G.P_CENTERS[v.key]), {}
                -- G.C.SET.Planet
                local loc_args,loc_nodes = get_planet_args(card.ability.name,v.config), {}

                if v.key ~= card.config.center_key then goto continue end
                if v.loc_txt and type(v.loc_vars) == 'function' then
                    local res = v:loc_vars() or {}
                    loc_args = res.vars or {}
                    key_override = v.key
				else
                    key_override = card.config.center_key
                    -- loc_args[#loc_args + 1] = card.dissolve_colours
                end

                -- Idk what this does but it works with vanilla so it's good enough for me
                loc_args = {
                    G.GAME.hands[v.config.hand_type].level,localize(v.config.hand_type, 'poker_hands'), G.GAME.hands[v.config.hand_type].l_mult, G.GAME.hands[v.config.hand_type].l_chips,
                    colours = {(G.GAME.hands[v.config.hand_type].level==1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[v.config.hand_type].level)])}
                }

                localize{type = 'descriptions', key = v.key, set = v.set, nodes = loc_nodes, vars = loc_args}

                local description = "Planet: "
                for _, line in ipairs(loc_nodes) do
                    for _, word in ipairs(line) do
                        if word.nodes ~= nil then
                            description = description .. word.nodes[1].config.text
                        else
                            description = description .. word.config.text
                        end
                        description = description .. " "
                    end
                end

                planet_desc = description
            ::continue::
            end
        end
		cards[#cards+1] = planet_desc
    end
    return cards
end

return getRunText