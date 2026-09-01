# homelab
My NixOS configuration(s) + various dotfiles

# install
```
nmtui

sudo -i

git clone https://github.com/IbexPumpkins43
cd homelab

export NIX_CONFIG="experimental-features = nix-command flakes"

nix run .#installer -- host-of-your-choice

reboot
```
