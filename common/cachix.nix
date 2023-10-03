{
  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://ashhhleyyy.cachix.org"
      ];
      trusted-public-keys = [
        "ashhhleyyy.cachix.org-1:s38C2TcMTtjaNv9uDwG918ehi0L2Uxw0OlGXPiWRchg="
      ];
    };
  };
}
