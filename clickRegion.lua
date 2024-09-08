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
        while true do
            local event, button, clickX, clickY = os.pullEvent()
            if (event == "monitor_touch" and periphName == button)
                or (event == "mouse_click" and button == 1 and periphName == nil) then
                -- Get the position of the click in the window and finish the click event
                local winx, winy = PrimeUI.getPosInWindow(win, clickX, clickY)
                if winx and x <= winx and y <= winy and winx <= x + width - 1
                    and winy <= y + height - 1 then
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
