{ config, pkgs, ... }: {
  imports = [ ./zulip-db.nix ];

  age.secrets.zulip-env.file = ../secrets/zulip-env.age;
  age.secrets.zulip-redis.file = ../secrets/zulip-redis.age;

  services.memcached = {
    enable = true;
    listen = "0.0.0.0";
  };

  services.rabbitmq = {
    enable = true;
    listenAddress = "::";
  };

  services.redis.servers.zulip = {
    enable = true;
    port = 6381;
    bind = "0.0.0.0";
    # TODO: move to agenix secret
    requirePassFile = config.age.secrets.zulip-redis.path;
  };

  virtualisation.oci-containers.containers.zulip = {
    image = "zulip/docker-zulip:8.4-0";
    autoStart = false;
    environment = {
      DB_HOST = "host.containers.internal";
      DB_HOST_PORT = "5432";
      DB_USER = "zulip";

      SETTING_MEMCACHED_LOCATION = "host.containers.internal:11211";
      SETTING_RABBITMQ_HOST = "host.containers.internal";
      SETTING_RABBITMQ_USERNAME = "zulip";
      SETTING_REDIS_HOST = "host.containers.internal";
      SETTING_REDIS_PORT = "6381";

      SETTING_EXTERNAL_HOST = "chat.shorks.gay";
      SETTING_ZULIP_ADMINISTRATOR = "zulip@shorks.gay";

      DISABLE_HTTPS = "true";
      SSL_CERTIFICATE_GENERATION = "self-signed";
      LOADBALANCER_IPS = "100.64.0.0/10,10.0.0.0/8";
      QUEUE_WORKERS_MULTIPROCESS = "false";

      SETTING_EMAIL_HOST = "smtp.migadu.com";
      SETTING_EMAIL_HOST_USER = "shorks@shorks.gay";
      SETTING_EMAIL_USE_TLS = "True";
      SETTING_EMAIL_PORT = "465";
      SETTING_ADD_TOKENS_TO_NOREPLY_ADDRESS = "True";
      SETTING_TOKENIZED_NOREPLY_EMAIL_ADDRESS = "chat+{token}@shorks.gay";
      SETTING_NOREPLY_EMAIL_ADDRESS = "chat@shorks.gay";
      SETTING_INSTALLATION_NAME = "shorks.gay zulip";
      SETTING_SOCIAL_AUTH_OIDC_ENABLED_IDPS = ''{
  "keycloak": {
    "oidc_url": "https://account.shorks.gay/realms/shorks/",
    "display_name": "shorks.gay account",
    "display_icon": None,
    "client_id": "zulip",
    "secret": get_secret("social_auth_oidc_secret"),
  }
}'';

      ZULIP_AUTH_BACKENDS = "GenericOpenIdConnectBackend";
    };
    environmentFiles = [
      config.age.secrets.zulip-env.path
    ];
    ports = [
      "8080:80"
    ];
    volumes = [
      "/var/lib/zulip:/data"
    ];
  };

  services.caddy.virtualHosts."chat.shorks.gay".extraConfig = ''
    reverse_proxy 127.0.0.1:8080 {
      transport http {
        read_buffer 0
        write_buffer 0
        read_timeout 20m
      }
    }
  '';
}
