-- gmcompat.lua
--
-- Gamemode abstraction API for Garry's Mod

-- Don't overwrite old version of gmcompat
if gmcompat then return gmcompat end

gmcompat = {}

local function log(msg)
	print("[gmcompat] "..msg)
end

local function err(msg)
	ErrorNoHalt("[gmcompat] [ERROR] "..msg.."\n")
end


local to_be_hooked = {}

hook.Add("Initialize", "gmcompat_add_hooks", function()
	for _, value in ipairs(to_be_hooked) do
		gmcompat.hook(value["target"], value["prefix"], value["func"])
	end
	to_be_hooked = {}
	hook.Remove("Initialize", "gmcompat_add_hooks")
end)


-- Returns 1 if the round is still on
-- Returns 0 otherwise (or -1 if unsupported)
function gmcompat.roundState()
	if gmod.GetGamemode() == nil then
		err("Gamemode isn't initialized yet!")
		return -1
	end

	if gmod.GetGamemode().Name == "Trouble in Terrorist Town" or
	   gmod.GetGamemode().Name == "TTT2 (Advanced Update)" then
		-- Round state 3 => Game is running
		return ((GetRoundState() == 3) and 1 or 0)
	end

	if gmod.GetGamemode().Name == "Murder" then
		-- Round state 1 => Game is running
		return ((gmod.GetGamemode():GetRound() == 1) and 1 or 0)
	end

	-- Round state could not be determined
	err("roundState: Could not determine gamemode.")
	return -1
end

function gmcompat.roundStartHook()
	if gmod.GetGamemode() == nil then
		err("Gamemode isn't initialized yet!")
		return nil
	end

	if gmod.GetGamemode().Name == "Trouble in Terrorist Town" or
	   gmod.GetGamemode().Name == "TTT2 (Advanced Update)" then
		return "TTTBeginRound"
	end

	if gmod.GetGamemode().Name == "Murder" then
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

	if gmod.GetGamemode().Name == "Trouble in Terrorist Town" or
	   gmod.GetGamemode().Name == "TTT2 (Advanced Update)" then
		return "TTTEndRound"
	end

	if gmod.GetGamemode().Name == "Murder" then
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

return gmcompat
