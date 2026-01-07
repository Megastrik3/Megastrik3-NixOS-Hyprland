# 💫 https://github.com/JaKooLit 💫 #
# Users - NOTE: Packages defined on this will be on current user only

{ pkgs, username, pkgs-cuda, ... }:

let
  inherit (import ./variables.nix) gitUsername;
  hyprlandScripts = import ./scripts { inherit pkgs; };
  hyprlandUserScripts = import ./userscripts { inherit pkgs; };
in
{
  users = { 
    mutableUsers = true;
    users."${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "video" 
        "input" 
        "audio"
        "adbusers" 
      ];

    # define user packages here
    packages = (with pkgs; [
      vscode
      youtube-music
      gimp
      prismlauncher
      bitwarden-desktop
      #vesktop
      zotero
      termius
      obsidian
      darktable
      pkgs-cuda.davinci-resolve
      handbrake
      r2modman
      obs-studio
      audacity     
      zoom-us 
      antigravity
      openjdk17
      aapt
      usbutils
      czkawka

    ]) ++ hyprlandScripts ++ hyprlandUserScripts;
    };
    
    defaultUserShell = pkgs.zsh;
  }; 
  
  environment.shells = with pkgs; [ zsh ];
  environment.systemPackages = with pkgs; [ lsd fzf ]; 
    
  programs = {
  # Zsh configuration
    zsh = {
      enable = true;
      enableCompletion = true;
      ohMyZsh = {
        enable = true;
        plugins = ["git"];
        theme = "agnoster"; 
        };
      
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      
      promptInit = ''
        fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc
        
        alias ls='lsd'
        alias l='ls -l'
        alias la='ls -a'
        alias lla='ls -la'
        alias lt='ls --tree'

        source <(fzf --zsh);
        HISTFILE=~/.zsh_history;
        HISTSIZE=10000;
        SAVEHIST=10000;
        setopt appendhistory;
        '';
      };
   };
}