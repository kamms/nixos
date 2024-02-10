# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  vars,
  ...
}: 
let sunshine = pkgs.sunshine;
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = true;
    };
  };

  # TODO: Set your username
  home = {
    username = vars.user;
    homeDirectory = "/home/${vars.user}";
  };

  ######################################
  ##        user packages             ##
  ######################################

  home.packages = with pkgs; [
    isoimagewriter
    phoronix-test-suite
    rpi-imager
    gamemode
    gamescope
    tartube-yt-dlp
    pcloud
    sunshine
#    obsidian
    p3x-onenote
    vial
    via
    #dropbox
    syncthing
    maestral
    maestral-gui
    gphotos-sync
    deja-dup
    nerdfonts
    #(nerdfonts.override { fonts = [ "FiraCode" ]; })
  # DEV
    go
    # Gnome extensions
    gnome.gnome-tweaks
  ];
  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  #home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName  = "${vars.user_desc}";
      userEmail = "${vars.user_email}";
      difftastic = {
        enable = true;
        display = "side-by-side-show-both";
      };
    };
    #gamemode.enable = true;
    #gamescope.enable = true;
  #  steam.enable = true;
  };
  # Nicely reload system units when changing configs
  #systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "${vars.hm_stateversion}";


  ######################################
  ##        dconf settings            ##
  ######################################

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "discord.desktop"
        "steam.desktop"
        "code.desktop"
        "signal-desktop.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Console.desktop"
        "org.remmina.remmina.desktop"
        "virt-manager.desktop"
      ];
      disable-user-extensions = false;
      remember-mount-password = true;
      enabled-extensions = [
        "trayiconsreloaded@selfmade.pl"
        "blur-my-shell@aunetx"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "just-perfection-desktop@just-perfection"
        "caffeine@patapon.info"
        "gnap@vibou"
        "clipboard-indicator@tudmotu.com"
        "horizontal-workspace-indicator@tty2.io"
        "bluetooth-quick-connect@bjarosze.gmail.com"
        "battery-indicator@jgotti.org"
        "gsconnect@andyholmes.github.io"
        "pip-on-top@rafostar.github.com"
        "dash-to-dock@micxgx.gmail.com"
        "gSnap@micahosborne"
        "arcmenu@arcmenu.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "quick-settings-tweaks@qwreey"
        "custom-accent-colors@demiskp"
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        "wireless-hid@chlumskyvaclav.gmail.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
      ];
    };
    "org/gnome/desktop/background" = {
      "picture-uri" =  "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-l.jpg";
      "picture-uri-dark" =  "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-d.jpg";
      "primary-color" = "#3071AE";
      "secondary-color" = "#000000";
      "color-shading-type" = "solid";
      "picture-options" = "zoom";
    };
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      clock-show-weekday = true;
      clock-show-seconds = true;
      clock-format = "24h";
      
      # gtk-theme = "adwaita-dark";
    };
    "org/gnome/desktop/privacy" = {
      report-technical-problems = true;
    };  
    "org/gnome/desktop/wmpreferences" = {
        action-right-click-titlebar = "toggle-maximize";
        action-middle-click-titlebar = "minimize";
        resize-with-right-button = true;
        mouse-button-modifier = "<super>";
        button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/desktop/keybindings" = {
      switch-windows = ["<alt>tab"];
      switch-windows-backward = ["<shift><alt>tab"];
      switch-applications = ["<super>tab"];
      switch-applications-backward = ["<shift><super>tab"];
      # maximize = ["<super>up"];                   # Floating
      # unmaximize = ["<super>down"];
      maximize = ["@as []"];                        # Tiling
      unmaximize = ["@as []"];
      switch-to-workspace-left = ["<alt>left"];
      switch-to-workspace-right = ["<alt>right"];
      switch-to-workspace-1 = ["<alt>1"];
      switch-to-workspace-2 = ["<alt>2"];
      switch-to-workspace-3 = ["<alt>3"];
      switch-to-workspace-4 = ["<alt>4"];
      switch-to-workspace-5 = ["<alt>5"];
      move-to-workspace-left = ["<shift><alt>left"];
      move-to-workspace-right = ["<shift><alt>right"];
      move-to-workspace-1 = ["<shift><alt>1"];
      move-to-workspace-2 = ["<shift><alt>2"];
      move-to-workspace-3 = ["<shift><alt>3"];
      move-to-workspace-4 = ["<shift><alt>4"];
      move-to-workspace-5 = ["<shift><alt>5"];
      move-to-monitor-left = ["<super><alt>left"];
      move-to-monitor-right = ["<super><alt>right"];
      close = ["<super>q" "<alt>f4"];
      toggle-fullscreen = ["<super>f"];
    };

    "org/gnome/mutter" = {
      workspaces-only-on-primary = false;
      center-new-windows = true;
      edge-tiling = false;                          # Tiling
      overlay-key = "Super_L";

    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-interactive-ac-type = "suspend";
      sleep-inyeractive-ac-timeout = "5400";
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      home = ["<super>e"];
      email = "";
    };

    "org/gnome/shell/extensions/arcmenu" = {
      show-activities-button = true;
      search-entry-border-radius = "(true, 25)";
      position-in-panel = "Center";
      menu-layout = "Eleven";
      menu-position-alignment = 0;
      menu-separate-color = "rgba(255,255,255,0.1)";
      menu-item-hover-bg-color = "rgb(21,83,158)";
      menu-item-hover-fg-color = "rgb(255,255,255)";
      menu-item-active-bg-color = "rgb(21,83,158)";
      menu-item-active-fg-color = "rgb(255,255,255)";
      menu-foreground-color = "rgb(223,223,223)";
      menu-button-position-offset = 1;
      menu-button-appearance = "Icon";
      force-menu-location = "BottomCentered";
    };
      
    "org/gnome/shell/extensions/custom-accent-colors" = {
      accent-color = "Purple";
      theme-flatpak = true;
      theme-gtk3 = true;
      theme-shell = true;
    };

      
    "org/gnome/shell/extensions/dash-to-dock" = {
      animation-time = 0;
      apply-custom-theme = true;
      background-opacity = 0.8;
      custom-theme-shrink = true;
      dash-max-icon-size = 48;
      dock-position = "BOTTOM";
      extend-height = false;
      height-fraction = 0.6;
      hide-delay = 0.1;
      intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
      isolate-workspaces = true;
      middle-click-action = "launch";
      preview-size-scale = 0.43;
      scroll-action = "cycle-windows";
      shift-click-action = "minimize";
      shift-middle-click-action = "launch";
      show-mounts-network = false;
    };
    
    "org/gnome/shell/extensions/gtile" = {
      global-presets = true;
      grid-sizes = "8x6,6x4,4x4";
      insets-primary-bottom = 1;
      insets-primary-left = 1;
      insets-primary-right = 1;
      insets-primary-top = 1;
      insets-secondary-bottom = 1;
      insets-secondary-left = 1;
      insets-secondary-right = 1;
      insets-secondary-top = 1;
      show-grid-lines = true;
      show-toggle-tiling = "<super>z";
      theme = "Minimal Dark";
    };
    "org/gnome/shell/extensions/dash-to-panel" = {   # Set Manually
      panel-position = ''{"0":"top","1":"top"}'';
      panel-sizes = ''{"0":24,"1":24}'';
      panel-element-positions-monitors-sync = true;
      appicon-margin = 0;
      appicon-padding = 4;
      dot-position = "top";
      dot-style-focused = "solid";
      dot-style-unfocused = "dots";
      animate-appicon-hover = true;
      animate-appicon-hover-animation-travel = "{'simple': 0.14999999999999999, 'ripple': 0.40000000000000002, 'plank': 0.0}";
      isolate-monitors = true;
    };
    "org/gnome/shell/extensions/just-perfection" = {
      theme = true;
      activities-button = false;
      app-menu = false;
      clock-menu-position = 1;
      clock-menu-position-offset = 7;
    };
    "org/gnome/shell/extensions/caffeine" = {
      enable-fullscreen = true;
      restore-state = true;
      show-indicator = true;
      show-notification = false;
    };
    "org/gnome/shell/extensions/blur-my-shell" = {
      brightness = 0.9;
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      customize = true;
      sigma = 0;
    };
    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      customize = true;
      sigma = 0;
    };
    "org/gnome/shell/extensions/horizontal-workspace-indicator" = {
      widget-position = "left";
      widget-orientation = "horizontal";
      icons-style = "circles";
    };
    "org/gnome/shell/extensions/bluetooth-quick-connect" = {
      show-battery-icon-on = true;
      show-battery-value-on = true;
    };
    "org/gnome/shell/extensions/pip-on-top" = {
      stick = true;
    };
    "org/gnome/shell/extensions/forge" = {
      window-gap-size = 8;
      dnd-center-layout = "stacked";
    };
    "org/gnome/shell/extensions/forge/keybindings" = { # Set Manually
      focus-border-toggle = true;
      float-always-on-top-enabled = true;
      window-focus-up = ["<super>up"];
      window-focus-down = ["<super>down"];
      window-focus-left = ["<super>left"];
      window-focus-right = ["<super>right"];
      window-move-up = ["<shift><super>up"];
      window-move-down = ["<shift><super>down"];
      window-move-left = ["<shift><super>left"];
      window-move-right = ["<shift><super>right"];
      window-swap-last-active = ["@as []"];
      window-toggle-float = ["<shift><super>f"];
    };
  };


}