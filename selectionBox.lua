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
---@param action function|string A function or `run` event that's called when a selection is made
---@param selectChangeAction function|string|nil A function or `run` event that's called when the current selection is changed
---@param fgColor color|nil The color of the text (defaults to white)
---@param bgColor color|nil The color of the background (defaults to black)
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
    local entrywin = window.create(win, x, y, width, height)
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
        entrywin.setBackgroundColor(bgColor)
        entrywin.setTextColor(fgColor)
        entrywin.setCursorPos(width, 1)
        entrywin.write("\30")
        entrywin.setCursorPos(width, height)
        entrywin.write("\31")
        -- Send updates to the screen.
        entrywin.setVisible(true)
    end
    -- Draw first screen.
    drawEntries()
    -- Add a task for selection keys.
    PrimeUI.addTask(function()
        while true do
            local event, key, cx, cy = os.pullEvent()
            if event == "key" then
                if key == keys.down and selection < #entries then
                    -- Move selection down.
                    selection = selection + 1
                    if selection > scroll + height - 1 then scroll = scroll + 1 end
                    -- Send action if necessary.
                    if type(selectChangeAction) == "string" then PrimeUI.resolve("selectionBox", selectChangeAction, selection)
                    elseif selectChangeAction then selectChangeAction(selection) end
                    -- Redraw screen.
                    drawEntries()
                elseif key == keys.up and selection > 1 then
                    -- Move selection up.
                    selection = selection - 1
                    if selection < scroll then scroll = scroll - 1 end
                    -- Send action if necessary.
                    if type(selectChangeAction) == "string" then PrimeUI.resolve("selectionBox", selectChangeAction, selection)
                    elseif selectChangeAction then selectChangeAction(selection) end
                    -- Redraw screen.
                    drawEntries()
                elseif key == keys.enter then
                    -- Select the entry: send the action.
                    if type(action) == "string" then PrimeUI.resolve("selectionBox", action, entries[selection])
                    else action(entries[selection]) end
                end
            elseif event == "mouse_click" and key == 1 then
                -- Handle clicking the scroll arrows.
                local wx, wy = PrimeUI.getWindowPos(entrywin, 1, 1)
                if cx == wx + width - 1 then
                    if cy == wy and selection > 1 then
                        -- Move selection up.
                        selection = selection - 1
                        if selection < scroll then scroll = scroll - 1 end
                        -- Send action if necessary.
                        if type(selectChangeAction) == "string" then PrimeUI.resolve("selectionBox", selectChangeAction, selection)
                        elseif selectChangeAction then selectChangeAction(selection) end
                        -- Redraw screen.
                        drawEntries()
                    elseif cy == wy + height - 1 and selection < #entries then
                        -- Move selection down.
                        selection = selection + 1
                        if selection > scroll + height - 1 then scroll = scroll + 1 end
                        -- Send action if necessary.
                        if type(selectChangeAction) == "string" then PrimeUI.resolve("selectionBox", selectChangeAction, selection)
                        elseif selectChangeAction then selectChangeAction(selection) end
                        -- Redraw screen.
                        drawEntries()
                    end
                elseif cx >= wx and cx < wx + width - 1 and cy >= wy and cy < wy + height then
                    local sel = scroll + (cy - wy)
                    if sel == selection then
                        -- Select the entry: send the action.
                        if type(action) == "string" then PrimeUI.resolve("selectionBox", action, entries[selection])
                        else action(entries[selection]) end
                    else
                        selection = sel
                        -- Send action if necessary.
                        if type(selectChangeAction) == "string" then PrimeUI.resolve("selectionBox", selectChangeAction, selection)
                        elseif selectChangeAction then selectChangeAction(selection) end
                        -- Redraw screen.
                        drawEntries()
                    end
                end
            elseif event == "mouse_scroll" then
                -- Handle mouse scrolling.
                local wx, wy = PrimeUI.getWindowPos(entrywin, 1, 1)
                if cx >= wx and cx < wx + width and cy >= wy and cy < wy + height then
                    if key < 0 and selection > 1 then
                        -- Move selection up.
                        selection = selection - 1
                        if selection < scroll then scroll = scroll - 1 end
                        -- Send action if necessary.
                        if type(selectChangeAction) == "string" then PrimeUI.resolve("selectionBox", selectChangeAction, selection)
                        elseif selectChangeAction then selectChangeAction(selection) end
                        -- Redraw screen.
                        drawEntries()
                    elseif key > 0 and selection < #entries then
                        -- Move selection down.
                        selection = selection + 1
                        if selection > scroll + height - 1 then scroll = scroll + 1 end
                        -- Send action if necessary.
                        if type(selectChangeAction) == "string" then PrimeUI.resolve("selectionBox", selectChangeAction, selection)
                        elseif selectChangeAction then selectChangeAction(selection) end
                        -- Redraw screen.
                        drawEntries()
                    end
                end
            end
        end
    end)
end
