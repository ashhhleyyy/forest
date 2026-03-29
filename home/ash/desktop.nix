{ config, pkgs, ... }: {
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
    kdePackages.kcolorchooser

    kdePackages.krfb
    kdePackages.krdc
  ];

  programs.direnv.enable = true;

  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    font.name = "JetBrainsMono Nerd Font";
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "Ashhhleyyy";
      email = "ash@ashhhleyyy.dev";
    };
    signing = {
      key = "83B789081A0878FB";
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
  programs.ssh.matchBlocks."*" = {
    addKeysToAgent = "yes";
  };
}
