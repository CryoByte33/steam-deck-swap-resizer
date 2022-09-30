# steam-deck-swap-resizer
A simple script to help users resize the swap file on their Steam Decks.

## Usage
Any method **REQUIRES** a password set on the Steam Deck. That can be done with the `passwd` command.

### Direct / Simple
This method is one command, but you have to trust the source. I recommend reading the script if you don't trust it.
`wget https://raw.githubusercontent.com/CryoByte33/steam-deck-swap-resizer/main/swap_resizer.sh; chmod +x swap_resizer.sh; sudo ./swap_resizer.sh`

### Local Storage
This method lets you download the script locally to have on hand. You can also modify it if you'd like, but 
I don't recommend that unless you know what you're doing!

```bash
git clone https://github.com/CryoByte33/steam-deck-swap-resizer.git
cd steam-deck-swap-resizer
chmod +x swap_resizer.sh
sudo ./swap_resizer.sh
```
