--[[
Copyright © 2022, DefrostedTuna
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Runes nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL DEFROSTEDTUNA BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

_addon.name = 'Runes'
_addon.author = 'DefrostedTuna'
_addon.version = '1.0.1'
_addon.commands = {'runes'}

local MovementLibrary = require 'DefrostedTuna/Movement'
local RuneValidator = require 'RuneValidator'
local RuneManagerModule = require 'RuneManager'
local RuneManager = RuneManagerModule:new(
    MovementLibrary:new(),
    RuneValidator:new()
)

---
-- Set up the listener for delegating incoming commands.
--
-- @param  string                 declaration  The type of command being issued.
-- @param  table<number, string>  ...          The incoming command string.
--
-- @return void
---
windower.register_event("addon command", function (declaration, ...)
    local args = {...}

    RuneManager:handleCommands(declaration, args)
end)

---
-- Manage the actions autonomously before each render.
--
-- @return void
---
windower.register_event("prerender", function ()
    RuneManager:handlePrerender()
end)

---
-- Handle events when changing zones.
--
-- @return void
---
windower.register_event("zone change", function ()
    RuneManager:handleZoneChange()
end)

---
-- Handle events when changing jobs.
--
-- @return void
---
windower.register_event("job change", function ()
    RuneManager:handleJobChange()
end)