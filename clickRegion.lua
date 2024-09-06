local PrimeUI = require "util" -- DO NOT COPY THIS LINE
local expect = require "cc.expect".expect -- DO NOT COPY THIS LINE
-- Start copying below this line. --

--- Creates a clickable region on screen without any content.
---@param win window The window to draw on
---@param x number The X position of the button
---@param y number The Y position of the button
---@param width number The width of the inner box
---@param height number The height of the inner box
---@param action function|string A function to call when clicked, or a string to send with a `run` event
---@param periphName string|nil The name of the monitor peripheral, or nil (set if you're using a monitor - events will be filtered to that monitor)
function PrimeUI.clickRegion(win, x, y, width, height, action, periphName)
    expect(1, win, "table")
    expect(2, x, "number")
    expect(3, y, "number")
    expect(4, width, "number")
    expect(5, height, "number")
    expect(6, action, "function", "string")
    expect(7, periphName, "string", "nil")
    PrimeUI.addTask(function()
        -- Get the screen position and add a click handler.
        local screenX, screenY = PrimeUI.getWindowPos(win, x, y)
        local buttonDown = false
        while true do
            local event, button, clickX, clickY = os.pullEvent()
            if (event == "monitor_touch" and periphName == button)
                or (event == "mouse_click" and button == 1 and periphName == nil) then
                -- Finish a click event.
                if clickX >= screenX and clickX < screenX + width
                    and clickY >= screenY and clickY < screenY + height then
                    -- Trigger the action.
                    if type(action) == "string" then
                        PrimeUI.resolve("clickRegion", action)
                    else
                        action()
                    end
                end
            end
        end
    end)
end
