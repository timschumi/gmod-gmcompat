-- Hooking functions of gmcompat

-- Exit if we don't have gmcompat loaded
if not gmcompat then return end

local log = gmcompat._internal.log
local err = gmcompat._internal.err

local to_be_hooked = {}

hook.Add("Initialize", "gmcompat_add_hooks", function()
	for _, value in ipairs(to_be_hooked) do
		gmcompat.hook(value["target"], value["prefix"], value["func"])
	end
	to_be_hooked = {}
	hook.Remove("Initialize", "gmcompat_add_hooks")
end)

function gmcompat.roundStartHook()
	if gmod.GetGamemode() == nil then
		err("Gamemode isn't initialized yet!")
		return nil
	end

	if gmod.GetGamemode().Name == gmcompat.NAME_TTT or
	   gmod.GetGamemode().Name == gmcompat.NAME_TTT2 then
		return "TTTBeginRound"
	end

	if gmod.GetGamemode().Name == gmcompat.NAME_MURDER then
		return "OnStartRound"
	end

	-- Hook name could not be determined
	err("roundStartHook: Could not determine gamemode.")
	return nil
end

function gmcompat.roundEndHook()
	if gmod.GetGamemode() == nil then
		err("Gamemode isn't initialized yet!")
		return nil
	end

	if gmod.GetGamemode().Name == gmcompat.NAME_TTT or
	   gmod.GetGamemode().Name == gmcompat.NAME_TTT2 then
		return "TTTEndRound"
	end

	if gmod.GetGamemode().Name == gmcompat.NAME_MURDER then
		return "OnEndRound"
	end

	-- Hook name could not be determined
	err("roundEndHook: Could not determine gamemode.")
	return nil
end

-- `target` is the type of hook that should be added (either `start` or `end`)
-- `prefix` is the unique hook name prefix that should be used
-- `func` is the function that should be executed
function gmcompat.hook(target, prefix, func)
	local hookname

	-- If the Gamemode hasn't initialized yet, delay hooking until Initialization is done
	if gmod.GetGamemode() == nil then
		to_be_hooked[#to_be_hooked+1] = {["target"] = target, ["prefix"] = prefix, ["func"] = func}
		return
	end

	if target == "start" then
		hookname = gmcompat.roundStartHook()
	elseif target == "end" then
		hookname = gmcompat.roundEndHook()
	else
		err("hook: Unknown hook type used: '"..target.."'")
		return
	end

	if hookname == nil then
		log("hook: Could not find hook; the actual error has probably been logged above.")
		return
	end

	hook.Add(hookname, prefix..hookname, func)
end
