#!/bin/bash
# Author: CryoByte33

# Create a hidden directory for the script
mkdir -p "$HOME/.swap_resizer"

# Install script
curl https://raw.githubusercontent.com/CryoByte33/steam-deck-swap-resizer/main/swap_resizer.sh --silent --output "$HOME/.swap_resizer/swap_resizer.sh"

# Create Desktop icons
rm -rf ~/Desktop/SwapResizerUninstall.desktop 2>/dev/null
echo '#!/usr/bin/env xdg-open
[Desktop Entry]
Name=Uninstall Swap Resizer
Exec=curl https://raw.githubusercontent.com/CryoByte33/steam-deck-swap-resizer/main/uninstall.sh | bash -s --
Icon=delete
Terminal=true
Type=Application
StartupNotify=false' > ~/Desktop/SwapResizerUninstall.desktop
chmod +x ~/Desktop/SwapResizerUninstall.desktop

rm -rf ~/Desktop/SwapResizer.desktop 2>/dev/null
echo '#!/usr/bin/env xdg-open
[Desktop Entry]
Name=Swap Resizer
Exec=bash $HOME/.swap_resizer/swap_resizer.sh
Icon=steamdeck-gaming-return
Terminal=true
Type=Application
StartupNotify=false' > ~/Desktop/SwapResizer.desktop
chmod +x ~/Desktop/SwapResizer.desktop
