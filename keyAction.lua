local PrimeUI = require "util" -- DO NOT COPY THIS LINE
local expect = require "cc.expect".expect -- DO NOT COPY THIS LINE
-- Start copying below this line. --

--- Adds an action to trigger when a key is pressed.
---@param key key The key to trigger on, from `keys.*`
---@param action function|string A function or `run` event to call when clicked
---@return Task task The task for the handler
function PrimeUI.keyAction(key, action)
    expect(1, key, "number")
    expect(2, action, "function", "string")
    return PrimeUI.addTask(function()
        while true do
            local _, param1 = os.pullEvent("key") -- wait for key
            if param1 == key then
                if type(action) == "string" then PrimeUI.resolve("keyAction", action)
                else action() end
            end
        end
    end)
end
