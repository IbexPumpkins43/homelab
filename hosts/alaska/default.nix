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
    
    users.ptarmigan = {
      home = {
        username = "ptarmigan";
        homeDirectory = "/home/ptarmigan";  
        
        packages = with pkgs; [
          bat
          eza
          feh
          fooyin
          fzf
          pcmanfm
          qbittorrent
          ripgrep
          tree
          vlc
          vscodium

          # C/C++ development
          clang-tools
          cmake
          gcc
          gdb
          gnumake
          pkg-config
          valgrind
          
          # C# development
          dotnetCorePackages.sdk_10_0

          # Rust development
          rustc
          cargo
          clippy
          rustfmt
          rust-analyzer

          # Python development
          python3
          ruff
          pyright

          # Ada development
          alire
          gnat
          gprbuild
        ];

        stateVersion = "26.05";
      };

      programs = {
        # Alacritty config
        alacritty = {
          enable = true;

          settings = {
            terminal.shell = {
              program = "${pkgs.tmux}/bin/tmux";
              args = [
                "new-session"
              ];
            };
            
            font = {
              normal.family = "JetBrainsMono Nerd Font";
              size = 10.0;
            };

            colors = {
              primary = {
                background = "#000000";
                foreground = "#aaaaaa";
              };

              normal = {
                black = "#000000";
                red = "#aa0000";
                green = "#00aa00";
                yellow = "#aa5500";
                blue = "#0000aa";
                magenta = "#aa00aa";
                cyan = "#00aaaa";
                white = "#aaaaaa";
              };

              bright = {
                black = "#555555";
                red = "#ff5555";
                green = "#55ff55";
                yellow = "#ffff55";
                blue = "#5555ff";
                magenta = "#ff55ff";
                cyan = "#55ffff";
                white = "#ffffff";
              };
            };
          };
        };

        # Fish config
        fish = {
          enable = true;

          shellAliases = {
            cat = "bat";
            ls = "eza";
            ll = "eza -lh";
            la = "eza -lah";
          };
        };

        # Git config
        git = {
          enable = true;
          
          settings = {
            credential.helper = "store";

            user = {
              name = "IbexPumpkins43";
              email = "283789752+IbexPumpkins43@users.noreply.github.com";
            };
          };
        };

        librewolf.enable = true;

        # Tmux config
        tmux = {
          enable = true;

          mouse = true;
          baseIndex = 1;
          escapeTime = 0;
          historyLimit = 10000;
        };
      };

      # i3 config
      xsession = {
        enable = true;

        windowManager.i3 = {
          enable = true;

          config = {
            modifier = "Mod4";
            terminal = "alacritty";

            fonts = {
              names = [ "JetBrainsMono Nerd Font" ];
              size = 10.0;
              style = "Regular";
            };

            bars = [
              {
                position = "bottom";
          
                fonts = {
                  names = [ "JetBrainsMono Nerd Font" ];
                  size = 10.0;
                  style = "Regular";
                };

                statusCommand = "${pkgs.i3status}/bin/i3status";
                trayOutput = "primary";
              }
            ];
          };
        };
      };

      services = {
        # Screen locking service
        screen-locker = {
          enable = true;
          lockCmd = "${pkgs.i3lock}/bin/i3lock --nofork -c 000000";
          inactiveInterval = 10;
        };

        # Notifications service
        dunst.enable = true;
        # Compositor
        picom.enable = true;
        # Drive management service
        udiskie.enable = true;
      };

      # Polkit service
      systemd.user.services.polkit-gnome-authentication-agent-1 = {
        Unit = {
          Description = "Polkit authentication agent";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
        };

        Install.WantedBy = ["graphical-session.target" ];
      };
    };
  };

  system.stateVersion = "26.05";
}
