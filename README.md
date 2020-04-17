# gmod-gmcompat

This is a support library providing abstraction functions independent of
the currently used gamemode.

I will try my best to keep the API stable going forward.

## Usage

gmcompat isn't a normal module due to restrictions of the Garry's Mod LUA API.
Instead, it is a normal LUA file that should be included.

```
-- This will provide a global `gmcompat` table providing all the functions and constants.
include("gmcompat.lua")
```
