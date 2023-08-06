local PrimeUI = require "util" -- DO NOT COPY THIS LINE
local expect = require "cc.expect".expect -- DO NOT COPY THIS LINE
-- Start copying below this line. --
local nft = require "cc.image.nft"

--- Draws a NFT-formatted image to the screen. This does not support transparency,
--- and does not handle animation on its own (but the index parameter may be
--- used by apps to implement animation).
---@param win window The window to draw on
---@param x number The X position of the top left corner of the image
---@param y number The Y position of the top left corner of the image
---@param data string|table The path to the image to load, or the image data itself
---@param index number|nil The index of the frame to draw (defaults to 1)
---@param setPalette boolean|nil Whether to set the palette if the image contains one (defaults to true)
function PrimeUI.drawImage(win, x, y, data)
    expect(1, win, "table")
    expect(2, x, "number")
    expect(3, y, "number")
    expect(4, data, "string", "table")
    -- Load the image file if a string was passed. (This consists of reading the file and unserializing.)
    if type(data) == "string" then
        data = assert(nft.load("data/example.nft"), "File is not a valid NFT file")
    end
    nft.draw(data, x, y , win)
end
