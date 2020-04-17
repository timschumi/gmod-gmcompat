-- gmcompat.lua
--
-- Gamemode abstraction API for Garry's Mod

-- Don't overwrite old version of gmcompat
if gmcompat then return gmcompat end

gmcompat = {}
gmcompat._internal = {}

gmcompat.NAME_SANDBOX		= "Sandbox"
gmcompat.NAME_TTT		= "Trouble in Terrorist Town"
gmcompat.NAME_TTT2		= "TTT2 (Advanced Update)"
gmcompat.NAME_MURDER		= "Murder"

gmcompat.ROUNDSTATE_LIVE	= 1
gmcompat.ROUNDSTATE_NOTLIVE	= 0
gmcompat.ROUNDSTATE_UNKNOWN	= -1

function gmcompat._internal.log(msg)
	print("[gmcompat] "..msg)
end

function gmcompat._internal.err(msg)
	ErrorNoHalt("[gmcompat] [ERROR] "..msg.."\n")
end

include("gmcompat/hook.lua")

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


return gmcompat
