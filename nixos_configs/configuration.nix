# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      #./hardware-configuration.nix
      ./dellxps-15-hardware-config.nix
    ];

  # Use the systemd-boot EFI boot loader.
  networking.hostName = "death-nixos-dellxps15";

  boot.loader.systemd-boot = {
    enable = true;
    signed = true;
    signing-key = "/home/death/sign_boot/db.key";
    signing-certificate = "/home/death/sign_boot/db.crt";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.wireless.userControlled.enable = true;
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
    consolePackages = [ pkgs.terminus_font ];
    consoleFont = "ter-c14b";
    consoleKeyMap = "ruwin_alt_sh-UTF-8";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    chromium
    file
    firefox
    fontmatrix
    git
    htop
    mutt
    neofetch
    nixpkgs-fmt
    nyx
    pianobar
    qutebrowser
    scrot
    tig
    toxic
    update-resolv-conf
    vim
    wget
    wpa_supplicant
    xorg.xhost
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.zsh.enable = true;
  programs.zsh.autosuggestions.enable = true;
  programs.bash.enableCompletion = true;
  programs.mtr.enable = true;

  programs.chromium = {
    enable = true;

    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # Ublock origin.
      "gcbommkclmclpchllfjekcdonpmejbdp" # Https everywhere.
      "oiigbmnaadbkfbmpbfijlflahbdbdgdf" # Scriptsafe.
    ];
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.compton = {
    enable = true;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.death = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" ];
    hashedPassword = "$6$uE//d7TK7ZfT7$HKr.6Hb7GcUtJCD9zzbbLZTDvVNLe6DClaiml0eeA51ci5pusRvIScfVHbQQdaWnzMV/yKeOgafTZ44QZE5s50";
    shell = pkgs.zsh;
  };

  programs.vim.defaultEditor = true;
  virtualisation.docker = {
    enable = true;
    storageDriver = "zfs";
  };

  services.tor = {
    enable = true;
    client.enable = true;
    torsocks.enable = true;
    controlPort = 9051;
    extraConfig = '' 
      GeoIPExcludeUnknown 1
      StrictNodes 1 
      ExitNodes {us}
      AllowSingleHopCircuits 0
      EnforceDistinctSubnets 1
      HashedControlPassword 16:DB708F40BC353B036077B08870840209E1AEA15D3FA3437B8B81C7AB60
    '';
  };

  services.redshift = {
    enable = true;
  };
  location.provider = "geoclue2";


  services.privoxy = {
    enable = true;
    extraConfig = ''
      forward-socks5t / 127.0.0.1:9050 .
    '';
  };

  environment.pathsToLink = [
    "/libexec"
    "/share/zsh"
  ];

  fonts.fonts = with pkgs; [
    terminus_font
  ];

  fonts.fontconfig.dpi = lib.mkIf (config.networking.hostName == "death-nixos-dellxps15") 160;

  services.xserver = {
    enable = true;

    dpi = lib.mkIf (config.networking.hostName == "death-nixos-dellxps15") 160;

    libinput = {
      enable = true;
      middleEmulation = true;
      tapping = true;
    };

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        feh
        i3blocks
        i3lock-pixeled
        i3status
        i3status-rust
        rofi
        termite
        xkblayout-state
      ];
    };
  };

  system.stateVersion = "19.09"; # Did you read the comment?
}
