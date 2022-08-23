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

local RuneValidator = {
    ---
    -- The available runes and their associated buff ids.
    --
    -- @param table<string, number>
    ---
    validRunes = {
        ignis = 523,
        gelus = 524,
        flabra = 525,
        tellus = 526,
        sulpor = 527,
        unda = 528,
        lux = 529,
        tenebrae = 530,
    }
}
RuneValidator.__index = RuneValidator

---
-- Create a new RuneValidator instance.
--
-- @return table<string, mixed>
---
function RuneValidator:new()
    return setmetatable({}, self)
end

---
-- The available runes withand their associated buff ids.
--
-- @return table<string, number>
---
function RuneValidator:getValidRunes()
    return self.validRunes
end

---
-- The id associated with a specific rune.
--
-- @param  string  rune  The name of the desired rune.
--
-- @return number
---
function RuneValidator:getRuneId(rune)
    local sanitized = rune:lower()

    return self:validateRune(sanitized) and self.validRunes[sanitized] or 0
end

---
-- Validate a given rune.
--
-- @param  string  rune  The rune to be validated.
--
-- @return boolean
---
function RuneValidator:validateRune(rune)
    local sanitized = rune:lower()

    for name, _ in pairs(self:getValidRunes()) do
        if (name == sanitized) then
            return true
        end
    end

    return false
end

return RuneValidator