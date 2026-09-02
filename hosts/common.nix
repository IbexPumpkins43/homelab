{
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

  # Timezone, locale, and keyboard
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";

  # System packages that all users might need
  environment.systemPackages = with pkgs; [
    curl
    git
    htop
    pciutils
    usbutils
    vim
    wget
  ];

  # Enable the fish shell
  programs.fish.enable = true;

  system.stateVersion = "26.05";
}
