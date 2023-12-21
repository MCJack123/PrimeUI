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
function PrimeUI.button(win, x, y, text, action, fgColor, bgColor, clickedColor)
    expect(1, win, "table")
    expect(2, x, "number")
    expect(3, y, "number")
    expect(4, text, "string")
    expect(5, action, "function", "string")
    fgColor = expect(6, fgColor, "number", "nil") or colors.white
    bgColor = expect(7, bgColor, "number", "nil") or colors.gray
    clickedColor = expect(8, clickedColor, "number", "nil") or colors.lightGray    
    -- Create child frame for button
    local buttonFrame = window.create(win, x, y, #text + 2, 1, true)
    -- Draw the initial button.
    buttonFrame.setCursorPos(1, 1)
    buttonFrame.setBackgroundColor(bgColor)
    buttonFrame.setTextColor(fgColor)
    buttonFrame.write(" " .. text .. " ")
    -- Get the screen position and add a click handler.
    PrimeUI.addTask(function()
        local buttonDown = false
        while true do
            local event, button, clickX, clickY = os.pullEvent()
            if event == "mouse_click" and button == 1 and PrimeUI.inVisibleRegion(buttonFrame, clickX, clickY) then
                -- Initiate a click action (but don't trigger until mouse up).
                buttonDown = true
                -- Redraw the button with the clicked background color.
                buttonFrame.setCursorPos(1, 1)
                buttonFrame.setBackgroundColor(clickedColor)
                buttonFrame.setTextColor(fgColor)
                buttonFrame.write(" " .. text .. " ")
            elseif event == "mouse_up" and button == 1 and buttonDown then
                -- Finish a click event.
                if PrimeUI.inVisibleRegion(buttonFrame, clickX, clickY) then
                    -- Trigger the action.
                    if type(action) == "string" then PrimeUI.resolve("button", action)
                    else action() end
                end
                -- Redraw the original button state.
                buttonFrame.setCursorPos(1, 1)
                buttonFrame.setBackgroundColor(bgColor)
                buttonFrame.setTextColor(fgColor)
                buttonFrame.write(" " .. text .. " ")
            end
        end
    end)
end