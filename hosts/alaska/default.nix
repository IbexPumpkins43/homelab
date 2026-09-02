{ pkgs, ... }:
{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ./disk-configuration.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Hostname and network management
  networking = {
    hostName = "alaska";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  # Mullvad VPN
  services.mullvad-vpn = {
    enable = true;
    enableEarlyBootBlocking = true;
    enableExcludeWrapper = false;
    gui.enable = true;
  };

  # Intel graphics and hardware acceleration
  hardware.graphics = {
    enable = true;
    
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  # Power management
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;

  # X11, Window manager, and display manager
  services.xserver = {
    enable = true;
    xkb.layout = "gb";
    windowManager.i3.enable = true;
  };

  services.displayManager.ly.enable = true;

  # Fonts
  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
    ];

    fontconfig.useEmbeddedBitmaps = true;
  };

  # Screen locking
  security.pam.services.i3lock = { };

  # Polkit
  security.polkit.enable = true;

  # Audio
  security.rtkit.enable = true;
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Printing
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    openFirewall = true;
  };

  # File manager and removable media support
  services.gvfs.enable = true;

  # System packages that have integration
  programs.steam.enable = true;

  programs.nm-applet = {
    enable = true;
    indicator = false;
  };

  # User
  users.users.ptarmigan = {
    isNormalUser = true;
    shell = pkgs.fish;

    extraGroups = [
      "lpadmin"
      "networkmanager"
      "wheel"
    ];
  };

  # User environment
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    
    users.ptarmigan = import ./home.nix;
  };
}
