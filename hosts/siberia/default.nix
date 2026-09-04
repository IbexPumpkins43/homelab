{ pkgs, ... }:
{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ./disk-configuration.nix
  ];

  # Without this the Wi-Fi card spams error messages, filling up the disk
  boot.kernelParams = [
      "pci=noaer"
  ];

  # Hostname and network management
  networking = {
    hostName = "siberia";
    networkmanager.enable = true;
    firewall = {
      enable = true;

      # Open ports for Minecraft servers
      allowedTCPPorts = [
        25565
        25566
        25567
      ];
    };
  };

  # Remote administration
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  # User
  users.users.permafrost = {
    isNormalUser = true;
    shell = pkgs.fish;

    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Application setup
  systemd.services.siberia-setup = {
    description = "Set up Siberia applications";

    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    unitConfig.ConditionPathExists = "!/home/permafrost/.siberia-setup-complete";

    path = with pkgs; [
      git
    ];

    serviceConfig = {
      Type = "oneshot";
      User = "permafrost";
      Restart = "on-failure";
      RestartSec = "15s";
    };

    script = ''
      set -e

      # Discord bot 
      if [ ! -d /home/permafrost/dukebox/.git ]; then
        git clone \
          https://github.com/IbexPumpkins43/dukebox \
          /home/permafrost/dukebox
      fi 
       
      cd /home/permafrost/dukebox
      nix develop --command cargo build --release

      # Completed setup marker
      touch /home/permafrost/.siberia-setup-complete
    '';
  };

  # User environment
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    
    users.permafrost = import ./home.nix;
  };
}
