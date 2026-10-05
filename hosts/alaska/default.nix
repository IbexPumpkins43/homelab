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

  # GNOME
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  services.gnome.core-apps.enable = true;
  services.gnome.gnome-browser-connector.enable = true;

  environment.systemPackages = with pkgs; [
    gjs
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome-bluetooth
    gnome-tour
  ];

  # Fonts
  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
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
      swtpm.enable = true;
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
