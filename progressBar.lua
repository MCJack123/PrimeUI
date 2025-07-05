local PrimeUI = require "util" -- DO NOT COPY THIS LINE
local expect = require "cc.expect".expect -- DO NOT COPY THIS LINE
-- Start copying below this line. --

--- Creates a progress bar, which can be updated by calling the returned function.
---@param win window The window to draw on
---@param x number The X position of the left side of the bar
---@param y number The Y position of the bar
---@param width number The width of the bar
---@param fgColor color|nil The color of the activated part of the bar (defaults to white)
---@param bgColor color|nil The color of the inactive part of the bar (defaults to black)
---@param useShade boolean|nil Whether to use shaded areas for the inactive part (defaults to false)
---@return function redraw A function to call to update the progress of the bar, taking a number from 0.0 to 1.0
function PrimeUI.progressBar(win, x, y, width, fgColor, bgColor, useShade)
    expect(1, win, "table")
    expect(2, x, "number")
    expect(3, y, "number")
    expect(4, width, "number")
    fgColor = expect(5, fgColor, "number", "nil") or colors.white
    bgColor = expect(6, bgColor, "number", "nil") or colors.black
    expect(7, useShade, "boolean", "nil")
    local function redraw(progress)
        expect(1, progress, "number")
        if progress < 0 or progress > 1 then error("bad argument #1 (value out of range)", 2) end
        -- Draw the active part of the bar.
        win.setCursorPos(x, y)
        win.setBackgroundColor(fgColor)
        win.write((" "):rep(math.floor(progress * width)))
        -- Draw the inactive part of the bar, using shade if desired.
        win.setBackgroundColor(bgColor)
        win.setTextColor(fgColor)
        win.write((useShade and "\x7F" or " "):rep(width - math.floor(progress * width)))
    end
    redraw(0)
    return redraw
end
