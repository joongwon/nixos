{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "freleefty-nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Seoul";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod = {
    enable = true;
    type = "uim";
    uim.toolbar = "gtk-systray";
  };

  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.xkb = {
    layout = "kr-hangul-hanja";
    extraLayouts.kr-hangul-hanja = {
      description = "KR layout with ralt-hangul rctrl-hanja";
      languages = [ "kor" ];
      symbolsFile = ./symbols/kr-hangul-hanja;
    };
  };


  # pipewire should be disabled to use pulseaudio
  services.pipewire.enable = false;

  hardware.nvidia.open = true;
  hardware.graphics.enable = true;
  hardware.pulseaudio.enable = true;
  # TODO: https://nixos.wiki/wiki/Power_Management

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  users.users.joongwon = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" ];
    packages = with pkgs; [];
  };

  programs.firefox = {
    enable = true;
    preferences = {
      "media.ffmpeg.vaapi.enabled" = true;
    };
  };

  environment.systemPackages = with pkgs; [
    ((vim_configurable.override { }).customize {
      name = "vim";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [
          vim-airline
          nerdtree
          fzf-vim
        ];
        opt = [];
      };
      vimrcConfig.customRC = builtins.readFile ./vimrc;
    })
    pulseaudio
    i3status
    git
    xsel
    wineWowPackages.stable
    winetricks
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    nanum
  ];

  environment.variables = { EDITOR = "vim"; };

  # Not supported by flake.nix
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}

