{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix
  ];

  # Bootloader
  boot.loader = {
    systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 10;
    };

    efi.canTouchEfiVariables = true;
  };

  # Nix features and garbage collector
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
 
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Timezone, locale, and keyboard
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";

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

  # System packages
  environment.systemPackages = with pkgs; [
    curl
    git
    htop
    pciutils
    usbutils
    vim
    wget
  ];
 
  # System packages that have integration
  programs = {
    fish.enable = true;
    steam.enable = true;
  
    nm-applet = {
      enable = true;
      indicator = false;
    };
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

  system.stateVersion = "26.05";
}
