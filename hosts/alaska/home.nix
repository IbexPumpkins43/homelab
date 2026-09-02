{ pkgs, ... }:
let
  fontFamily = "JetBrainsMono Nerd Font";
  fontFamilySize = 10.0;
in
{
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
          normal.family = fontFamily;
          size = fontFamilySize;
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
          names = [ fontFamily ];
          size = fontFamilySize;
          style = "Regular";
        };

        bars = [
          {
            position = "top";
      
            fonts = {
              names = [ fontFamily ];
              size = fontFamilySize;
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
}
