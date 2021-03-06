-- Hooking functions of gmcompat

-- Exit if we don't have gmcompat loaded
if not gmcompat then return end

local log = gmcompat._internal.log
local err = gmcompat._internal.err

local hooklist = {
	[gmcompat.NAME_SANDBOX] = {
	},
	[gmcompat.NAME_TTT] = {
		["start"] = "TTTBeginRound",
		["end"] = "TTTEndRound",
	},
	[gmcompat.NAME_TTT2] = {
		["start"] = "TTTBeginRound",
		["end"] = "TTTEndRound",
	},
	[gmcompat.NAME_MURDER] = {
		["start"] = "OnStartRound",
		["end"] = "OnEndRound",
	},
}

local to_be_hooked = {}

hook.Add("Initialize", "gmcompat_add_hooks", function()
	for _, value in ipairs(to_be_hooked) do
		gmcompat.hook(value["target"], value["prefix"], value["func"])
	end
	to_be_hooked = {}
	hook.Remove("Initialize", "gmcompat_add_hooks")
end)

-- `target` is the type of hook that should be added (either `start` or `end`)
-- `prefix` is the unique hook name prefix that should be used
-- `func` is the function that should be executed
function gmcompat.hook(target, prefix, func)
	local gm_name

	-- If the Gamemode hasn't initialized yet, delay hooking until Initialization is done
	if gmod.GetGamemode() == nil then
		to_be_hooked[#to_be_hooked+1] = {["target"] = target, ["prefix"] = prefix, ["func"] = func}
		return
	end

	gm_name = gmod.GetGamemode().Name

	if hooklist[gm_name] == nil then
		err("hook: Unknown gamemode '"..gm_name.."'")
		return
	end

	if hooklist[gm_name][target] == nil then
		err("hook: Unknown hook '"..target.."' for gamemode '"..gm_name.."'")
		return
	end

	hook.Add(hooklist[gm_name][target], prefix..hooklist[gm_name][target], func)
end
