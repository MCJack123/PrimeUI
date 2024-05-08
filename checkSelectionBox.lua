local PrimeUI = require "util" -- DO NOT COPY THIS LINE
local expect = require "cc.expect".expect -- DO NOT COPY THIS LINE
-- Start copying below this line. --

--- Creates a list of entries with toggleable check boxes.
---@param win window The window to draw on
---@param x number The X coordinate of the inside of the box
---@param y number The Y coordinate of the inside of the box
---@param width number The width of the inner box
---@param height number The height of the inner box
---@param selections table<string,string|boolean> A list of entries to show, where the value is whether the item is pre-selected (or `"R"` for required/forced selected)
---@param action function|nil A function that's called when a selection is made
---@param fgColor color|nil The color of the text (defaults to white)
---@param bgColor color|nil The color of the background (defaults to black)
---@return Task task The task for the key/scroll handler
function PrimeUI.checkSelectionBox(win, x, y, width, height, selections, action, fgColor, bgColor)
    expect(1, win, "table")
    expect(2, x, "number")
    expect(3, y, "number")
    expect(4, width, "number")
    expect(5, height, "number")
    expect(6, selections, "table")
    expect(7, action, "function", "string", "nil")
    fgColor = expect(8, fgColor, "number", "nil") or colors.white
    bgColor = expect(9, bgColor, "number", "nil") or colors.black
    -- Calculate how many selections there are.
    local nsel = 0
    for _ in pairs(selections) do nsel = nsel + 1 end
    -- Create the outer display box.
    local outer = window.create(win, x, y, width, height)
    outer.setBackgroundColor(bgColor)
    outer.clear()
    -- Create the inner scroll box.
    local inner = window.create(outer, 1, 1, width - 1, nsel)
    inner.setBackgroundColor(bgColor)
    inner.setTextColor(fgColor)
    inner.clear()
    -- Draw each line in the window.
    local lines = {}
    local nl, selected = 1, 1
    for k, v in pairs(selections) do
        inner.setCursorPos(1, nl)
        inner.write((v and (v == "R" and "[-] " or "[\xD7] ") or "[ ] ") .. k)
        lines[nl] = {k, not not v}
        nl = nl + 1
    end
    -- Draw a scroll arrow if there is scrolling.
    if nsel > height then
        outer.setCursorPos(width, height)
        outer.setBackgroundColor(bgColor)
        outer.setTextColor(fgColor)
        outer.write("\31")
    end
    -- Set cursor blink status.
    inner.setCursorPos(2, selected)
    inner.setCursorBlink(true)
    PrimeUI.setCursorWindow(inner)
    -- Get screen coordinates & add run task.
    local screenX, screenY = PrimeUI.getWindowPos(win, x, y)
    return PrimeUI.addTask(function()
        local scrollPos = 1
        while true do
            -- Wait for an event.
            local ev = table.pack(os.pullEvent())
            -- Look for a scroll event or a selection event.
            local dir
            if ev[1] == "key" then
                if ev[2] == keys.up then dir = -1
                elseif ev[2] == keys.down then dir = 1
                elseif ev[2] == keys.space and selections[lines[selected][1]] ~= "R" then
                    -- (Un)select the item.
                    lines[selected][2] = not lines[selected][2]
                    inner.setCursorPos(2, selected)
                    inner.write(lines[selected][2] and "\xD7" or " ")
                    -- Call the action if passed; otherwise, set the original table.
                    if action then action(lines[selected][1], lines[selected][2])
                    else selections[lines[selected][1]] = lines[selected][2] end
                    -- Redraw all lines in case of changes.
                    for i, v in ipairs(lines) do
                        local vv = selections[v[1]] == "R" and "R" or v[2]
                        inner.setCursorPos(2, i)
                        inner.write((vv and (vv == "R" and "-" or "\xD7") or " "))
                    end
                    inner.setCursorPos(2, selected)
                end
            elseif ev[1] == "mouse_scroll" and ev[3] >= screenX and ev[3] < screenX + width and ev[4] >= screenY and ev[4] < screenY + height then
                dir = ev[2]
            end
            -- Scroll the screen if required.
            if dir and (selected + dir >= 1 and selected + dir <= nsel) then
                selected = selected + dir
                if selected - scrollPos < 0 or selected - scrollPos >= height then
                    scrollPos = scrollPos + dir
                    inner.reposition(1, 2 - scrollPos)
                end
                inner.setCursorPos(2, selected)
            end
            -- Redraw scroll arrows and reset cursor.
            outer.setCursorPos(width, 1)
            outer.write(scrollPos > 1 and "\30" or " ")
            outer.setCursorPos(width, height)
            outer.write(scrollPos < nsel - height + 1 and "\31" or " ")
            inner.restoreCursor()
        end
    end)
end