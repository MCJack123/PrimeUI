// Uses @jackmacwindows/cc-types types for CC objects.

type BlitImageFrame = [string, string, string][] & {
    duration?: number,
    palette?: ([number] | [number, number, number])[]
};
type BlitImage = BlitImageFrame[] & {
    version: string,
    animated: boolean,
    author?: string,
    title?: string,
    description?: string,
    creator?: string,
    date?: string,
    width?: number,
    height?: number,
    secondsPerFrame?: number,
    palette?: ([number] | [number, number, number])[]
}

declare namespace PrimeUI {
    /**
     * Adds a task to run in the main loop.
     * @param func The function to run, usually an `os.pullEvent` loop
     */
    function addTask(func: () => void): void;

    /**
     * Sends the provided arguments to the run loop, where they will be returned.
     * @param args The parameters to send
     */
    function resolve(...args: any[]): never;

    /**
     * Clears the screen and resets all components. Do not use any previously
     * created components after calling this function.
     */
    function clear(): void;

    /**
     * Sets or clears the window that holds where the cursor should be.
     * @param win The window to set as the active window
     */
    function setCursorWindow(win: Window | null | undefined): void;

    /**
     * Gets the absolute position of a coordinate relative to a window.
     * @param win The window to check
     * @param x The relative X position of the point
     * @param y The relative Y position of the point
     * @return The absolute X and Y position of the window
     */
    function getWindowPos(win: ITerminal, x: number, y: number): LuaMultiReturn<[number, number]>;

    /**
     * Runs the main loop, returning information on an action.
     * @return The result of the coroutine that exited
     */
    function run(): LuaMultiReturn<any[]>;

    /**
     * Draws a thin border around a screen region.
     * @param win The window to draw on
     * @param x The X coordinate of the inside of the box
     * @param y The Y coordinate of the inside of the box
     * @param width The width of the inner box
     * @param height The height of the inner box
     * @param fgColor The color of the border (defaults to white)
     * @param bgColor The color of the background (defaults to black)
     */
    function borderBox(win: ITerminal, x: number, y: number, width: number, height: number, fgColor?: Color, bgColor?: Color): void;

    /**
     * Creates a clickable button on screen with text.
     * @param win The window to draw on
     * @param x The X position of the button
     * @param y The Y position of the button
     * @param text The text to draw on the button
     * @param action A function to call when clicked, or a string to send with a `run` event
     * @param fgColor The color of the button text (defaults to white)
     * @param bgColor The color of the button (defaults to light gray)
     * @param clickedColor The color of the button when clicked (defaults to gray)
     */
    function button(win: ITerminal, x: number, y: number, text: string, action: (() => void) | string, fgColor?: Color, bgColor?: Color, clickedColor?: Color): void;

    /**
     * Draws a line of text at a position.
     * @param win The window to draw on
     * @param x The X position of the left side of the box
     * @param y The Y position of the box
     * @param width The width of the box to draw in
     * @param text The text to draw
     * @param fgColor The color of the text (defaults to white)
     * @param bgColor The color of the background (defaults to black)
     */
    function centerLabel(win: ITerminal, x: number, y: number, width: number, text: string, fgColor?: Color, bgColor?: Color): void;

    /**
     * Creates a list of entries with toggleable check boxes.
     * @param win The window to draw on
     * @param x The X coordinate of the inside of the box
     * @param y The Y coordinate of the inside of the box
     * @param width The width of the inner box
     * @param height The height of the inner box
     * @param selections A list of entries to show, where the value is whether the item is pre-selected (or `"R"` for required/forced selected)
     * @param action A function or `run` event that's called when a selection is made
     * @param fgColor The color of the text (defaults to white)
     * @param bgColor The color of the background (defaults to black)
     */
    function checkSelectionBox(win: ITerminal, x: number, y: number, width: number, height: number, selections: {[key: string]: boolean | "R"}, action: (() => void) | string, fgColor?: Color, bgColor?: Color): void;

    /**
     * Draws a BIMG-formatted image to the screen. This does not support transparency,
     * and does not handle animation on its own (but the index parameter may be
     * used by apps to implement animation).
     * @param win The window to draw on
     * @param x The X position of the top left corner of the image
     * @param y The Y position of the top left corner of the image
     * @param data The path to the image to load, or the image data itself
     * @param index The index of the frame to draw (defaults to 1)
     * @param setPalette Whether to set the palette if the image contains one (defaults to true)
     */
    function drawImage(win: ITerminal, x: number, y: number, data: string | BlitImage, index?: number, setPalette?: boolean): void;

    /** Draws a block of text inside a window with word wrapping, optionally resizing the window to fit.
     * @param win The window to draw in
     * @param text The text to draw
     * @param resizeToFit Whether to resize the window to fit the text (defaults to false). This is useful for scroll boxes.
     * @param fgColor The color of the text (defaults to white)
     * @param bgColor The color of the background (defaults to black)
     * @return The total number of lines drawn
     */
    function drawText(win: ITerminal, text: string, resizeToFit?: boolean, fgColor?: Color, bgColor?: Color): number;

    /**
     * Draws a horizontal line at a position with the specified width.
     * @param win The window to draw on
     * @param x The X position of the left side of the line
     * @param y The Y position of the line
     * @param width The width/length of the line
     * @param fgColor The color of the line (defaults to white)
     * @param bgColor The color of the background (defaults to black)
     */
    function horizontalLine(win: ITerminal, x: number, y: number, width: number, fgColor?: Color, bgColor?: Color): void;

    /**
     * Creates a text input box.
     * @param win window The window to draw on
     * @param x number The X position of the left side of the box
     * @param y number The Y position of the box
     * @param width number The width/length of the box
     * @param action function|string A function or `run` event to call when the enter key is pressed
     * @param fgColor color|nil The color of the text (defaults to white)
     * @param bgColor color|nil The color of the background (defaults to black)
     * @param replacement string|nil A character to replace typed characters with
     * @param history string[]|nil A list of previous entries to provide
     * @param completion function|nil A function to call to provide completion
     * @param default string|nil A string to return if the box is empty
     */
    function inputBox(win: ITerminal, x: number, y: number, width: number, action: (() => void) | string, fgColor?: Color, bgColor?: Color, replacement?: string, history?: string[], completion?: (partial: string) => string[], defaultString?: string): void;

    /**
     * Runs a function or action repeatedly after a specified time period until canceled.
     * If a function is passed as an action, it may return a number to change the
     * period, or `false` to stop it.
     * @param time The amount of time to wait for each time, in seconds
     * @param action The function to call when the timer completes, or a `run` event to send
     * @return A function to cancel the timer
     */
    function interval(time: number, action: (() => number | false | null | undefined | void) | string): () => void;

    /**
     * Adds an action to trigger when a key is pressed.
     * @param key The key to trigger on, from `keys.*`
     * @param action A function to call when clicked, or a string to use as a key for a `run` return event
     */
    function keyAction(key: Key, action: (() => void) | string): void;

    /**
     * Adds an action to trigger when a key is pressed with modifier keys.
     * @param key The key to trigger on, from `keys.*`
     * @param withCtrl Whether Ctrl is required
     * @param withAlt Whether Alt is required
     * @param withShift Whether Shift is required
     * @param action A function to call when clicked, or a string to use as a key for a `run` return event
     */
    function keyCombo(key: Key, withCtrl: boolean, withAlt: boolean, withShift: boolean, action: (() => void) | string): void;

    /**
     * Draws a line of text at a position.
     * @param win The window to draw on
     * @param x The X position of the left side of the text
     * @param y The Y position of the text
     * @param text The text to draw
     * @param fgColor The color of the text (defaults to white)
     * @param bgColor The color of the background (defaults to black)
     */
    function label(win: ITerminal, x: number, y: number, text: string, fgColor?: Color, bgColor?: Color): void;

    /**
     * Creates a progress bar, which can be updated by calling the returned function.
     * @param win The window to draw on
     * @param x The X position of the left side of the bar
     * @param y The Y position of the bar
     * @param width The width of the bar
     * @param fgColor The color of the activated part of the bar (defaults to white)
     * @param bgColor The color of the inactive part of the bar (defaults to black)
     * @param useShade Whether to use shaded areas for the inactive part (defaults to false)
     * @return A function to call to update the progress of the bar, taking a number from 0.0 to 1.0
     */
    function progressBar(win: ITerminal, x: number, y: number, width: number, fgColor?: Color, bgColor?: Color, useShade?: boolean): (progress: number) => void;

    /**
     * Creates a scrollable window, which allows drawing large content in a small area.
     * @param win The parent window of the scroll box
     * @param x The X position of the box
     * @param y The Y position of the box
     * @param width The width of the box
     * @param height The height of the outer box
     * @param innerHeight The height of the inner scroll area
     * @param allowArrowKeys Whether to allow arrow keys to scroll the box (defaults to true)
     * @param showScrollIndicators Whether to show arrow indicators on the right side when scrolling is available, which reduces the inner width by 1 (defaults to false)
     * @param fgColor The color of scroll indicators (defaults to white)
     * @param bgColor The color of the background (defaults to black)
     * @return The inner window to draw inside
     */
    function scrollBox(win: ITerminal, x: number, y: number, width: number, height: number, innerHeight: number, allowArrowKeys?: boolean, showScrollIndicators?: boolean, fgColor?: Color, bgColor?: Color): Window;

    /**
     * Creates a list of entries that can each be selected.
     * @param win The window to draw on
     * @param x The X coordinate of the inside of the box
     * @param y The Y coordinate of the inside of the box
     * @param width The width of the inner box
     * @param height The height of the inner box
     * @param entries A list of entries to show, where the value is whether the item is pre-selected (or `"R"` for required/forced selected)
     * @param action A function or `run` event that's called when a selection is made
     * @param selectChangeAction A function or `run` event that's called when the current selection is changed
     * @param fgColor The color of the text (defaults to white)
     * @param bgColor The color of the background (defaults to black)
     */
    function selectionBox(win: ITerminal, x: number, y: number, width: number, height: number, entries: string[], action: (() => void) | string, selectChangeAction?: (() => void) | string, fgColor?: Color, bgColor?: Color): void;

    /**
     * Creates a text box that wraps text and can have its text modified later.
     * @param win The parent window of the text box
     * @param x The X position of the box
     * @param y The Y position of the box
     * @param width The width of the box
     * @param height The height of the box
     * @param text The initial text to draw
     * @param fgColor The color of the text (defaults to white)
     * @param bgColor The color of the background (defaults to black)
     * @return A function to redraw the window with new contents
     */
    function textBox(win: ITerminal, x: number, y: number, width: number, height: number, text: string, fgColor?: Color, bgColor?: Color): (text: string) => void;

    /**
     * Runs a function or action after the specified time period, with optional canceling.
     * @param time The amount of time to wait for, in seconds
     * @param action The function to call when the timer completes, or a `run` event to send
     * @returns A function to cancel the timer
     */
    function timeout(time: number, action: (() => void) | string): () => void;
}