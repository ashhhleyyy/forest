{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    firefox
    cachix
    dino
    thunderbird
    vlc
    unrar # for ark
    ghidra
    keepassxc
    vlc
    rpi-imager
    kdePackages.kcolorchooser

    kdePackages.krfb
    kdePackages.krdc
  ];

  programs.direnv.enable = true;

  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    font.name = "JetBrainsMono Nerd Font";
    settings.auto_reload_config = -1;
    shellIntegration.enableFishIntegration = true;
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "Ashhhleyyy";
      email = "ash@ashhhleyyy.dev";
    };
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519_sk-git-signing";
      signByDefault = true;
    };
    lfs.enable = true;
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Ashhhleyyy";
        email = "ash@ashhhleyyy.dev";
      };
    };
  };

  programs.gpg = {
    enable = true;
    mutableKeys = true;
    mutableTrust = true;
  };

  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
    pinentry.package = pkgs.pinentry-qt;
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
    maxCacheTtlSsh = 31536000;
    defaultCacheTtlSsh = 31536000;
  };

  services.ssh-agent.enable = true;
  programs.ssh.enable = true;
  programs.ssh.settings."*" = {
    addKeysToAgent = "yes";
  };
  programs.ssh.settings."ssh.york.ac.uk" = {
    controlMaster = "auto";
    controlPath = "~/.ssh/connection_%h_%p_%r";
    controlPersist = "4h";
  };

  home.file = {
    ".ssh/config".force = true;
  };
  home.activation = {
    # https://github.com/nix-community/home-manager/issues/322
    fixSshPermissions = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      run install -d -m 0700 "$HOME/.ssh"
      if [ -L "$HOME/.ssh/config" ]; then
        src="$(readlink -f "$HOME/.ssh/config")"
        run rm -f "$HOME/.ssh/config"
        run install -m 0600 "$src" "$HOME/.ssh/config"
      fi
    '';
  };

  programs.nushell.enable = true;
}
