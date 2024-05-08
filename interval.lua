local PrimeUI = require "util" -- DO NOT COPY THIS LINE
local expect = require "cc.expect".expect -- DO NOT COPY THIS LINE
-- Start copying below this line. --

--- Runs a function or action repeatedly after a specified time period until canceled.
--- If a function is passed as an action, it may return a number to change the
--- period, or `false` to stop it.
---@param time number The amount of time to wait for each time, in seconds
---@param action function The function to call when the timer completes
---@return function cancel A function to cancel the timer
---@return Task task The task for the timer
function PrimeUI.interval(time, action)
    expect(1, time, "number")
    expect(2, action, "function", "string")
    -- Start the timer.
    local timer = os.startTimer(time)
    -- Add a task to wait for the timer.
    local task = PrimeUI.addTask(function()
        while true do
            -- Wait for a timer event.
            local _, tm = os.pullEvent("timer")
            if tm == timer then
                -- Fire the timer action.
                local res = action()
                -- Check the return value and adjust time accordingly.
                if type(res) == "number" then time = res end
                -- Set a new timer if not canceled.
                if res ~= false then timer = os.startTimer(time) end
            end
        end
    end)
    -- Return a function to cancel the timer.
    return function() os.cancelTimer(timer) end, task
end