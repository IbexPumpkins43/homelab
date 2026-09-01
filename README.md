# homelab
My NixOS configuration(s) + various dotfiles

# install
```
nmtui

sudo -i

git clone https://github.com/IbexPumpkins43
cd homelab

export NIX_CONFIG="experimental-features = nix-command flakes"

nix flake check

nix run \
  github:nix-community/disko#disko-install -- \
  --flake '.#flake-of-choice' \
  --disk main disk-of-choice \
  --write-efi-boot-entries 

nixos-enter --root /mnt -c 'passwd user-of-choice'

umount -R /mnt

reboot
```
