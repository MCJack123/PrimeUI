local PrimeUI = require "util" -- DO NOT COPY THIS LINE
local expect = require "cc.expect".expect -- DO NOT COPY THIS LINE
-- Start copying below this line. --

--- Creates a clickable button on screen with text.
---@param win window The window to draw on
---@param x number The X position of the button
---@param y number The Y position of the button
---@param text string The text to draw on the button
---@param action function|string A function to call when clicked, or a string to send with a `run` event
---@param fgColor color|nil The color of the button text (defaults to white)
---@param bgColor color|nil The color of the button (defaults to light gray)
---@param clickedColor color|nil The color of the button when clicked (defaults to gray)
---@param periphName string|nil The name of the monitor peripheral, or nil (set if you're using a monitor - events will be filtered to that monitor)
function PrimeUI.button(win, x, y, text, action, fgColor, bgColor, clickedColor, periphName)
    expect(1, win, "table")
    expect(1, win, "table")
    expect(2, x, "number")
    expect(3, y, "number")
    expect(4, text, "string")
    expect(5, action, "function", "string")
    fgColor = expect(6, fgColor, "number", "nil") or colors.white
    bgColor = expect(7, bgColor, "number", "nil") or colors.gray
    clickedColor = expect(8, clickedColor, "number", "nil") or colors.lightGray
    periphName = expect(9, periphName, "string", "nil")
    -- Draw the initial button.
    win.setCursorPos(x, y)
    win.setBackgroundColor(bgColor)
    win.setTextColor(fgColor)
    win.write(" " .. text .. " ")
    -- Get the screen position and add a click handler.
    local screenX, screenY = PrimeUI.getWindowPos(win, x, y)
    PrimeUI.addTask(function()
        local buttonDown = false
        while true do
            local event, button, clickX, clickY = os.pullEvent()
            if event == "mouse_click" and periphName == nil and button == 1 and clickX >= screenX and clickX < screenX + #text + 2 and clickY == screenY then
                -- Initiate a click action (but don't trigger until mouse up).
                buttonDown = true
                -- Redraw the button with the clicked background color.
                win.setCursorPos(x, y)
                win.setBackgroundColor(clickedColor)
                win.setTextColor(fgColor)
                win.write(" " .. text .. " ")
            elseif (event == "monitor_touch" and periphName == button and clickX >= screenX and clickX < screenX + #text + 2 and clickY == screenY)
                or (event == "mouse_up" and button == 1 and buttonDown) then
                -- Finish a click event.
                if clickX >= screenX and clickX < screenX + #text + 2 and clickY == screenY then
                    -- Trigger the action.
                    if type(action) == "string" then
                        PrimeUI.resolve("button", action)
                    else
                        action()
                    end
                end
                -- Redraw the original button state.
                win.setCursorPos(x, y)
                win.setBackgroundColor(bgColor)
                win.setTextColor(fgColor)
                win.write(" " .. text .. " ")
            end
        end
    end)
end
