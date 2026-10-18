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

  # KDE Plasma
  services.desktopManager.plasma6.enable = true;
  services.displayManager.plasma-login-manager.enable = true;

  # Fix Baloo file indexer crash
  # https://bugs.kde.org/show_bug.cgi?id=524392#c35
  systemd.user.services.kde-baloo = {
    overrideStrategy = "asDropin";

    serviceConfig.Environment = "QT_QPA_PLATFORM=offscreen";
  };


  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    elisa
  ];

  environment.systemPackages = with pkgs; [
    kdePackages.oxygen
    kdePackages.oxygen-icons
  ];

  # Fonts
  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
      terminus_font
      terminus_font_ttf
    ];
  };

  # Audio
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

  # Bluetooth
  hardware.bluetooth.enable = false;

  # System packages that have integration
  programs.steam.enable = true;

  # Virtualisation
  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      
      vhostUserPackages = with pkgs; [
        virtiofsd
      ];
    };
  };

  programs.virt-manager.enable = true;

  # User
  users.users.ptarmigan = {
    isNormalUser = true;
    shell = pkgs.fish;

    extraGroups = [
      "lpadmin"
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
  };

  # User environment
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    
    users.ptarmigan = import ./home.nix;
  };
}
