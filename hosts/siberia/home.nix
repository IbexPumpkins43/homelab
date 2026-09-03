{ pkgs, ... }:
{
  home = {
    username = "permafrost";
    homeDirectory = "/home/permafrost";  

    packages = with pkgs; [
      bat
      eza
      fzf
      ripgrep
      tree

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
        if not set -q TMUX
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

  # Home Manager cleanup
  services.home-manager.autoExpire = {
    enable = true;
    frequency = "weekly";
    timestamp = "-7 days";
    store.cleanup = true;
  };
}
