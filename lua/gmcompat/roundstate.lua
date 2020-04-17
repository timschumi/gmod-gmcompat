-- Round state abstraction of gmcompat

-- Exit if we don't have gmcompat loaded
if not gmcompat then return end

local log = gmcompat._internal.log
local err = gmcompat._internal.err

gmcompat.ROUNDSTATE_LIVE	= 1
gmcompat.ROUNDSTATE_NOTLIVE	= 0
gmcompat.ROUNDSTATE_UNKNOWN	= -1

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
	return gmcompat.ROUNDSTATE_UNKNOWN
end
