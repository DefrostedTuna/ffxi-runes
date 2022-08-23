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

require 'logger'
local helpers = require 'DefrostedTuna/helpers'

local RuneManager = {
    ---
    -- The Movement library instance.
    --
    -- @param Movement
    ---
    _movement = {},

    ---
    -- The RuneValidator module instance.
    --
    -- @param RuneValidator
    ---
    _runeValidator = {},

    ---
    -- The activation state of the module.
    --
    -- @param boolean
    ---
    activated = false,

    ---
    -- The delay between ticks used for issuing commands.
    --
    -- @param float
    ---
    tickDelay = 1.2,

    ---
    -- The time that the next tick should fire and issue a command.
    --
    -- @param float
    ---
    nextTick = os.clock(),

    ---
    -- The runes that are currently being maintained.
    --
    -- @param table<number, string>
    ---
    activeRunes = {},

    ---
    -- The commands mapped to their associated handler.
    --
    -- @param table<string, string>
    ---
    commands = {
        add = 'commandAddRune',
        set = 'commandSetRunes',
        show = 'commandShowRunes',
        clear = 'commandClearRunes',
        toggle = 'commandToggle',
    },
}
RuneManager.__index = RuneManager

---
-- Create a new RuneManager instance.
--
-- @return table<string, mixed>
---
function RuneManager:new(Movement, RuneValidator)
    local instance = {
        _movement = Movement,
        _runeValidator = RuneValidator,
    }

    setmetatable(instance, self)

    self:setNextTick(os.clock() + self:getTickDelay())

    return instance
end

---
-- The Movement library instance.
--
-- @return Movement
---
function RuneManager:getMovement()
    return self._movement
end

---
-- The RuneValidator module instance.
--
-- @return RuneValidator
---
function RuneManager:getRuneValidator()
    return self._runeValidator
end

---
-- The activation state of the module.
--
-- @return boolean
---
function RuneManager:getActivated()
    return self.activated
end

---
-- Set the activation state of the module.
--
-- @param  boolean  state  The new activation state.
--
-- @return void
---
function RuneManager:setActivated(state)
    self.activated = state
end

---
-- The delay between ticks used for issuing commands.
--
-- @return float
---
function RuneManager:getTickDelay()
    return self.tickDelay
end

---
-- Set the delay between ticks used for issuing commands.
--
-- @param  float  delay  The new tick delay for the module.
--
-- @return void
---
function RuneManager:setTickDelay(delay)
    self.tickDelay = delay
end

---
-- The time that the next tick should fire and issue a command.
--
-- @return float
---
function RuneManager:getNextTick()
    return self.nextTick
end

---
-- Set the time that the next tick should fire and issue a command.
--
-- @param  float  tick  The time that the next tick should fire.
--
-- @return void
---
function RuneManager:setNextTick(tick)
    self.nextTick = tick
end

---
-- The runes that are currently being maintained.
--
-- @return table<number, string)
---
function RuneManager:getActiveRunes()
    return self.activeRunes
end

---
-- Set the runes that are currently being maintained.
--
-- Note: The number of runes set is limited to the maximum number of slots available.
--
-- @param  table<number, string>  runes  The runes to be added to the list of active runes.
--
-- @return void
---
function RuneManager:setActiveRunes(runes)
    local activeRunes = {}
    local desiredRunes = {
        unpack(runes, 1, self:getMaxRuneSlots())
    }

    -- Only apply the runes that are valid.
    for _, rune in ipairs(desiredRunes) do
        if (self:getRuneValidator():validateRune(rune)) then
            table.insert(activeRunes, rune)
        end
    end

    self.activeRunes = activeRunes
end

---
-- Clear the runes that are currently being maintained.
--
-- @return void
---
function RuneManager:clearActiveRunes()
    self:setActiveRunes({})
end

---
-- The commands mapped to their associated handler.
--
-- @return table<string, string>
---
function RuneManager:getCommands()
    return self.commands
end

---
-- The maximum number of rune slots available to the player.
--
-- @return number
---
function RuneManager:getMaxRuneSlots()
    local player = windower.ffxi.get_player()
    local maxRunes = 0

    -- If the player has Rune Fencer set as either main or sub job, find the level of the job.
    if (player) and (player.main_job == 'RUN' or player.sub_job == 'RUN') then
        local jobLevel = player.main_job == 'RUN' and player.main_job_level or player.sub_job_level

        if (jobLevel) >= 65 then
            maxRunes = 3
        elseif (jobLevel) >= 35 then
            maxRunes = 2
        elseif (jobLevel) >= 5 then
            maxRunes = 1
        end
    end

    return maxRunes
end

---
-- Toggle the activation state of the module.
--
-- Usage: runes toggle {?status}
--
-- @param  table<number, string>  args  The arguments passed to the command by the user.
--
-- @return void
---
function RuneManager:commandToggle(args)
    if (args[1]) then
        local input = args[1]:lower()
        local state = (input == 'on' or input == 'true') or false

        self:setActivated(state)
    else
        self:setActivated(not self:getActivated())
    end

    local status = self:getActivated() and 'Activated' or 'Deactivated'

    log(status)
end

---
-- Add a rune to the runes that are currently being maintained.
--
-- Usage: runes add {name}
--
-- @param  table<number, string>  args  The arguments passed to the command by the user.
--
-- @return void
---
function RuneManager:commandAddRune(args)
    local rune = args[1]

    if not (self:getRuneValidator():validateRune(rune)) then
        log(rune .. ' is not a valid rune.')

        return
    end

    local activeRunes = self:getActiveRunes()

    table.insert(activeRunes, rune)

    -- Remove the oldest entry before applying the runes if at max allocation.
    if (#activeRunes > self:getMaxRuneSlots()) then
        table.remove(activeRunes, 1)
    end

    self:setActiveRunes(activeRunes)
    self:logActiveRunes()
end

---
-- Add a subset of runes to the runes that are currently being maintained.
--
-- Usage: runes set {?name} {?name} {?name}
--
-- @param  table<number, string>  args  The arguments passed to the command by the user.
--
-- @return void
---
function RuneManager:commandSetRunes(args)
    -- Validation is being taken care of via the setter.
    -- If runes are invalid, or if they exced the maximum number allowed,
    -- they will be truncated to reflect valid entries only.
    self:setActiveRunes(args)
    self:logActiveRunes()
end

---
-- Show the runes that are currently being maintained.
--
-- Usage: runes show
--
-- @return void
---
function RuneManager:commandShowRunes()
    self:logActiveRunes()
end

---
-- Clear the active set of runes.
--
-- Usage: runes clear
--
-- @return void
---
function RuneManager:commandClearRunes()
    self:clearActiveRunes()

    log('Rune configuration has been cleared.')
end

---
-- Print the runes that are currently being maintained into FFXI's chat log.
--
-- @return void
---
function RuneManager:logActiveRunes()
    local activeRunes = {}

    -- Capitalize the first letter of each rune.
    for key, rune in ipairs(self:getActiveRunes()) do
        activeRunes[key] = helpers.ucfirst(rune)
    end

    local runeString = (#activeRunes == 0)
        and 'No runes are being maintained.'
        or 'Currently maintaining ' .. table.concat(activeRunes, ', ') .. '.'

    log(runeString)
end

---
-- Apply the runes that have been defined by the user.
--
-- TODO: Move this functionality into its own library.
--
-- @return void
---
function RuneManager:actionApplyRunes()
    local activeRunes = self:getActiveRunes()
    local desiredRunes = {}
    local player = windower.ffxi.get_player()
    local recasts = windower.ffxi.get_ability_recasts()
    local activeBuffs = player and player.buffs or {}
    local activeBuffCount = {}

    -- Count the number of active buffs that the player has of each type.
    for _, buff in pairs(activeBuffs) do
        if not (activeBuffCount[buff]) then
            activeBuffCount[buff] = 1
        else
            activeBuffCount[buff] = activeBuffCount[buff] + 1
        end
    end

    -- Map the number of runes being used to account for duplicates.
    for _, rune in pairs(activeRunes) do
        if not (desiredRunes[rune]) then
            desiredRunes[rune] = 1
        else
            desiredRunes[rune] = desiredRunes[rune] + 1
        end
    end

    -- Apply each rune if necessary.
    for rune, desirectCount in pairs(desiredRunes) do
        local runeId = self:getRuneValidator():getRuneId(rune)
        local active = helpers.in_table(activeBuffs, runeId)
        local activeCount = active and activeBuffCount[runeId] or 0

        if not (active) or (activeCount < desirectCount) then
            -- Don't attempt to use the ability if it is on cooldown. Wait until the next tick.
            -- For reference here; the ability id for rune enhancement is 92.
            if (recasts[92]) and (recasts[92] > 0) then
                return
            end

            windower.send_command('input /ja "' .. rune .. '" <me>')
        end
    end
end

---
-- Delegate how the given command should be handled
--
-- @param  string                 declaration  The declaration that was given by the user.
-- @param  table<number, string>  args         The arguments passed to the command by the user.
--
-- @return void
---
function RuneManager:handleCommands(declaration, args)
    if (self[self:getCommands()[declaration]]) then
        self[self:getCommands()[declaration]](self, args)
    end

    -- TODO: Log unhandled command and send help text to the user.
end

---
-- Handle the automation required to keep the specified runes active on the player character.
--
-- @return void
---
function RuneManager:handlePrerender()
    -- When the module is active, delay the execution based on the specified interval.
    if not (self:getActivated()) or not (os.clock() > self:getNextTick()) then
        return
    end

    local player = windower.ffxi.get_player()

    -- Delay execution if the player is busy.
    if not (player)
        or (helpers.player_is_busy())
        or (helpers.player_is_sneaking())
        or (self:getMovement():getMoving())
    then
        self:setNextTick(os.clock() + self:getTickDelay())

        return
    end

    self:actionApplyRunes()
    self:setNextTick(os.clock() + self:getTickDelay())
end

---
-- Handle events when changing zones.
--
-- @return void
---
function RuneManager:handleZoneChange()
    self:setActivated(false)
end

---
-- Handle events when changing jobs.
--
-- @return void
---
function RuneManager:handleJobChange()
    self:clearActiveRunes()
    self:setActivated(false)
end

return RuneManager