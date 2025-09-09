{ config, ... }:

let
  tls-dir = config.security.acme.certs."${config.networking.hostName}.${config.networking.domain}".directory;
in

{
  services.ergochat = {
    enable = true;
    settings = {
      network = {
        name = "shorksnet";
      };
      server = {
        name = "irc.${config.networking.hostName}.${config.networking.domain}";
        listeners = {
          "127.0.0.1:6667" = {};
          "[::1]:6667" = {};
          ":6698" = {
            tls = {
              cert = "${tls-dir}/fullchain.pem";
              key = "${tls-dir}/key.pem";
            };
            min-tls-version = "1.2";
          };
        };
        casemapping = "precis";
        enforce-utf8 = true;
        motd = pkgs.writeText "shorks.motd" ''
        lol hai
        $c[blue]be $c[pink]gay$c[white] do$c[pink] cr$c[blue]ime
        '';
        motd-formatting = true;
        relaymsg = {
          enabled = true;
          separators = "/";
          available-to-chanops = true;
        };
        max-sendq = "96k";
        compatibility = {
          force-trailing = true;
          send-unprefixed-sasl = true;
          allow-truncation = false;
        };
        ip-limits = {
          count = true;
          max-concurrent-connections = 16;
          throttle = true;
          window = "10m";
          max-connections-per-window = 32;
          cidr-len-ipv4 = 32;
          cidr-len-ipv6 = 64;
          exempted = ["localhost"];
        };
        ip-cloaking = {
          enabled = true;
          enabled-for-always-on = true;
          netname = "shrk";
          cidr-len-ipv4 = 32;
          cidr-len-ipv6 = 64;
          num-bits = 64;
        };
        suppress-lusers = true;
      };
      accounts = {
        authentication-enabled = true;
        registration = {
          enabled = true; # TODO
          allow-before-connect = true;
          throttling = {
            enabled = true;
            duration = "10m";
            max-attempts = 30;
          };
          bcrypt-cost = 12;
          verify-timeout = "0m";
          email-verification = {
            enabled = false;
          };
        };
        login-throttling = {
          enabled = true;
          duration = "1m";
          max-attempts = 3;
        };
        skip-server-password = false;
        login-via-pass-command = false;
        advertise-scram = true;
        require-sasl = {
          enabled = false; # TODO
          exempted = ["localhost"];
        };
        nick-reservation = {
          enabled = true;
          additional-nick-limit = 3;
          method = "strict";
          allow-custom-enforcement = false;
          guest-nickname-format = "guest-*";
          force-guest-format = false;
          force-nick-equals-account = true;
          forbit-anonymous-nick-changes = false;
        };
        multiclient = {
          enabled = true;
          allowed-by-default = true;
          always-on = "opt-out";
          auto-away = "opt-out";
        };
        vhosts = {
          enabled = true;
          max-length = 64;
          valid-regexp = "^[0-9A-Za-z.\\-_/]+$";
        };
        default-user-modes = "+i";
      };
      channels = {
        default-modes = "+ntC";
        max-channels-per-client = 100;
        operator-only-creation = false;
        registration = {
          enabled = true;
          operator-only = false;
          max-channels-per-account = 15;
        };
        list-delay = "60s";
        invite-expiration = "24h";
      };
      oper-classes = {
        chat-moderator = {
          title = "Chat Moderator";
          capabilities = [
            "kill"      # disconnect user sessions
            "ban"       # ban IPs, CIDRs, NUH masks, and suspend accounts (UBAN / DLINE / KLINE)
            "nofakelag" # exempted from "fakelag" restrictions on rate of message sending
            "relaymsg"  # use RELAYMSG in any channel (see the `relaymsg` config block)
            "vhosts"    # add and remove vhosts from users
            "sajoin"    # join arbitrary channels, including private channels
            "samode"    # modify arbitrary channel and user modes
            "snomasks"  # subscribe to arbitrary server notice masks
            "roleplay"  # use the (deprecated) roleplay commands in any channel
          ];
        };
        server-admin = {
          title = "Server Admin";
          extends = "chat-moderator";
          capabilities = [
            "rehash"       # rehash the server, i.e. reload the config at runtime
            "accreg"       # modify arbitrary account registrations
            "chanreg"      # modify arbitrary channel registrations
            "history"      # modify or delete history messages
            "defcon"       # use the DEFCON command (restrict server capabilities)
            "massmessage"  # message all users on the server
          ];
        };
      };
      opers = {
        ash = {
          class = "server-admin";
          hidden = true;
          whois-line = "ash";
          password = "$2a$05$0oqiocj8L0yYnFptpTvavOBJD4hmfJn7xwgtIdhjosO1AOVpjUsvG";
        };
      };
      datastore = {
        autoupgrade = true;
        path = "/var/lib/ergo/ircd.db";
        # TODO: mysql history?
      };
      limits = {
        nicklen = 32;
        identlen = 20;
        realnamelen = 150;
        channellen = 64;
        awaylen = 390;
        kicklen = 390;
        topiclen = 390;
        monitor-entries = 100;
        whowas-entries = 100;
        chan-list-modes = 100;
        registration-messages = 1024;
        multiline = {
          max-bytes = 4096;
          max-lines = 100;
        };
      };
      fakelag = {
        enabled = true;
        window = "1s";
        burst-limit = 5;
        messages-per-window = 2;
        cooldown = "2s";
        command-budgets = {
          CHATHISTORY = 16;
          MARKREAD = 16;
          MONITOR = 1;
          WHO = 4;
          WEBPUSH = 1;
        };
      };
      roleplay = {
        enabled = false;
      };
      history = {
        enabled = true;
        channel-length = 2048;
        client-length = 256;
        autoresize-window = "3d";
        autoreplay-on-join = 0;
        chathistory-maxmessages = 1000;
        znc-maxmessages = 2048;
        restrictions = {
          expire-time = "1w";
          query-cutoff = "none";
        };
        persistent = {
          enabled = false; # TODO?
        };
        retention = {
          allow-individual-delete = true;
        };
        tagmsg-storage = {
          default = false;
          whitelist = [
            "+draft/react"
            "+react"
          ];
        };
      };
      webpush = {
        enabled = true;
        timeout = "10s";
        delay = "30s";
        max-subscriptions = 4;
        expiration = "14d";
      };
    };
  };

  systemd.services.ergochat.serviceConfig.SupplementaryGroups = "acme";
}
