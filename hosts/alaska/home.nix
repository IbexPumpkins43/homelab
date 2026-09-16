{ pkgs, ... }:
{
  home = {
    username = "ptarmigan";
    homeDirectory = "/home/ptarmigan";  
   
    packages = with pkgs; [
      # Utilities
      bat
      eza
      fooyin
      fzf
      qbittorrent
      ripgrep
      tree
      unzip
      vlc
      vscodium.fhs
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
      csharp-ls

      # Rust development
      rustc
      cargo
      clippy
      rustfmt
      rust-analyzer

      # Python development
      python3
      ruff
      pyrefly

      # Zig development
      zig
      zls
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

  services = {
    # Home Manager cleanup
    home-manager.autoExpire = {
      enable = true;
      frequency = "weekly";
      timestamp = "-7 days";
      store.cleanup = true;
    };
  };
}
