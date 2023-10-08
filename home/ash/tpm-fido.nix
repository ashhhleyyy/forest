{ config, pkgs, lib, ... }:
let
  tpm-fido = pkgs.buildGoModule {
    version = "5f8828b82b58f9badeed65718fca72bc31358c5c";
    pname = "tpm-fido";
    src = pkgs.fetchFromGitHub {
      owner = "psanford";
      repo = "tpm-fido";
      rev = "5f8828b82b58f9badeed65718fca72bc31358c5c";
      hash = "sha256-Yfr5B4AfcBscD31QOsukamKtEDWC9Cx2ee4L6HM2554=";
    };
    vendorHash = "sha256-qm/iDc9tnphQ4qooufpzzX7s4dbnUbR9J5L770qXw8Y=";
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
    wrapProgram $out/bin/tpm-fido --prefix PATH : ${lib.makeBinPath [ pkgs.pinentry.gnome3 ]}
    '';
  };
in
{
  systemd.user.services.tpm-fido = {
    Unit = {
      Description = "tpm-fido virtual FIDO2 key";
      StartLimitIntervalSec = 500;
      StartLimitBurst = 5;
      PartOf = [ "graphical-session.target" ];
      Wants = [ "xdg-desktop-autostart.target" ];
      After = [ "xdg-desktop-autostart.target" ];
    };
    Install = {
      WantedBy = ["xdg-desktop-autostart.target" ];
    };
    Service = {
      ExecStart = "${tpm-fido}/bin/tpm-fido";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
