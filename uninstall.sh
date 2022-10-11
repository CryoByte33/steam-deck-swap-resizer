#!/bin/bash
# Author: CryoByte33

# Delete install directory
rmdir -r "$HOME/.swap_resizer"

# Remove Desktop icons
rm -rf ~/Desktop/SwapResizerUninstall.desktop 2>/dev/null
rm -rf ~/Desktop/SwapResizer.desktop 2>/dev/null
