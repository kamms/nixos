# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  vars,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
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
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      permittedInsecurePackages = lib.optional (pkgs.obsidian.version == "1.4.16") "electron-25.9.0";
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;


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
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      trusted-users = ["root" "fafa"];
    };
  };
  
#########################################################
##                config from old stuff                ##
#########################################################
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "uinput" ];

  # Configure console keymap
  console.keyMap = "fi";

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
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services = {
    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
        #autoLogin = {
        #  enable = true;
        #  user = "kamms";
        #};
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
  };
  
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  #systemd.services."getty@tty1".enable = false;
  #systemd.services."autovt@tty1".enable = false;

  hardware = {
    opengl = {                                  # Hardware Accelerated Video
      enable = true;
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        vaapiVdpau
        libvdpau-va-gl
        amdvlk
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
      driSupport = true;
      driSupport32Bit = true;
    };
  };
# For virtualization
#  virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;


  environment = {
    systemPackages = with pkgs; [
      firefox
      ungoogled-chromium
      thunderbird
    #  obsidian
      onlyoffice-bin
      libreoffice
      vlc
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
      #sunshine
      psmisc
      flatpak
      appimage-run
      fcron
      fd
      htop
      libva-utils
      cifs-utils
      wget
      duf
#Libraries
      #driversi686Linux.mesa
      #vulkan-extension-layer
      #vulkan-headers
      #vulkan-tools
      #vulkan-validation-layers
      #x265
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


  programs = {
    kdeconnect = {                                    # GSConnect
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
   # virt-manager = {
    #  enable = true;
    #};
  };

#########################################################
##            end of config from old stuff             ##
#########################################################
  networking = {
    hostName = "${vars.systemname}";
    firewall.allowedTCPPorts = [ 22 48010];
  };

  users.users.${vars.user} = {
    isNormalUser = true;
    description = vars.user_desc;
    extraGroups = vars.user_groups;
    openssh.authorizedKeys.keys = [
    # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "${vars.stateversion}"; # Did you read the comment?
}