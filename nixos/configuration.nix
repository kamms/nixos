{ inputs, lib, config, pkgs, vars, ... }: 
  
{
  # You can import other NixOS modules here
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = lib.optional (pkgs.obsidian.version == "1.4.16") "electron-25.9.0";
    };
  };

  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
    };
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = ["root" "kamms"];
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  ## This was added for sunshine
  boot.kernelModules = [ "uinput" ];
  console.keyMap = "fi";

  ## linking mounted drives
  system.userActivationScripts.linktosharedfolder.text = ''
    if [[ ! -h "$HOME/Drives" ]]; then
      ln -s "/mnt/Drives" "$HOME/Drives"
    fi
  '';

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "fi_FI.UTF-8";
      LC_IDENTIFICATION = "fi_FI.UTF-8";
      LC_MEASUREMENT = "fi_FI.UTF-8";
      LC_MONETARY = "fi_FI.UTF-8";
      LC_NAME = "fi_FI.UTF-8";
      LC_NUMERIC = "fi_FI.UTF-8";
      LC_PAPER = "fi_FI.UTF-8";
      LC_TELEPHONE = "fi_FI.UTF-8";
      LC_TIME = "fi_FI.UTF-8";
    };
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
    extraHosts = ''
      192.168.1.237 newvault
    '';
  };
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";
  
  # Enable sound with pipewire.
  sound.enable = true;
  hardware = {
    pulseaudio.enable = false;
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };
  };
  security.rtkit.enable = true;

  services = {
    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
      };
      desktopManager = {
        gnome = {
          enable = true;
        };
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };
    printing = {
      enable = true;
    };
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
      publish.userServices = true;
    };
    udev.extraRules = ''
      KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
    '';
    openssh = {
      enable = true;
      settings = {
        # Forbid root login through SSH.
        PermitRootLogin = "no";
        # Use keys only. Remove if you want to SSH using password (not recommended)
        PasswordAuthentication = false;
      };
    };
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      dataDir = "/home/${vars.user}";
      configDir = "/home/${vars.user}/.config/syncthing";
      user = "${vars.user}";
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        gui = {
            user = "${vars.user}";
            password = "syncthingpassword";
        };
        devices = {
          "drawing-laptop" = { 
            id = "FLEWFPB-7UUHJEX-2BTZ36J-G52BIQ6-EETPH7K-PEQK7VS-PMILL3W-UZYBYA6"; 
          };
          "newvault" = {
            id = "63YSERC-YEH6NAK-GNOEZLO-AYDVN2G-N44AFHA-V3W7XKA-43ADXGL-L7PFPQT";
          };
        };
        folders = {
          "documents" = { 
            path = "/home/${vars.user}/Documents"; 
            devices = [ "newvault" ]; 
            ignorePerms = true;
            type = "sendonly";
          };
          "pictures" = { 
            path = "/home/${vars.user}/Pictures"; 
            devices = [ "newvault" ]; 
            ignorePerms = true;
            type = "sendonly";
          };
          "flakes" = { 
            path = "/home/${vars.user}/Flakes"; 
            devices = [ "newvault" ]; 
            ignorePerms = true;
            type = "sendonly";
          };
          "downloads" = { 
            path = "/home/${vars.user}/Downloads/Synced"; 
            devices = [ "newvault" ]; 
            ignorePerms = true;
            type = "sendonly";
          };
          "dotfiles" = { 
            path = "/home/${vars.user}/.dotfiles"; 
            devices = [ "newvault" ]; 
            ignorePerms = true;
            type = "sendonly";
          };
        };
      };
    };
  };
  
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

# For virtualization
#  virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  ######################################
  ##          packages                ##
  ######################################
  
  environment = {
    systemPackages = with pkgs; [
      firefox
      ungoogled-chromium
      thunderbird
      obsidian
      onlyoffice-bin
      libreoffice
      vlc
      sunshine
      krita
      gimp-with-plugins
      calibre
      whatsapp-for-linux
      vscode-with-extensions
      zoom
      pdfchain
      pinta
      signal-desktop
      zotero
      #planify
      scribus
      inkscape
      remmina
      telegram-desktop
      discord
      shotwell
      lutris-unwrapped
      steam
      heroic
      geany
      vim
      rclone
      rsync
      image-roll
      lsof
      nano
      usbutils
      hwloc
      zip
      unzip
      p7zip
      dmidecode
      pciutils
      rar
      gnutar
      neofetch
      lynis
      htop
      glances
      psmisc
      flatpak
      appimage-run
      fcron
      fd
      htop
      libva-utils
      cifs-utils
      wget
      vulkan-tools 
      duf
#Libraries
      driversi686Linux.mesa
      vulkan-extension-layer
      vulkan-headers
      vulkan-tools 
      vulkan-validation-layers
      x265
#Gnome
      gnome.adwaita-icon-theme
      gnome.dconf-editor
      gnome.gnome-tweaks
      gnomeExtensions.appindicator
      #gnomeExtensions.arcmenu
      gnomeExtensions.sound-output-device-chooser
      gnomeExtensions.battery-indicator-upower
      gnomeExtensions.bluetooth-quick-connect
      gnomeExtensions.blur-my-shell
      gnomeExtensions.caffeine
      gnomeExtensions.clipboard-history
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.custom-accent-colors
      gnomeExtensions.dash-to-dock
      gnomeExtensions.dash-to-panel
      gnomeExtensions.forge
      gnomeExtensions.gsconnect
      gnomeExtensions.gsnap
      gnomeExtensions.gtile
      gnomeExtensions.just-perfection
      gnomeExtensions.openweather
      gnomeExtensions.pip-on-top
      gnomeExtensions.places-status-indicator
      gnomeExtensions.pop-shell
      gnomeExtensions.quick-settings-tweaker
      gnomeExtensions.removable-drive-menu
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.user-themes
      gnomeExtensions.window-list
      gnomeExtensions.wireless-hid
      gnomeExtensions.workspace-indicator-2
    ];
    gnome.excludePackages = (with pkgs.gnome; [
      epiphany geary gnome-contacts gnome-maps gnome-initial-setup gnome-calendar gnome-weather
      #gedit  gnome-characters hitori iagno tali yelp atomix
    ]);
  };

  security.wrappers.sunshine = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_admin+p";
        source = "${pkgs.sunshine}/bin/sunshine";
      };
  systemd.user.services.sunshine =
      {
        description = "sunshine";
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${config.security.wrapperDir}/sunshine";
        };
      };
  programs = {
    kdeconnect = {                                    # GSConnect
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
    virt-manager = {
      enable = true;
    };
  };

  networking = {
    hostName = "${vars.systemname}"; 
    # Syncthing ports: 8384 for remote access to GUI
    # 22000 TCP and/or UDP for sync traffic
    # 21027/UDP for discovery
    # source: https://docs.syncthing.net/users/firewall.html
    # 48010 is sunshine, if it will ever work.
    firewall.allowedTCPPorts = [ 22 48010 8384 22000 ]; 
    firewall.allowedUDPPorts = [ 22000 21027 ]; 
  };
  users.users.${vars.user} = {
    isNormalUser = true;
    description = "${vars.user_desc}";
    extraGroups = vars.user_groups;
    initialPassword = "${vars.user}";
    openssh.authorizedKeys.keys = [
    # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "${vars.stateversion}"; # Did you read the comment?
}