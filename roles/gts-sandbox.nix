{
  config
, pkgs
, ...
}:

{
  age.secrets.gts-sandbox.file = ../secrets/gts-sandbox.age;

  services.gotosocial = {
    enable = true;
    setupPostgresqlDB = true;
    settings = {
      host = "sandbox.isnt-a.top";
      port = 3001;
      trusted-proxies = ["100.64.0.0/10"];
      bind-address = "0.0.0.0";
      accounts-registration-open = true;
      accounts-reason-required = true;
    };
    #environmentFile = config.age.secrets.gts-sandbox.path;
  };
}
