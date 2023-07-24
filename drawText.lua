local PrimeUI = require "util" -- DO NOT COPY THIS LINE
local expect = require "cc.expect".expect -- DO NOT COPY THIS LINE
-- Start copying below this line. --

--- Draws a block of text inside a window with word wrapping, optionally resizing the window to fit.
---@param win window The window to draw in
---@param text string The text to draw
---@param resizeToFit boolean|nil Whether to resize the window to fit the text (defaults to false). This is useful for scroll boxes.
---@param fgColor color|nil The color of the text (defaults to white)
---@param bgColor color|nil The color of the background (defaults to black)
---@return number lines The total number of lines drawn
function PrimeUI.drawText(win, text, resizeToFit, fgColor, bgColor)
    expect(1, win, "table")
    expect(2, text, "string")
    expect(3, resizeToFit, "boolean", "nil")
    fgColor = expect(4, fgColor, "number", "nil") or colors.white
    bgColor = expect(5, bgColor, "number", "nil") or colors.black
    -- Set colors.
    win.setBackgroundColor(bgColor)
    win.setTextColor(fgColor)
    -- Redirect to the window to use print on it.
    local old = term.redirect(win)
    -- Draw the text using print().
    local lines = print(text)
    -- Redirect back to the original terminal.
    term.redirect(old)
    -- Resize the window if desired.
    if resizeToFit then
        -- Get original parameters.
        local x, y = win.getPosition()
        local w = win.getSize()
        -- Resize the window.
        win.reposition(x, y, w, lines)
    end
    return lines
end
