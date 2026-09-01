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

    # Ensure flake is ok to use
    nix flake check --no-build ${self}

    # Prep disks
    sudo disko \
      --mode destroy,format,mount \
      --flake ${self}#"$host"

    # Use the host system swapfile
    sudo fallocate -l 8G /mnt/swapfile
    sudo chmod 600 /mnt/swapfile
    sudo mkswap /mnt/swapfile
    sudo swapon /mnt/swapfile

    # Copy network configs
    sudo mkdir -p /mnt/etc/NetworkManager/system-connections
    sudo cp -a \
      /etc/NetworkManager/system-connections/. \
      /mnt/etc/NetworkManager/system-connections/

    # Install the OS onto the host
    sudo nixos-install \
      --flake ${self}#"$host" \
      --no-root-password

    # Set the user password
    sudo nixos-enter --root /mnt -c "passwd $user"

    # Cleanup
    sudo swapoff /mnt/swapfile
    sudo umount -R /mnt
  '';
}
