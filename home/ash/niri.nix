{ config, pkgs, ... }: {
  programs.niri = {
    settings = {
      input = {
        focus-follows-mouse.enable = true;
        keyboard.xkb.layout = "gb";
      };
      layout = {
        gaps = 8;
        preset-column-widths = [
          { proportion = 1. / 3.; }
          { proportion = 1. / 2.; }
          { proportion = 2. / 3.; }
        ];
        default-column-width.proportion = 1. / 2.;
        focus-ring = {
          active.color = "#cba6f7";
          inactive.color = "#313244";
        };
      };
      binds = with config.lib.niri.actions; {
        "Mod+Shift+Slash".action = show-hotkey-overlay;
        
        "Mod+T".action = spawn "kitty";
        "Mod+Space".action = spawn "fuzzel";
        "Super+Alt+L".action = spawn "swaylock";

        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
        };
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
        };

        "Mod+Q".action = close-window;

        "Mod+Left".action = focus-column-left;
        "Mod+Down".action = focus-window-down;
        "Mod+Up".action = focus-window-up;
        "Mod+Right".action = focus-column-right;
        "Mod+H".action = focus-column-left;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+L".action = focus-column-right;

        "Mod+Ctrl+Left".action = move-column-left;
        "Mod+Ctrl+Down".action = move-window-down;
        "Mod+Ctrl+Up".action = move-window-up;
        "Mod+Ctrl+Right".action = move-column-right;
        "Mod+Ctrl+H".action = move-column-left;
        "Mod+Ctrl+J".action = move-window-down;
        "Mod+Ctrl+K".action = move-window-up;
        "Mod+Ctrl+L".action = move-column-right;

        "Mod+Home".action = focus-column-first;
        "Mod+End".action = focus-column-last;
        "Mod+Ctrl+Home".action = move-column-to-first;
        "Mod+Ctrl+End".action =  move-column-to-last;

        "Mod+Shift+Left".action = focus-monitor-left;
        "Mod+Shift+Down".action = focus-monitor-down;
        "Mod+Shift+Up".action = focus-monitor-up;
        "Mod+Shift+Right".action = focus-monitor-right;
        "Mod+Shift+H".action = focus-monitor-left;
        "Mod+Shift+J".action = focus-monitor-down;
        "Mod+Shift+K".action = focus-monitor-up;
        "Mod+Shift+L".action = focus-monitor-right;

        "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
        "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;

        "Mod+Page_Down".action = focus-workspace-down;
        "Mod+Page_Up".action = focus-workspace-up;
        "Mod+U".action = focus-workspace-down;
        "Mod+I".action = focus-workspace-up;
        "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
        "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
        "Mod+Ctrl+U".action = move-column-to-workspace-down;
        "Mod+Ctrl+I".action = move-column-to-workspace-up;

        "Mod+Shift+Page_Down".action = move-workspace-down;
        "Mod+Shift+Page_Up".action = move-workspace-up;
        "Mod+Shift+U".action = move-workspace-down;
        "Mod+Shift+I".action = move-workspace-up;

        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;
        "Mod+Ctrl+1".action = move-column-to-workspace 1;
        "Mod+Ctrl+2".action = move-column-to-workspace 2;
        "Mod+Ctrl+3".action = move-column-to-workspace 3;
        "Mod+Ctrl+4".action = move-column-to-workspace 4;
        "Mod+Ctrl+5".action = move-column-to-workspace 5;
        "Mod+Ctrl+6".action = move-column-to-workspace 6;
        "Mod+Ctrl+7".action = move-column-to-workspace 7;
        "Mod+Ctrl+8".action = move-column-to-workspace 8;
        "Mod+Ctrl+9".action = move-column-to-workspace 9;

        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;

        "Mod+R".action = switch-preset-column-width;
        "Mod+Shift+R".action = reset-window-height;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+C".action = center-column;

        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";

        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        "Print".action = screenshot;
        "Ctrl+Print".action = screenshot-screen;
        "Alt+Print".action = screenshot-window;

        "Mod+Shift+E".action = quit;
        "Mod+Shift+P".action = power-off-monitors;
      };
    };
  };

  programs.swaylock.enable = true;

  programs.fuzzel = {
    enable = true;
  };

  programs.waybar = {
    enable = true;
    style = ./waybar/style.css;
    settings = [{
      "layer" = "top"; # Waybar at top layer
      "position" = "top"; # Waybar position (top|bottom|left|right)
      # "width" = 1280; # Waybar width
      # Choose the order of the modules
      "modules-left" = [
        "wlr/workspaces"
      ];
      "modules-center" = [
        # "custom/music"
      ];
      "modules-right" = [
        "wireplumber"
        "backlight"
        "battery"
        "clock"
        "tray"
        "custom/lock"
        "custom/power"
      ];
      "wlr/workspaces" = {
          "disable-scroll" = true;
          "sort-by-name" = true;
          "format" = " {icon} ";
          "format-icons" = {
              "default" = "";
          };
      };
      "tray" = {
          "icon-size" = 21;
          "spacing" = 10;
      };
      # "custom/music" = {
      #     "format" = "  {}";
      #     "escape" = true;
      #     "interval" = 5;
      #     "tooltip" = false;
      #     "exec" = "playerctl metadata --format='{{ title }}'";
      #     "on-click" = "playerctl play-pause";
      #     "max-length" = 50
      # };
      "clock" = {
          "timezone" = "Europe/London";
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "format-alt" = " {:%d/%m/%Y}";
          "format" = "󰥔 {:%H:%M}";
      };
      "backlight" = {
          "device" = "intel_backlight";
          "format" = "{icon}";
          "format-icons" = ["" "" "" "" "" "" "" "" ""];
      };
      "battery" = {
          "states" = {
              "warning" = 30;
              "critical" = 15;
          };
          "format" = "{icon}";
          "format-charging" = "{icon} 󰚥";
          "format-plugged" = "󰐧";
          "format-alt" = "{icon}";
          "format-icons" = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ""];
      };
      "wireplumber" = {
          # "scroll-step" = 1, # %, can be a float
          "format" = "{icon} {volume}%";
          "format-muted" = " {volume}%";
          "format-icons" = {
              "default" = ["" "" " "];
          };
      };
      "wireplumber#source" = {
        format = " {source}";
      };
      "custom/lock" = {
          "tooltip" = false;
          "on-click" = "sh -c '(sleep 0.5s; swaylock --grace 0)' & disown";
          "format" = "";
      };
      "custom/power" = {
          "tooltip" = false;
          "on-click" = "niri msg action quit";
          "format" = "Logout";
      };
    }];
    systemd.enable = true;
  };

  services.mako = {
    enable = true;
  };

  systemd.user.services."swaybg" = {
    Unit = {
      Description = "swaybg";
      PartOf = ["graphical-session.target"];
      After = ["niri.service"];
      Requisite = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i /home/ash/wallpaper.png";
      Restart = "on-failure";
    };
  };

  systemd.user.services."pam_kwallet_init" = {
    Unit = {
      Description = "Unlock kwallet on login";
      PartOf = ["graphical-session.target"];
      Requisite = ["graphical-session.target"];
      After = ["niri.service"];
    };
    Service = {
      ExecStart = "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init";
      Type = "simple";
      Restart = "no";
      Slice = "background.slice";
    };
  };
}
