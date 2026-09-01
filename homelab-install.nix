{
  pkgs,
  self,
  disko
}:
pkgs.writeShellApplication {
  name = "homelab-install";

  runtimeInputs = [
    disko.packages.x86_64-linux.disko
    pkgs.nix
    pkgs.nixos-install-tools
    pkgs.util-linux
  ];

  text = ''
    set -e

    if [ "$#" -ne 1 ]; then
      echo "usage: homelab-install <host>"
      exit 1
    fi

    host="$1"

    case "$host" in
      alaska)
        disk="/dev/disk/by-id/nvme-CT1000P3SSD8_24294A05B115"
        user="ptarmigan"
        ;;

      siberia)
        disk="/dev/disk/by-id/ata-CT480BX500SSD1_2133E5C3EE93"
        user="permafrost"
        ;;

      *)
        echo "error: Invalid host"
        exit 1
        ;;
    esac

    nix flake check ${self}

    sudo disko-install \
      --flake ${self}#"$host" \
      --disk main "$disk" \
      --extra-files \
        /etc/NetworkManager/system-connections \
        etc/NetworkManager/system-connections \
      --write-efi-boot-entries

    sudo disko --mode mount --flake ${self}#"$host"

    sudo nixos-enter --root /mnt -c "passwd $user"

    sudo umount -R /mnt
  '';
}
