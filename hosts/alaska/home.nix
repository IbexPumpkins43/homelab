{ pkgs, ... }:
{
  home = {
    username = "ptarmigan";
    homeDirectory = "/home/ptarmigan";  
   
    packages = with pkgs; [
      # General programs
      mpv
      vscodium.fhs
      obs-studio
      qbittorrent

      # IDEs
      jetbrains.clion
      jetbrains.idea
      jetbrains.rider
      jetbrains.rust-rover
      jetbrains.pycharm
      qtcreator

      # Utilities
      bat
      eza
      freerdp
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
      jdk21
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

      # Crystal development
      crystal
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

    # Librewolf
    librewolf.enable = true;

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

  # Home Manager cleanup
  services.home-manager.autoExpire = {
    enable = true;
    frequency = "weekly";
    timestamp = "-7 days";
  };
}
