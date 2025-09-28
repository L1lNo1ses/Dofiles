{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./bluetooth.nix
    ./bspwm.nix
  ];
  boot.kernelParams=["i915.force_probe=5a85"];
  # OpenGL és videó gyorsítás
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      intel-media-driver
    ];
  };
  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 1;
  };
  boot.tmp.cleanOnBoot = true;
  

  # Hálózat
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # Idő és lokalizáció
  time.timeZone = "Europe/Budapest";
  i18n.defaultLocale = "hu_HU.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "hu_HU.UTF-8";
    LC_IDENTIFICATION = "hu_HU.UTF-8";
    LC_MEASUREMENT = "hu_HU.UTF-8";
    LC_MONETARY = "hu_HU.UTF-8";
    LC_NAME = "hu_HU.UTF-8";
    LC_NUMERIC = "hu_HU.UTF-8";
    LC_PAPER = "hu_HU.UTF-8";
    LC_TELEPHONE = "hu_HU.UTF-8";
    LC_TIME = "hu_HU.UTF-8";
  };

  # Nix beállítások
  nixpkgs.config = {
    allowUnfree = true;
    allowUnsupportedSystem = true;
    joypixels.acceptLicense = true;
  };

  # X server
  services.xserver.enable = true;
  services.xserver.serverFlagsSection = ''
    Option "StandbyTime" "0"
    Option "BlankTime" "0"
    Option "SuspendTime" "0"
    Option "OffTime" "0"
  '';
  services.xserver.layout = "hu";
  services.xserver.xkbVariant = "";

  # LightDM
  services.xserver.displayManager.lightdm.enable = true;

  # Billentyűzet
  console.keyMap = "hu";

  # Nyomtatás
  services.printing.enable = true;

  # Hang
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Felhasználó
  users.users.tibor = {
    isNormalUser = true;
    description = "Tibor";
    extraGroups = ["power" "networkmanager" "wheel"];
    packages = with pkgs; [
      firefox
    ];
    shell = pkgs.zsh;
  };

  # Zsh
  programs.zsh.enable = true;

  # Betűtípusok
  fonts.packages = with pkgs; [
    noto-fonts-emoji
    font-awesome_4
    dejavu_fonts
    joypixels
    liberation_ttf
    (nerdfonts.override { fonts = [ "JetBrainsMono" "AnonymousPro" "Hack" ]; })
  ];
  # Automatikus frissítések
  system.autoUpgrade = {
    enable = true;
    channel = "https://nixos.org/channels/nixos-23.11";
  };

  # Nix GC és optimalizáció
  nix = {
    settings.auto-optimise-store = true;
    gc.automatic = true;
    gc.dates = "weekly";
    gc.options = "--delete-older-than 5d";
  };

  # Rendszer verzió
  system.stateVersion = "23.11";
}
