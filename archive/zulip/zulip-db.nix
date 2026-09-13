{ config, pkgs, ... }: {
  services.postgresql = {
    extraPlugins = ps: with ps; [
      pgroonga
      (pkgs.stdenv.mkDerivation {
        name = "zulip-dicts";
        phases = "installPhase";
        src = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/zulip/zulip/dd678465aed915101f9a74054e28535bbdd88ba3/puppet/zulip/files/postgresql/zulip_english.stop";
          hash = "sha256-F3CmCRkkPURN9Uo7KIFxkajSJsiTYQg1wubKCF2+bAs=";
        };
        installPhase = ''
        mkdir -p $out/share/postgresql/tsearch_data/
        ln -s ${pkgs.hunspellDicts.en_US}/share/hunspell/en_US.dic $out/share/postgresql/tsearch_data/en_us.dict
        ln -s ${pkgs.hunspellDicts.en_US}/share/hunspell/en_US.aff $out/share/postgresql/tsearch_data/en_us.affix
        cp $src $out/share/postgresql/tsearch_data/zulip_english.stop
        '';
      })
    ];

    ensureDatabases = [ "zulip" ];
    ensureUsers = [
      {
        name = "zulip";
        ensureDBOwnership = true;
        ensureClauses.login = true;
      }
    ];
  };
}
