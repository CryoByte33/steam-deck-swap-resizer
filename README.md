# steam-deck-swap-resizer
A simple script to help users resize the swap file on their Steam Decks.

## Usage
This **REQUIRES** a password set on the Steam Deck. That can be done with the `passwd` command.

### Direct / Simple
Download InstallSwapResizer.desktop from this repository with [this link](https://raw.githubusercontent.com/CryoByte33/steam-deck-swap-resizer/main/InstallSwapResizer.desktop) on your Steam Deck, then run it. (Right click and save file)

This will install a script and create a few desktop icons for the swap resizer tool.

### Local Storage
This method lets you download the script locally to have on hand. You can also modify it if you'd like, but 
I don't recommend that unless you know what you're doing!

```bash
git clone https://github.com/CryoByte33/steam-deck-swap-resizer.git
cd steam-deck-swap-resizer
chmod +x swap_resizer.sh
./swap_resizer.sh
```
