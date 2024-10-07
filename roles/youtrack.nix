{
  config
, pkgs
, ...
}:

{
  services.youtrack = {
    enable = true;
    environmentalParameters.listen-port = 3002;
    package = pkgs.youtrack;
  };
}
