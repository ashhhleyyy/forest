{ pkgs, ... }: {
  services.git-in = {
    enable = true;
    host = "::";
    port = 3008;
    update-timer.enable = true;
    config = ''
      instance {
        name "ash git"
      }

      repository name="aci" path = "/var/lib/git-in/aci.git/" {
        group "apps"
      }
      repository name="ashleah.moe" path = "/var/lib/git-in/ashleah.moe.git/" {
        group "web"
      }
      repository name="ashleah.rest" path = "/var/lib/git-in/ashleah.rest.git/" {
        group "web"
      }
      repository name="binaryninja-xex" path = "/var/lib/git-in/binaryninja-xex.git/" {
        group "tools"
      }
      repository name="buxus" path = "/var/lib/git-in/buxus.git/" {
        group "infra"
      }
      repository name="comicbox" path = "/var/lib/git-in/comicbox.git/" {
        group "apps"
      }
      repository name="forest" path = "/var/lib/git-in/forest.git/" {
        group "infra"
      }
      repository name="fsh" path = "/var/lib/git-in/fsh.git/" {
        group "tools"
      }
      repository name="git-in" path = "/var/lib/git-in/git-in.git/" {
        group "web"
      }
      repository name="ma-kasi-sona" path = "/var/lib/git-in/ma-kasi-sona.git/" {
        group "web"
      }
      repository name="player-pronouns" path = "/var/lib/git-in/player-pronouns.git/" {
        group "minecraft"
      }
      repository name="railing-it" path = "/var/lib/git-in/railing-it.git/" {
        group "apps"
      }
      repository name="shorks-keycloak" path = "/var/lib/git-in/shorks-keycloak.git/" {
        group "shorks.gay"
      }
      repository name="tomo-lipu" path = "/var/lib/git-in/tomo-lipu.git/" {
        group "apps"
      }
      repository name="website" path = "/var/lib/git-in/website.git/" {
        group "web"
      }
    ''
  };
}
