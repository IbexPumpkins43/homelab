# homelab
My NixOS-based homelab configurations

# install
```
nmtui

sudo -i

git clone https://github.com/IbexPumpkins43/homelab
cd homelab

export NIX_CONFIG="experimental-features = nix-command flakes"

nix run .#homelab-install -- host-of-your-choice

reboot
```
