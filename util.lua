-- PrimeUI by JackMacWindows
-- Public domain/CC0

local expect = require "cc.expect".expect

-- Initialization code
local PrimeUI = {}
do
    local coros = {}
    local restoreCursor

    --- Adds a task to run in the main loop.
    ---@param func function The function to run, usually an `os.pullEvent` loop
    function PrimeUI.addTask(func)
        expect(1, func, "function")
        local t = {coro = coroutine.create(func)}
        coros[#coros+1] = t
        _, t.filter = coroutine.resume(t.coro)
    end

    --- Sends the provided arguments to the run loop, where they will be returned.
    ---@param ... any The parameters to send
    function PrimeUI.resolve(...)
        coroutine.yield(coros, ...)
    end

    --- Clears the screen and resets all components. Do not use any previously
    --- created components after calling this function.
    function PrimeUI.clear()
        -- Reset the screen.
        term.setCursorPos(1, 1)
        term.setCursorBlink(false)
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
        term.clear()
        -- Reset the task list and cursor restore function.
        coros = {}
        restoreCursor = nil
    end

    --- Sets or clears the window that holds where the cursor should be.
    ---@param win window|nil The window to set as the active window
    function PrimeUI.setCursorWindow(win)
        expect(1, win, "table", "nil")
        restoreCursor = win and win.restoreCursor
    end

    --- Returns the position of a point given in absolute coordinates relative to the specified window,
    --- or nil if this point is outside the window.
    --- Particularly useful when getting data from events.
    --- @param win window The window to check
    --- @param absx number The absolute X position of the point
    --- @param absy number The absolute Y position of the point
    --- @return number|nil x The X position of the point relative to the window, or nil if outside the window
    --- @return number|nil y The Y position of the point relative to the window, or nil if oustide the window
    function PrimeUI.getPosInWindow(win, absx, absy)
        if win == term then return end
        local wins = {}
        -- local x, y = 1, 1
        while win ~= term.native() and win ~= term.current() do
            table.insert(wins, win)
            if not win.getPosition then break end
            -- local wx, wy = win.getPosition()
            -- local ww, wh = win.getSize()
            -- x, y = x + wx - 1, y + wy - 1
            _, win = debug.getupvalue(select(2, debug.getupvalue(win.isColor, 1)), 1) -- gets the parent window through an upvalue
        end
        for i=#wins, 1, -1 do
          win = wins[i]
          local wx, wy = win.getPosition()
          local ww, wh = win.getSize()
          absx, absy = absx - wx + 1, absy - wy + 1
          if absx < 1 or absy < 1 or absx >= ww + 1 or absy >= wh + 1 then
              return nil
          end
        end
        return absx, absy
    end

    --- Runs the main loop, returning information on an action.
    ---@return any ... The result of the coroutine that exited
    function PrimeUI.run()
        while true do
            -- Restore the cursor and wait for the next event.
            if restoreCursor then restoreCursor() end
            local ev = table.pack(os.pullEvent())
            -- Run all coroutines.
            for _, v in ipairs(coros) do
                if v.filter == nil or v.filter == ev[1] then
                    -- Resume the coroutine, passing the current event.
                    local res = table.pack(coroutine.resume(v.coro, table.unpack(ev, 1, ev.n)))
                    -- If the call failed, bail out. Coroutines should never exit.
                    if not res[1] then error(res[2], 2) end
                    -- If the coroutine resolved, return its values.
                    if res[2] == coros then return table.unpack(res, 3, res.n) end
                    -- Set the next event filter.
                    v.filter = res[2]
                end
            end
        end
    end
end

-- DO NOT COPY THIS LINE
return PrimeUI
