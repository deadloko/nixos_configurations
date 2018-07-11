# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [];
  boot.kernelParams = [ "acpi_rev_override=1" "nouveau.modeset=0" ];

  boot.supportedFilesystems = [ "zfs" ];

  fileSystems."/" =
    {
      device = "zroot/nixos";
      fsType = "zfs";
    };

  fileSystems."/home" =
    {
      device = "zroot/home";
      fsType = "zfs";
    };

  fileSystems."/efi" =
    {
      device = "/dev/disk/by-uuid/303C-43EF";
      fsType = "vfat";
    };

  fileSystems."/var/lib/docker" =
    {
      device = "zroot/docker";
      fsType = "zfs";
    };

  boot.loader.efi.efiSysMountPoint = "/efi";

  swapDevices = [];

  services.zfs.autoSnapshot = {
    enable = true;
    flags = "-k -p --utc";
    frequent = 8; # Every 15 minutes.
    daily = 1;
    hourly = 4;
    weekly = 7;
    monthly = 1;
  };

  services.zfs.autoScrub = {
    enable = true;
    interval = "daily";
  };

  services.zfs.trim = {
    enable = true;
    interval = "daily";
  };

  nix.maxJobs = lib.mkDefault 8;

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
  hardware.bluetooth.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # High-DPI console
  i18n.consoleFont = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  networking.interfaces.wlp2s0.useDHCP = true;
  networking.hostId = "bc23ff1c";
}