{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix
  ];

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kernelParams = [
    "pci=noaer"
  ];

  # Nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
 
  # Timezone, locale, and keyboard
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";

  # Hostname and network management
  networking = {
    hostName = "siberia";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  # Remote administration
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

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
  programs.fish.enable = true;

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
      deno
      git
      python3
      uv
    ];

    serviceConfig = {
      Type = "oneshot";
      User = "permafrost";
    };

    script = ''
      set -e

      # Discord bot 
      if [ ! -d /home/permafrost/6thSonOfSony/.git ]; then
        git clone \
          https://github.com/IbexPumpkins43/6thSonOfSony \
          /home/permafrost/6thSonOfSony
      fi 
       
      cd /home/permafrost/6thSonOfSony
      uv sync

      # yt-dlp POT provider
      if [ ! -d /home/permafrost/bgutil-ytdlp-pot-provider/.git ]; then
        git clone \
          --single-branch \
          --branch 1.3.2 \
          https://github.com/Brainicism/bgutil-ytdlp-pot-provider \
          /home/permafrost/bgutil-ytdlp-pot-provider/
      fi      

      cd /home/permafrost/bgutil-ytdlp-pot-provider/server
      deno install --allow-scripts=npm:canvas --frozen

      # Minecraft servers
      mkdir -p /home/permafrost/MinecraftServers

      # Completed setup marker
      touch /home/permafrost/.siberia-setup-complete
    '';
  };

  # User environment
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    
    users.permafrost = {
      home = {
        username = "permafrost";
        homeDirectory = "/home/permafrost";  
        
        packages = with pkgs; [
          bat
          eza
          fzf
          ripgrep

          # 6thSonOfSony dependencies
          deno
          ffmpeg
          python3
          uv
        ];

        stateVersion = "26.05";
      };

      programs = {
        # Fish config
        fish = {
          enable = true;

          # Always share 1 tmux session
          interactiveShellInit = ''
            if test -n "$SSH_TTY"; and test -z "$TMUX"
              exec tmux new-session -A -s siberia
            end
          '';

          shellAliases = {
            cat = "bat";
            ls = "eza";
            ll = "eza -lh";
            la = "eza -lah";

            # 6thSonOfSony aliases
            ssos = ''
              cd ~/6thSonOfSony/ && \
              uv run sixth-son-of-sony
            '';
            ssospot = ''
              cd ~/bgutil-ytdlp-pot-provider/server/node_modules && \
              deno run \
                --allow-env \
                --allow-net \
                --allow-ffi=. \
                --allow-read=. \
                ../src/main.ts
            '';

            # Minecraft aliases
            java8 = "${pkgs.jdk8_headless}/bin/java";
            java25 = "${pkgs.jdk25_headless}/bin/java";
          };
        };

        # Tmux config
        tmux = {
          enable = true;

          mouse = true;
          baseIndex = 1;
          escapeTime = 0;
          historyLimit = 10000;

          extraConfig = ''
            set -g status-style "bg=blue,fg=black"
          '';
        };
      };
    };
  };

  system.stateVersion = "26.05";
}
