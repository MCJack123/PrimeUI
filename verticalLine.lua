local PrimeUI = require "util" -- DO NOT COPY THIS LINE
local expect = require "cc.expect".expect -- DO NOT COPY THIS LINE
-- Start copying below this line. --

--- Draws a vertical line at a position with the specified height.
---@param win window The window to draw on
---@param x number The X position of the line
---@param y number The Y position of the top of the line
---@param height number The height of the line
---@param right boolean|nil Wether to align the line to the right instead of the left (defaults to false)
---@param fgColor color|nil The color of the line (defaults to white)
---@param bgColor color|nil The color of the background (defaults to black)
function PrimeUI.verticalLine(win, x, y, height, right, fgColor, bgColor)
    expect(1, win, "table")
    expect(2, x, "number")
    expect(3, y, "number")
    expect(4, height, "number")
    right = expect(5, right, "boolean", "nil") or false
    fgColor = expect(6, fgColor, "number", "nil") or colors.white
    bgColor = expect(7, bgColor, "number", "nil") or colors.black
    -- Use drawing characters to draw a thin line.
    win.setTextColor(right and bgColor fgColor)
    win.setBackgroundColor(right and fgColor or bgColor)
    for j=1, height do
        win.setCursorPos(x, y+j-1)
        win.write("\x95")
    end
end
