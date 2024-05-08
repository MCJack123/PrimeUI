local loremIpsum = [[
Sed ducimus nisi consectetur excepturi. Culpa dolores voluptatem quo aut debitis cum distinctio voluptas. Non deserunt dolore id aut magni dolore sit. In error doloribus quasi harum.

Doloremque et dolor sit molestiae quia id rerum. Quia a laudantium omnis voluptatem aut magni. Expedita distinctio ut molestiae assumenda.

Vero sint asperiores sint ad et ducimus omnis blanditiis. Porro corporis veritatis quo consequatur voluptatum itaque cum. Consequatur nihil optio soluta beatae corporis distinctio sed dolores.

Hic assumenda aliquid sunt delectus. Ratione consequatur impedit fuga dolorum a quidem et. Ea illum eius qui placeat exercitationem.

Aspernatur in animi sint perspiciatis aliquam iste vero quas. Cumque beatae vel aut dolorum eos. Alias eligendi iure et et quia non autem possimus. Consectetur vel dicta ut. Officiis ex blanditiis non molestias. Non sed velit rerum aliquid doloribus.
]]

local PrimeUI = require "init"

PrimeUI.clear()
PrimeUI.label(term.current(), 3, 2, "Sample Text")
PrimeUI.horizontalLine(term.current(), 3, 3, #("Sample Text") + 2)
PrimeUI.borderBox(term.current(), 4, 6, 40, 10)
local scroller = PrimeUI.scrollBox(term.current(), 4, 6, 40, 10, 9000, true, true)
PrimeUI.drawText(scroller, loremIpsum, true)
PrimeUI.button(term.current(), 3, 18, "Next", "done")
PrimeUI.keyAction(keys.enter, "done")
PrimeUI.run()

PrimeUI.clear()
PrimeUI.label(term.current(), 3, 2, "Sample Text")
PrimeUI.horizontalLine(term.current(), 3, 3, #("Sample Text") + 2)
PrimeUI.borderBox(term.current(), 4, 6, 40, 10)
local entries = {
    ["Item 1"] = false,
    ["Item 2"] = false,
    ["Item 3"] = "R",
    ["Item 4"] = true,
    ["Item 5"] = false
}
PrimeUI.checkSelectionBox(term.current(), 4, 6, 40, 10, entries)
PrimeUI.button(term.current(), 3, 18, "Next", "done")
PrimeUI.keyAction(keys.enter, "done")
PrimeUI.run()

PrimeUI.clear()
PrimeUI.label(term.current(), 3, 2, "Sample Text")
PrimeUI.horizontalLine(term.current(), 3, 3, #("Sample Text") + 2)
PrimeUI.label(term.current(), 3, 5, "Enter some text.")
PrimeUI.borderBox(term.current(), 4, 7, 40, 1)
PrimeUI.inputBox(term.current(), 4, 7, 40, "result")
local _, _, text = PrimeUI.run()

PrimeUI.clear()
PrimeUI.label(term.current(), 3, 2, "Sample Text")
PrimeUI.horizontalLine(term.current(), 3, 3, #("Sample Text") + 2)
local entries2 = {
    "Option 1",
    "Option 2",
    "Option 3",
    "Option 4",
    "Option 5"
}
local entries2_descriptions = {
    "Sed ducimus nisi consectetur excepturi. Culpa dolores voluptatem quo aut debitis cum distinctio voluptas. Non deserunt dolore id aut magni dolore sit. In error doloribus quasi harum.",
    "Doloremque et dolor sit molestiae quia id rerum. Quia a laudantium omnis voluptatem aut magni. Expedita distinctio ut molestiae assumenda.",
    "Vero sint asperiores sint ad et ducimus omnis blanditiis. Porro corporis veritatis quo consequatur voluptatum itaque cum. Consequatur nihil optio soluta beatae corporis distinctio sed dolores.",
    "Hic assumenda aliquid sunt delectus. Ratione consequatur impedit fuga dolorum a quidem et. Ea illum eius qui placeat exercitationem.",
    "Aspernatur in animi sint perspiciatis aliquam iste vero quas. Cumque beatae vel aut dolorum eos. Alias eligendi iure et et quia non autem possimus. Consectetur vel dicta ut. Officiis ex blanditiis non molestias. Non sed velit rerum aliquid doloribus."
}
local redraw = PrimeUI.textBox(term.current(), 3, 15, 40, 3, entries2_descriptions[1])
PrimeUI.borderBox(term.current(), 4, 6, 40, 8)
PrimeUI.selectionBox(term.current(), 4, 6, 40, 8, entries2, "done", function(option) redraw(entries2_descriptions[option]) end)
local _, _, selection = PrimeUI.run()

PrimeUI.clear()
PrimeUI.label(term.current(), 3, 2, "Sample Text")
PrimeUI.horizontalLine(term.current(), 3, 3, #("Sample Text") + 2)
PrimeUI.centerLabel(term.current(), 3, 5, 42, "Executing " .. selection .. "...")
PrimeUI.borderBox(term.current(), 4, 7, 40, 1)
local progress = PrimeUI.progressBar(term.current(), 4, 7, 40, nil, nil, true)
local i = 0
PrimeUI.interval(0.1, function()
    progress(i / 20)
    i = i + 1
    if i > 20 then
        PrimeUI.resolve("updateProgress", "done")
        return false
    end
end)
PrimeUI.run()

PrimeUI.clear()