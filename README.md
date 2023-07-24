# PrimeUI
A collection of UI component primitives for ComputerCraft.

PrimeUI provides a number of small, mostly self-contained basic UI components that are designed to be embedded directly in a program. These components are left as generic as possible to support many use cases, and are annotated so that even beginners can understand and modify the code.

## Usage
PrimeUI is designed to be copy and pasted directly into a program. First, copy the contents of `util.lua` to the program, skipping over the `return` line at the bottom. Then copy the contents of each component you need below that function, skipping over the lines with `require` at the top. After that, you can use each component as directed by the docs.

Alternatively, a single-file packed version is available in the Releases section. This provides all of the components in PrimeUI as a single table.

`test.lua` contains an example of how to use the various functions. Refer to this for usage examples. EmmyLua docs are provided for VS Code completion.

## License
PrimeUI is donated to the public domain under CC0. Feel free to use any portion of the code as desired, though I'd appreciate leaving a notice that it came from PrimeUI.