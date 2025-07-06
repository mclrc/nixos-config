# /etc/nixos/modules/hyprland.nix
#
# This is your Hyprland configuration translated into a Nix module
# for Home Manager.

{ pkgs, ... }:

{
  # Enable the Hyprland module
  wayland.windowManager.hyprland.enable = true;

  # The 'settings' attribute set is a direct translation of your hyprland.conf
  wayland.windowManager.hyprland.settings =
    let
      # Define variables for easy reuse, just like in your original config
      mod = "SUPER";
      terminal = "alacritty";
      fileManager = "dolphin";
      menu = "wofi --show drun";
    in
    {
      # Monitors
      monitor = ",preferred,auto,auto";

      # Autostart
      exec-once = [
        "${terminal}"
        "nm-applet &"
        "waybar & hyprpaper &"
      ];

      # Environment Variables
      env = [ "XCURSOR_SIZE,24" "HYPRCURSOR_SIZE,24" ];

      # Look and Feel
      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";
      };

      debug = {
        disable_logs = false;
      };

      decoration = {
        rounding = 6;
        # "rounding_power" is not a valid option, so it's omitted.
        # Check the Hyprland wiki for the latest options.

        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        # "yes, please :)" is cute, but in Nix it's just `true` :)
        enabled = true;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      # Input
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = false;
      };

      gestures = {
        workspace_swipe = false;
      };

      # Keybindings
      bind = [
        "${mod}, return, exec, ${terminal}"
        "${mod}, Q, killactive,"
        "${mod}, M, exit,"
        "${mod}, E, exec, ${fileManager}"
        "${mod}, space, togglefloating,"
        "${mod}, D, exec, ${menu}"
        "${mod}, P, pseudo,"
        # "${mod}, J, togglesplit,"

        # Move focus with mainMod + arrow keys
        "${mod}, left, movefocus, l"
        "${mod}, right, movefocus, r"
        "${mod}, up, movefocus, u"
        "${mod}, down, movefocus, d"

        # Move focus with mainMod + hjkl keys
        "${mod}, h, movefocus, l"
        "${mod}, l, movefocus, r"
        "${mod}, k, movefocus, u"
        "${mod}, j, movefocus, d"

        # Switch workspaces
        "${mod}, 1, workspace, 1"
        "${mod}, 2, workspace, 2"
        "${mod}, 3, workspace, 3"
        "${mod}, 4, workspace, 4"
        "${mod}, 5, workspace, 5"
        "${mod}, 6, workspace, 6"
        "${mod}, 7, workspace, 7"
        "${mod}, 8, workspace, 8"
        "${mod}, 9, workspace, 9"
        "${mod}, 0, workspace, 10"

        # Move active window to a workspace
        "${mod} SHIFT, 1, movetoworkspace, 1"
        "${mod} SHIFT, 2, movetoworkspace, 2"
        "${mod} SHIFT, 3, movetoworkspace, 3"
        "${mod} SHIFT, 4, movetoworkspace, 4"
        "${mod} SHIFT, 5, movetoworkspace, 5"
        "${mod} SHIFT, 6, movetoworkspace, 6"
        "${mod} SHIFT, 7, movetoworkspace, 7"
        "${mod} SHIFT, 8, movetoworkspace, 8"
        "${mod} SHIFT, 9, movetoworkspace, 9"
        "${mod} SHIFT, 0, movetoworkspace, 10"

        # Special workspace (scratchpad)
        "${mod}, S, togglespecialworkspace, magic"
        "${mod} SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces
        "${mod}, mouse_down, workspace, e+1"
        "${mod}, mouse_up, workspace, e-1"

        # Move/resize windows with hjkl
        "${mod} SHIFT, H, movewindow, l"
        "${mod} SHIFT, J, movewindow, d"
        "${mod} SHIFT, K, movewindow, u"
        "${mod} SHIFT, L, movewindow, r"

        # Fullscreen
        "${mod}, f, fullscreen,"

        # Toggle split direction
        "${mod}, v, togglesplit,"
      ];

      # Mouse bindings
      bindm = [
        "${mod}, mouse:272, movewindow"
        "${mod}, mouse:273, resizewindow"
      ];

      # Multimedia keys (binde for keys with release event)
      binde = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      # Multimedia keys (bindl for keys that lock)
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # Window Rules
      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };

  # For settings not yet supported by the Home Manager module,
  # you can use extraConfig.
  wayland.windowManager.hyprland.extraConfig = ''
    # The permissions section from your original config would go here if needed.
    # ecosystem {
    #   enforce_permissions = 1
    # }
  '';
}
