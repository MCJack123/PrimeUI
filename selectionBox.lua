local PrimeUI = require "util" -- DO NOT COPY THIS LINE
local expect = require "cc.expect".expect -- DO NOT COPY THIS LINE
-- Start copying below this line. --

--- Creates a list of entries that can each be selected.
---@param win window The window to draw on
---@param x number The X coordinate of the inside of the box
---@param y number The Y coordinate of the inside of the box
---@param width number The width of the inner box
---@param height number The height of the inner box
---@param entries string[] A list of entries to show, where the value is whether the item is pre-selected (or `"R"` for required/forced selected)
---@param action function A function that's called when a selection is made
---@param selectChangeAction function|nil A function that's called when the current selection is changed
---@param fgColor color|nil The color of the text (defaults to white)
---@param bgColor color|nil The color of the background (defaults to black)
---@return Task task The task handling key events
function PrimeUI.selectionBox(win, x, y, width, height, entries, action, selectChangeAction, fgColor, bgColor)
    expect(1, win, "table")
    expect(2, x, "number")
    expect(3, y, "number")
    expect(4, width, "number")
    expect(5, height, "number")
    expect(6, entries, "table")
    expect(7, action, "function", "string")
    expect(8, selectChangeAction, "function", "string", "nil")
    fgColor = expect(9, fgColor, "number", "nil") or colors.white
    bgColor = expect(10, bgColor, "number", "nil") or colors.black
    -- Check that all entries are strings.
    if #entries == 0 then error("bad argument #6 (table must not be empty)", 2) end
    for i, v in ipairs(entries) do
        if type(v) ~= "string" then error("bad item " .. i .. " in entries table (expected string, got " .. type(v), 2) end
    end
    -- Create container window.
    local entrywin = window.create(win, x, y, width - 1, height)
    local selection, scroll = 1, 1
    -- Create a function to redraw the entries on screen.
    local function drawEntries()
        -- Clear and set invisible for performance.
        entrywin.setVisible(false)
        entrywin.setBackgroundColor(bgColor)
        entrywin.clear()
        -- Draw each entry in the scrolled region.
        for i = scroll, scroll + height - 1 do
            -- Get the entry; stop if there's no more.
            local e = entries[i]
            if not e then break end
            -- Set the colors: invert if selected.
            entrywin.setCursorPos(2, i - scroll + 1)
            if i == selection then
                entrywin.setBackgroundColor(fgColor)
                entrywin.setTextColor(bgColor)
            else
                entrywin.setBackgroundColor(bgColor)
                entrywin.setTextColor(fgColor)
            end
            -- Draw the selection.
            entrywin.clearLine()
            entrywin.write(#e > width - 1 and e:sub(1, width - 4) .. "..." or e)
        end
        -- Draw scroll arrows.
        entrywin.setCursorPos(width, 1)
        entrywin.write(scroll > 1 and "\30" or " ")
        entrywin.setCursorPos(width, height)
        entrywin.write(scroll < #entries - height + 1 and "\31" or " ")
        -- Send updates to the screen.
        entrywin.setVisible(true)
    end
    -- Draw first screen.
    drawEntries()
    -- Add a task for selection keys.
    return PrimeUI.addTask(function()
        while true do
            local _, key = os.pullEvent("key")
            if key == keys.down and selection < #entries then
                -- Move selection down.
                selection = selection + 1
                if selection > scroll + height - 1 then scroll = scroll + 1 end
                -- Send action if necessary.
                if selectChangeAction then selectChangeAction(selection) end
                -- Redraw screen.
                drawEntries()
            elseif key == keys.up and selection > 1 then
                -- Move selection up.
                selection = selection - 1
                if selection < scroll then scroll = scroll - 1 end
                -- Send action if necessary.
                if selectChangeAction then selectChangeAction(selection) end
                -- Redraw screen.
                drawEntries()
            elseif key == keys.enter then
                -- Select the entry: send the action.
                action(entries[selection])
            end
        end
    end)
end
