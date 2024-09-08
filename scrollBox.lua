local PrimeUI = require "util" -- DO NOT COPY THIS LINE
local expect = require "cc.expect".expect -- DO NOT COPY THIS LINE
-- Start copying below this line. --

--- Creates a scrollable window, which allows drawing large content in a small area.
---@param win window The parent window of the scroll box
---@param x number The X position of the box
---@param y number The Y position of the box
---@param width number The width of the box
---@param height number The height of the outer box
---@param innerHeight number The height of the inner scroll area
---@param allowArrowKeys boolean|nil Whether to allow arrow keys to scroll the box (defaults to true)
---@param showScrollIndicators boolean|nil Whether to show arrow indicators on the right side when scrolling is available, which reduces the inner width by 1 (defaults to false)
---@param fgColor number|nil The color of scroll indicators (defaults to white)
---@param bgColor color|nil The color of the background (defaults to black)
---@return window inner The inner window to draw inside
function PrimeUI.scrollBox(win, x, y, width, height, innerHeight, allowArrowKeys, showScrollIndicators, fgColor, bgColor)
    expect(1, win, "table")
    expect(2, x, "number")
    expect(3, y, "number")
    expect(4, width, "number")
    expect(5, height, "number")
    expect(6, innerHeight, "number")
    expect(7, allowArrowKeys, "boolean", "nil")
    expect(8, showScrollIndicators, "boolean", "nil")
    fgColor = expect(9, fgColor, "number", "nil") or colors.white
    bgColor = expect(10, bgColor, "number", "nil") or colors.black
    if allowArrowKeys == nil then allowArrowKeys = true end
    -- Create the outer container box.
    local outer = window.create(win == term and term.current() or win, x, y, width, height)
    outer.setBackgroundColor(bgColor)
    outer.clear()
    -- Create the inner scrolling box.
    local inner = window.create(outer, 1, 1, width - (showScrollIndicators and 1 or 0), innerHeight)
    inner.setBackgroundColor(bgColor)
    inner.clear()
    -- Draw scroll indicators if desired.
    if showScrollIndicators then
        outer.setBackgroundColor(bgColor)
        outer.setTextColor(fgColor)
        outer.setCursorPos(width, height)
        outer.write(innerHeight > height and "\31" or " ")
    end
    -- Add the scroll handler.
    PrimeUI.addTask(function()
        local scrollPos = 1
        while true do
            -- Wait for next event.
            local ev = table.pack(os.pullEvent())
            -- Update inner height in case it changed.
            innerHeight = select(2, inner.getSize())
            -- Check for scroll events and set direction.
            local dir
            if ev[1] == "key" and allowArrowKeys then
                if ev[2] == keys.up then dir = -1
                elseif ev[2] == keys.down then dir = 1 end
            elseif ev[1] == "mouse_scroll" then
                --- Get the relative position of the event in the window
                local winx, winy = PrimeUI.getPosInWindow(outer, ev[3], ev[4])
                if winx then
                    dir = ev[2]
                end
            end
            -- If there's a scroll event, move the window vertically.
            if dir and (scrollPos + dir >= 1 and scrollPos + dir <= innerHeight - height) then
                scrollPos = scrollPos + dir
                inner.reposition(1, 2 - scrollPos)
            end
            -- Redraw scroll indicators if desired.
            if showScrollIndicators then
                outer.setBackgroundColor(bgColor)
                outer.setTextColor(fgColor)
                outer.setCursorPos(width, 1)
                outer.write(scrollPos > 1 and "\30" or " ")
                outer.setCursorPos(width, height)
                outer.write(scrollPos < innerHeight - height and "\31" or " ")
            end
        end
    end)
    return inner
end
