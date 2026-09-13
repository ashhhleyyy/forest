# adapted from https://nixos.org/manual/nixos/stable/#module-services-postgres-upgrading
{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    (
      let
        newPostgres = pkgs.postgresql_18.withPackages (pp: [
          pp.pgroonga
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
        ]);
        cfg = config.services.postgresql;
      in
      pkgs.writeScriptBin "upgrade-pg-cluster" ''
        set -eux
        # XXX it's perhaps advisable to stop all services that depend on postgresql
        systemctl stop postgresql

        export NEWDATA="/var/lib/postgresql/${newPostgres.psqlSchema}"
        export NEWBIN="${newPostgres}/bin"

        export OLDDATA="${cfg.dataDir}"
        export OLDBIN="${cfg.finalPackage}/bin"

        install -d -m 0700 -o postgres -g postgres "$NEWDATA"
        cd "$NEWDATA"
        sudo -u postgres "$NEWBIN/initdb" -D "$NEWDATA" ${lib.escapeShellArgs cfg.initdbArgs}

        sudo -u postgres "$NEWBIN/pg_upgrade" \
          --old-datadir "$OLDDATA" --new-datadir "$NEWDATA" \
          --old-bindir "$OLDBIN" --new-bindir "$NEWBIN" \
          "$@"
      ''
    )
  ];
}
