{ pkgs, ... }:
{
  home = {
    username = "ptarmigan";
    homeDirectory = "/home/ptarmigan";  
   
    packages = with pkgs; [
      # General programs
      amberol
      fragments
      mpv
      vscodium.fhs
      obs-studio

      # IDEs
      jetbrains.clion
      jetbrains.idea
      jetbrains.rider
      jetbrains.rust-rover
      jetbrains.pycharm

      # Utilities
      bat
      eza
      fzf
      rar
      ripgrep
      tree
      unzip
      zip

      # Games
      prismlauncher
      vintagestory

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

      # Java development
      jdk25
      maven
      gradle

      # Rust development
      rustc
      cargo
      clippy
      rustfmt

      # Python development
      python3
      ruff
    ];

    stateVersion = "26.05";
  };

  programs = {
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

    # GNOME extensions
    gnome-shell = {
      enable = true;

      extensions = with pkgs.gnomeExtensions; [
        { package = desktop-icons-ng-ding; }
        { package = appindicator; }
        { package = accent-directories; }
        { package = tint-my-gnome; }
        { package = tinted-shell; }
        { package = system-monitor; }
      ];
    };

    # Librewolf
    librewolf = {
      enable = true;
    
      nativeMessagingHosts = with pkgs; [
        gnome-browser-connector
      ];
    };

    # Tmux config
    tmux = {
      enable = true;

      mouse = true;
      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 10000;
    };

    # direnv config
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  # GTK config
  gtk = {
    enable = true;
  
    gtk2.enable = false;

    gtk3 = {
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
    };

    colorScheme = "dark";
  };

  # GNOME config
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
  
  # Home Manager cleanup
  services.home-manager.autoExpire = {
    enable = true;
    frequency = "weekly";
    timestamp = "-7 days";
  };
}
