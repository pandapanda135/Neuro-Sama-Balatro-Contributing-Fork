local NeuroAction = ModCache.load("game-sdk/actions/neuro_action.lua")
local ExecutionResult = ModCache.load("game-sdk/websocket/execution_result.lua")
local GetRunText = ModCache.load("get_run_text.lua")

local JsonUtils = ModCache.load("game-sdk/utils/json_utils.lua")

local PickCards = setmetatable({}, { __index = NeuroAction })
PickCards.__index = PickCards

function PickCards:new(actionWindow, state)
    local obj = NeuroAction.new(self, actionWindow)
    return obj
end

function PickCards:_get_name()
    return "pick_cards"
end

function PickCards:_get_description()
    local description = "Pick cards to add to your deck."

    return description
end

local function get_cards_modifiers() -- this is for standard packs
    local cards = GetRunText:get_planet_details()

    for i = 1, #cards do
        local planet = cards[i] or ""

        cards[i] = planet
    end

    return cards
end

function PickCards:_get_schema()
    return JsonUtils.wrap_schema({
        hand = {
			type = "array",
            items = {
				type = "string",
				enum = get_cards_modifiers()
			},
		}
    })
end

function PickCards:_validate_action(data, state)
	return ExecutionResult.success()
end

-- id play card button: "play_button"
function PickCards:_execute_action(state)
	return true
end


return PickCards