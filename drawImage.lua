local PrimeUI = require "util" -- DO NOT COPY THIS LINE
local expect = require "cc.expect".expect -- DO NOT COPY THIS LINE
-- Start copying below this line. --

--- Draws a BIMG-formatted image to the screen. This does not support transparency,
--- and does not handle animation on its own (but the index parameter may be
--- used by apps to implement animation).
---@param win window The window to draw on
---@param x number The X position of the top left corner of the image
---@param y number The Y position of the top left corner of the image
---@param data string|table The path to the image to load, or the image data itself
---@param index number|nil The index of the frame to draw (defaults to 1)
---@param setPalette boolean|nil Whether to set the palette if the image contains one (defaults to true)
function PrimeUI.drawImage(win, x, y, data, index, setPalette)
    expect(1, win, "table")
    expect(2, x, "number")
    expect(3, y, "number")
    expect(4, data, "string", "table")
    index = expect(5, index, "number", "nil") or 1
    expect(6, setPalette, "boolean", "nil")
    if setPalette == nil then setPalette = true end
    -- Load the image file if a string was passed. (This consists of reading the file and unserializing.)
    if type(data) == "string" then
        local file = assert(fs.open(data, "rb"))
        local filedata = file.readAll()
        file.close()
        data = assert(textutils.unserialize(filedata), "File is not a valid BIMG file")
    end
    -- Blit each line to the screen.
    for line = 1, #data[index] do
        win.setCursorPos(x, y + line - 1)
        win.blit(table.unpack(data[index][line]))
    end
    -- Set the palette if one exists and is desired.
    local palette = data[index].palette or data.palette
    if setPalette and palette then
        for i = 0, #palette do
            win.setPaletteColor(2^i, table.unpack(palette[i]))
        end
    end
end