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
---@param monitor monitor|nil The monitor to listen for events on (no default)
function PrimeUI.button(win, x, y, text, action, fgColor, bgColor, clickedColor, monitor)
    expect(1, win, "table")
    expect(2, x, "number")
    expect(3, y, "number")
    expect(4, text, "string")
    expect(5, action, "function", "string")
    fgColor = expect(6, fgColor, "number", "nil") or colors.white
    bgColor = expect(7, bgColor, "number", "nil") or colors.gray
    clickedColor = expect(8, clickedColor, "number", "nil") or colors.lightGray
    do
        local ok, m = pcall(peripheral.getName, monitor or win)
        monitor = ok and m or nil
    end
    -- Draw the initial button.
    win.setCursorPos(x, y)
    win.setBackgroundColor(bgColor)
    win.setTextColor(fgColor)
    win.write(" " .. text .. " ")
    -- Get the screen position and add a click handler.
    PrimeUI.addTask(function()
        local buttonDown = false
        local timer = nil
        while true do
            local event, button, clickX, clickY = os.pullEvent()
            local screenX, screenY = PrimeUI.getWindowPos(win, x, y)
            if (not monitor and event == "mouse_click" and button == 1 and clickX >= screenX and clickX < screenX + #text + 2 and clickY == screenY) or
                (event == "monitor_touch" and clickX >= screenX and clickX < screenX + #text + 2 and clickY == screenY)
            then
                -- Initiate a click action (but don't trigger until mouse up).
                buttonDown = true
                -- Redraw the button with the clicked background color.
                win.setCursorPos(x, y)
                win.setBackgroundColor(clickedColor)
                win.setTextColor(fgColor)
                win.write(" " .. text .. " ")

                if monitor then
                    timer = os.startTimer(.1)
                end
            elseif event == "mouse_up" and button == 1 and buttonDown then
                -- Finish a click event.
                if clickX >= screenX and clickX < screenX + #text + 2 and clickY == screenY then
                    -- Trigger the action.
                    if type(action) == "string" then PrimeUI.resolve("button", action)
                    else action() end
                end
                -- Redraw the original button state.
                win.setCursorPos(x, y)
                win.setBackgroundColor(bgColor)
                win.setTextColor(fgColor)
                win.write(" " .. text .. " ")
            elseif event == "timer" and timer == button and buttonDown then
                if type(action) == "string" then PrimeUI.resolve("button", action)
                else action() end

                win.setCursorPos(x, y)
                win.setBackgroundColor(bgColor)
                win.setTextColor(fgColor)
                win.write(" " .. text .. " ")
            end
        end
    end)
end
