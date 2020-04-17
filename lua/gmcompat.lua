-- gmcompat.lua
--
-- Gamemode abstraction API for Garry's Mod

-- Don't overwrite old version of gmcompat
if gmcompat then return gmcompat end

gmcompat = {}

gmcompat.NAME_TTT		= "Trouble in Terrorist Town"
gmcompat.NAME_TTT2		= "TTT2 (Advanced Update)"
gmcompat.NAME_MURDER		= "Murder"

gmcompat.ROUNDSTATE_LIVE	= 1
gmcompat.ROUNDSTATE_NOTLIVE	= 0
gmcompat.ROUNDSTATE_UNKNOWN	= -1

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
		return gmcompat.ROUNDSTATE_UNKNOWN
	end

	if gmod.GetGamemode().Name == gmcompat.NAME_TTT or
	   gmod.GetGamemode().Name == gmcompat.NAME_TTT2 then
		-- Round state 3 => Game is running
		return ((GetRoundState() == 3) and gmcompat.ROUNDSTATE_LIVE or gmcompat.ROUNDSTATE_NOTLIVE)
	end

	if gmod.GetGamemode().Name == gmcompat.NAME_MURDER then
		-- Round state 1 => Game is running
		return ((gmod.GetGamemode():GetRound() == 1) and gmcompat.ROUNDSTATE_LIVE or gmcompat.ROUNDSTATE_NOTLIVE)
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

return gmcompat
