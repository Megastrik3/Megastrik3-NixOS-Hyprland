{ config, pkgs, pkgs-cuda, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "hudsonb";
  home.homeDirectory = "/home/hudsonb";


  home.packages = with pkgs; [
    fortune
    cowsay
    obs-studio
    audacity     
    zoom-us 
    antigravity
    openjdk17
    aapt
    usbutils
    czkawka
    neovim
    zotero
    termius
    obsidian
    darktable
    davinci-resolve
    handbrake
    vscode
    pear-desktop
    gimp
    prismlauncher
    bitwarden-desktop
    r2modman
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
      nix-mode
      magit
    ];

  };

}