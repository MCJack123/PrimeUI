local PrimeUI = require "util" -- DO NOT COPY THIS LINE
local expect = require "cc.expect".expect -- DO NOT COPY THIS LINE
-- Start copying below this line. --

--- Creates a text input box.
---@param win window The window to draw on
---@param x number The X position of the left side of the box
---@param y number The Y position of the box
---@param width number The width/length of the box
---@param action function|string A function or `run` event to call when the enter key is pressed
---@param fgColor color|nil The color of the text (defaults to white)
---@param bgColor color|nil The color of the background (defaults to black)
---@param replacement string|nil A character to replace typed characters with
---@param history string[]|nil A list of previous entries to provide
---@param completion function|nil A function to call to provide completion
---@param default string|nil A string to return if the box is empty
---@return Task task The task that handles key input
function PrimeUI.inputBox(win, x, y, width, action, fgColor, bgColor, replacement, history, completion, default)
    expect(1, win, "table")
    expect(2, x, "number")
    expect(3, y, "number")
    expect(4, width, "number")
    expect(5, action, "function", "string")
    fgColor = expect(6, fgColor, "number", "nil") or colors.white
    bgColor = expect(7, bgColor, "number", "nil") or colors.black
    expect(8, replacement, "string", "nil")
    expect(9, history, "table", "nil")
    expect(10, completion, "function", "nil")
    expect(11, default, "string", "nil")
    -- Create a window to draw the input in.
    local box = window.create(win, x, y, width, 1)
    box.setTextColor(fgColor)
    box.setBackgroundColor(bgColor)
    box.clear()
    -- Call read() in a new coroutine.
    return PrimeUI.addTask(function()
        -- We need a child coroutine to be able to redirect back to the window.
        local coro = coroutine.create(read)
        -- Run the function for the first time, redirecting to the window.
        local old = term.redirect(box)
        local ok, res = coroutine.resume(coro, replacement, history, completion, default)
        term.redirect(old)
        -- Run the coroutine until it finishes.
        while coroutine.status(coro) ~= "dead" do
            -- Get the next event.
            local ev = table.pack(os.pullEvent())
            -- Redirect and resume.
            old = term.redirect(box)
            ok, res = coroutine.resume(coro, table.unpack(ev, 1, ev.n))
            term.redirect(old)
            -- Pass any errors along.
            if not ok then error(res) end
        end
        -- Send the result to the receiver.
        action(res)
        -- Spin forever, because tasks cannot exit.
        while true do os.pullEvent() end
    end)
end