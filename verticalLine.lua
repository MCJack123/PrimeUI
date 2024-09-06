local PrimeUI = require "util" -- DO NOT COPY THIS LINE
local expect = require "cc.expect".expect -- DO NOT COPY THIS LINE
-- Start copying below this line. --

--- Draws a vertical line at a position with the specified height.
---@param win window The window to draw on
---@param x number The X position of the left side of the line
---@param y number The Y position of the line
---@param height number The width/length of the line
---@param side "right"|"left"|nil THe side of the line, either right or left (defaults to left)
---@param fgColor color|nil The color of the line (defaults to white)
---@param bgColor color|nil The color of the background (defaults to black)
function PrimeUI.verticalLine(win, x, y, height, side, fgColor, bgColor)
    expect(1, win, "table")
    expect(2, x, "number")
    expect(3, y, "number")
    expect(4, height, "number")
    side = expect(5, side, "string", "nil") or "left"
    fgColor = expect(6, fgColor, "number", "nil") or colors.white
    bgColor = expect(7, bgColor, "number", "nil") or colors.black
    -- Use drawing characters to draw a thin line.
    win.setTextColor(side=="left" and fgColor or bgColor)
    win.setBackgroundColor(side=="left" and bgColor or fgColor)
    for j=1, height do
      win.setCursorPos(x, y+j-1)
      win.write(("\x95"))
    end
end
