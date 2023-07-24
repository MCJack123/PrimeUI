local PrimeUI = require "util" -- DO NOT COPY THIS LINE
local expect = require "cc.expect".expect -- DO NOT COPY THIS LINE
-- Start copying below this line. --

--- Adds an action to trigger when a key is pressed with modifier keys.
---@param key key The key to trigger on, from `keys.*`
---@param withCtrl boolean Whether Ctrl is required
---@param withAlt boolean Whether Alt is required
---@param withShift boolean Whether Shift is required
---@param action function|string A function to call when clicked, or a string to use as a key for a `run` return event
function PrimeUI.keyCombo(key, withCtrl, withAlt, withShift, action)
    expect(1, key, "number")
    expect(2, withCtrl, "boolean")
    expect(3, withAlt, "boolean")
    expect(4, withShift, "boolean")
    expect(5, action, "function", "string")
    PrimeUI.addTask(function()
        local heldCtrl, heldAlt, heldShift = false, false, false
        while true do
            local event, param1, param2 = os.pullEvent() -- wait for key
            if event == "key" then
                -- check if key is down, all modifiers are correct, and that it's not held
                if param1 == key and heldCtrl == withCtrl and heldAlt == withAlt and heldShift == withShift and not param2 then
                    if type(action) == "string" then PrimeUI.resolve("keyCombo", action)
                    else action() end
                -- activate modifier keys
                elseif param1 == keys.leftCtrl or param1 == keys.rightCtrl then heldCtrl = true
                elseif param1 == keys.leftAlt or param1 == keys.rightAlt then heldAlt = true
                elseif param1 == keys.leftShift or param1 == keys.rightShift then heldShift = true end
            elseif event == "key_up" then
                -- deactivate modifier keys
                if param1 == keys.leftCtrl or param1 == keys.rightCtrl then heldCtrl = false
                elseif param1 == keys.leftAlt or param1 == keys.rightAlt then heldAlt = false
                elseif param1 == keys.leftShift or param1 == keys.rightShift then heldShift = false end
            end
        end
    end)
end
