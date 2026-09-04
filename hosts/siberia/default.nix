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

  # User environment
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    
    users.permafrost = import ./home.nix;
  };
}
