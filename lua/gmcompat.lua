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
gmcompat.NAME_DARKRP		= "DarkRP"

function gmcompat._internal.log(msg)
	print("[gmcompat] "..msg)
end

function gmcompat._internal.err(msg)
	ErrorNoHalt("[gmcompat] [ERROR] "..msg.."\n")
end

include("gmcompat/hook.lua")
include("gmcompat/roundstate.lua")

return gmcompat
