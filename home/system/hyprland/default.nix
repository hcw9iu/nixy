{ pkgs, config, inputs, ... }: {

  imports = [ ./hyprlock.nix ./hypridle.nix ./hyprpaper.nix ];

  home.packages = with pkgs; [
    hyprshot
    hyprpicker
    hyprcursor
    xdg-desktop-portal-hyprland
    wlr-randr
    wl-clipboard
    brightnessctl
    gnome.gnome-themes-extra
    wlsunset
    xwayland
    xdg-desktop-portal-gtk
    wlroots
    qt5ct
    libva
    dconf
    wayland-utils
    wayland-protocols
    meson
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;

    settings = {
      "$mod" = "SUPER";
      "$shiftMod" = "SUPER_SHIFT";

      exec-once = [
        "startup"
        "${pkgs.hypridle}/bin/hypridle"
        "${pkgs.hyprpaper}/bin/hyprpaper"
        "${pkgs.bitwarden}/bin/bitwarden"
      ];

      monitor = [
        "eDP-2,highres,0x0,1"
        # "DP-9,highrr,2560x0,1"
        # ",prefered,auto,1"
        #"desc:,2560x1440@240.0,0x0,1.0"
        #"desc:,2560x1440@60.0,645x4362,1.0"
        "desc:AOC U34G2G1 0x00000E06,3440x1440@59.97,2560x0,1.0"
        ",disable"
      ];

      bind = [
        "$mod, RETURN, exec, ${pkgs.kitty}/bin/kitty"
        "$mod, E, exec, ${pkgs.xfce.thunar}/bin/thunar"
        "$mod, B, exec, ${pkgs.qutebrowser}/bin/qutebrowser"
        "$mod, K, exec, ${pkgs.bitwarden}/bin/bitwarden"
        "$mod, C, exec, ${pkgs.kitty}/bin/kitty --class peaclock peaclock"
        "$mod, L, exec, ${pkgs.hyprlock}/bin/hyprlock"
        "$mod, X, exec, powermenu"
        "$mod, SPACE, exec, menu"
        # Windows control
        "$mod, Q, killactive,"
        "$mod, T, togglefloating,"
        "$mod, F, fullscreen"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        # Screenshots
        "$mod, PRINT, exec, screenshot window"
        ", PRINT, exec, screenshot monitor"
        "$shiftMod, PRINT, exec, screenshot region"
        "ALT, PRINT, exec, screenshot region swappy"
        # Night Shift
        "$mod, F2, exec, night-shift-off"
        "$mod, F3, exec, night-shift-on"
        # Sound output
        "$mod, F5, exec, ${pkgs.kitty}/bin/kitty --class floating zsh -c sound-output"
        "$mod, F6, exec, ${pkgs.kitty}/bin/kitty --class floating zsh -c sound-output"
        "$mod, F7, exec, ${pkgs.kitty}/bin/kitty --class floating zsh -c sound-output"
      ] ++ (builtins.concatLists (builtins.genList (i:
        let ws = i + 1;
        in [
          "$mod, code:1${toString i}, workspace, ${toString ws}"
          "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
        ]) 9));

      bindm = [ "$mod, mouse:272, movewindow" "$mod, R, resizewindow" ];

      bindl = [
        ",XF86AudioMute, exec, sound-toggle"
        ",switch:Lid Switch, exec, ${pkgs.hyprlock}/bin/hyprlock"
      ];

      bindle = [
        ", XF86AudioRaiseVolume, exec, sound-up"
        ", XF86AudioLowerVolume, exec, sound-down"
        ", XF86MonBrightnessUp, exec, brightness-up"
        ", XF86MonBrightnessDown, exec, brightness-down"
      ];

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
        "XDG_SESSION_TYPE,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM=wayland,xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "GTK_THEME,FlatColor:dark"
        "GTK2_RC_FILES,/home/hadi/.local/share/themes/FlatColor/gtk-2.0/gtkrc"
        # "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        # "HYPRCURSOR_SIZE,16"
      ];

      general = {
        resize_on_border = true;
        gaps_in = config.var.theme.gaps-in;
        gaps_out = config.var.theme.gaps-out;
        border_size = config.var.theme.border-size;
        "col.active_border" = "rgba(${config.var.theme.colors.accent}ff)";
        "col.inactive_border" = "rgba(00000055)";
        border_part_of_window = true;
        layout = "master";
      };

      decoration = {
        rounding = config.var.theme.rounding;
        drop_shadow = true;
        shadow_range = 20;
        shadow_render_power = 3;
        "col.shadow" = "rgba(00000055)";
        blur = { enabled = false; };
      };

      master = { new_is_master = true; };

      gestures = { workspace_swipe = true; };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
        new_window_takes_over_fullscreen = 2;
      };

      input = {
        kb_layout = config.var.keyboardLayout;

        kb_options = "caps:escape";
        follow_mouse = 1;
        sensitivity = 0.5;
        repeat_delay = 300;
        repeat_rate = 50;
        numlock_by_default = true;

        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = true;
        };
      };

      windowrulev2 = [
        "float, class:peaclock"
        "move 2% 78%, class:peaclock"
        "size 30% 20%, class:peaclock"

        "float, class:floating"
        "size 40% 40%, class:floating"
        "move 30% 30%, class:floating"

        "float, title:Bluetooth Devices"
        "move 20% 20%, title:Bluetooth Devices"
        "size 60% 60%, title:Bluetooth Devices"
      ];

      animations = {
        enabled = true;
        # animations from end-4 dotfiles
        bezier = [
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92 "
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.38, 0.04, 1, 0.07"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "softAcDecel, 0.26, 0.26, 0.15, 1"
          "md2, 0.4, 0, 0.2, 1"
          # old
          # "linear, 0, 0, 1, 1"
          # "md3_standard, 0.2, 0, 0, 1"
          # "md3_decel, 0.05, 0.7, 0.1, 1"
          # "md3_accel, 0.3, 0, 0.8, 0.15"
          # "overshot, 0.05, 0.9, 0.1, 1.1"
          # "crazyshot, 0.1, 1.5, 0.76, 0.92 "
          # "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          # "fluent_decel, 0.1, 1, 0, 1"
          # "easeInOutCirc, 0.85, 0, 0.15, 1"
          # "easeOutCirc, 0, 0.55, 0.45, 1"
          # "easeOutExpo, 0.16, 1, 0.3, 1"
        ];

        animation = [
          "windows, 1, 3, md3_decel, popin 60%"
          "windowsIn, 1, 3, md3_decel, popin 60%"
          "windowsOut, 1, 3, md3_accel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 3, md3_decel"
          # animation = layers, 1, 2, md3_decel, slide
          "layersIn, 1, 3, menu_decel, slide"
          "layersOut, 1, 1.6, menu_accel"
          "fadeLayersIn, 1, 2, menu_decel"
          "fadeLayersOut, 1, 4.5, menu_accel"
          "workspaces, 1, 7, menu_decel, slide"
          # animation = workspaces, 1, 2.5, softAcDecel, slide
          # animation = workspaces, 1, 7, menu_decel, slidefade 15%
          # animation = specialWorkspace, 1, 3, md3_decel, slidefadevert 15%
          "specialWorkspace, 1, 3, md3_decel, slidevert"
          # old
          # "windows, 1, 3, md3_decel, popin 60%"
          # "border, 1, 10, default"
          # "fade, 1, 2.5, md3_decel"
          # "workspaces, 1, 3.5, easeOutExpo, slide"
          # "specialWorkspace, 1, 3, md3_decel, slidevert"
        ];
      };

    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk2";
    style.name = "gtk2";
  };

  gtk = {
    enable = true;

    theme = { name = "FlatColor"; };

    iconTheme = {
      package = pkgs.flat-remix-icon-theme;
      name = "Flat-Remix-Grey-Darkest";
    };

    font = {
      name = config.var.theme.font;
      size = 11;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 14;
  };
}
