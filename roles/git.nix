{ pkgs, ... }: {
  services.git-in = {
    enable = true;
    host = "::";
    port = 3008;
  };
}
