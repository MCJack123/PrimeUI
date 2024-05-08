-- PrimeUI by JackMacWindows
-- Public domain/CC0

local expect = require "cc.expect".expect

-- Initialization code
local PrimeUI = {}
do
    local loop, resolveValues
    local tasks = {}

    --- Adds a task to run in the main loop.
    ---@param func function The function to run, usually an `os.pullEvent` loop
    ---@return Task task The created task
    function PrimeUI.addTask(func)
        expect(1, func, "function")
        if not loop then error("Please call PrimeUI.clear with the Taskmaster run loop before using this function.", 3) end
        local task = loop:addTask(func)
        tasks[#tasks+1] = task
        return task
    end

    --- Sends the provided arguments to the run loop, where they will be returned.
    ---@param ... any The parameters to send
    function PrimeUI.resolve(...)
        resolveValues = table.pack(...)
        -- Reset the task list and cursor restore function.
        local task
        for _, v in ipairs(tasks) do
            if v == loop.currentTask then task = v
            else v:remove() end
        end
        tasks = {}
        loop:setPreYieldHook(nil)
        -- Don't remove the current task until everything else is done - this never returns.
        if task then task:remove() end
    end

    --- Clears the screen and resets all components. This also stops all tasks,
    --- which causes the run loop to stop if no other tasks were added. Do not
    --- use any previously created components after calling this function. If
    --- called from an action callback, this will never return.
    function PrimeUI.clear(newloop)
        -- Set the run loop if provided.
        if newloop ~= nil then
            expect(1, newloop, "table")
            loop = newloop
        elseif not loop then
            error("Please call PrimeUI.clear with the Taskmaster run loop.", 2)
        end
        -- Reset the screen.
        term.setCursorPos(1, 1)
        term.setCursorBlink(false)
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
        term.clear()
        -- Reset the task list and cursor restore function.
        local task
        for _, v in ipairs(tasks) do
            if v == loop.currentTask then task = v
            else v:remove() end
        end
        tasks = {}
        loop:setPreYieldHook(nil)
        -- Don't remove the current task until everything else is done - this never returns.
        if task then task:remove() end
    end

    --- Sets or clears the window that holds where the cursor should be.
    ---@param win window|nil The window to set as the active window
    function PrimeUI.setCursorWindow(win)
        expect(1, win, "table", "nil")
        loop:setPreYieldHook(win and win.restoreCursor)
    end

    --- Gets the absolute position of a coordinate relative to a window.
    ---@param win window The window to check
    ---@param x number The relative X position of the point
    ---@param y number The relative Y position of the point
    ---@return number x The absolute X position of the window
    ---@return number y The absolute Y position of the window
    function PrimeUI.getWindowPos(win, x, y)
        if win == term then return x, y end
        while win ~= term.native() and win ~= term.current() do
            if not win.getPosition then return x, y end
            local wx, wy = win.getPosition()
            x, y = x + wx - 1, y + wy - 1
            _, win = debug.getupvalue(select(2, debug.getupvalue(win.isColor, 1)), 1) -- gets the parent window through an upvalue
        end
        return x, y
    end

    --- Runs the main loop.
    function PrimeUI.run()
        if not loop then error("Please call PrimeUI.clear with the Taskmaster run loop before using this function.", 2) end
        loop:run(#tasks)
        if resolveValues then
            local t = resolveValues
            resolveValues = nil
            return table.unpack(t, 1, t.n)
        end
    end
end

-- DO NOT COPY THIS LINE
return PrimeUI
