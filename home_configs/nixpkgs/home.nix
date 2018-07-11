{ pkgs, lib, ... }:

let
  sysconfig = (import <nixpkgs/nixos> {}).config;
  ohsnap_font = pkgs.callPackage ./custom_packages/ohsnap_font.nix {};
  terminus_nerd_font = pkgs.callPackage ./custom_packages/terminus_nerd.nix {};
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [
    ohsnap_font
    pkgs.fbreader
    pkgs.gnupg
    pkgs.gomuks
    pkgs.spotify
    pkgs.weechat
    pkgs.zathura
    terminus_nerd_font
  ];

  home.file = {
    ".config/i3/config".text = import dots/i3_config.nix;

    ".config/i3/status.toml" =
      if (sysconfig.networking.hostName == "death-nixos-dellxps15")
      then { text = import dots/i3_status_bar_dell.nix; }
      else { text = import dots/i3_status_bar.nix; };

    ".config/i3/background".source = ./dots/wallpaper.png;
    ".config/termite/config".text = import dots/termite_config.nix;
    ".Xdefaults".text = import dots/xdefaults.nix;
    ".config/pianobar/config".text = import dots/pianobar.nix;
  };

  programs.git = {
    enable = true;
    userName = "Andrew Newman";
    userEmail = "deadloko@gmail.com";
    signing = lib.mkIf (sysconfig.networking.hostName == "death-nixos-dellxps15") {
      key = "1A35098B6F71E53BC56A343C49B10A5FCFD7F240";
      signByDefault = true;
    };

    # Disable graphical password prompt.
    extraConfig = {
      core = {
        askpass = "";
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    extraConfig = ''
      pinentry-timeout 0
      pinentry-program ${pkgs.pinentry}/bin/pinentry
    '';
  };

  programs.firefox = {
    enable = true;
    profiles = {
      "deadloko" = {
        isDefault = true;
        settings = {
          "network.proxy.ftp" = "127.0.0.1";
          "network.proxy.ftp_port" = 8118;
          "network.proxy.http" = "127.0.0.1";
          "network.proxy.http_port" = 8118;
          "network.proxy.share_proxy_settings" = true;
          "network.proxy.socks" = "127.0.0.1";
          "network.proxy.socks_port" = 8118;
          "network.proxy.ssl" = "127.0.0.1";
          "network.proxy.ssl_port" = 8118;
          "network.proxy.type" = 1;
        };
      };
    };
  };

  programs.neovim = {
    enable = true;

    extraConfig = ''
      set nocompatible
      set termguicolors
      colorscheme monokai_pro

      set nu
      set colorcolumn=80
      set statusline+=%#warningmsg#
      set statusline+=%{SyntasticStatuslineFlag()}
      set statusline+=%*
      set inccommand=split

      let g:deoplete#enable_at_startup = 1
      let g:airline_powerline_fonts = 1

      let g:ale_fixers = {'nix': ['nixpkgs-fmt']}

      nnoremap <c-n> :NERDTreeToggle<CR>
      nnoremap <c-l> :call LanguageClient_contextMenu()<CR>
    '';

    plugins =
      with pkgs.vimPlugins; [
        LanguageClient-neovim
        airline
        ale
        deoplete-nvim
        fugitive
        fzf-vim
        nerdcommenter
        nerdtree
        nerdtree-git-plugin
        vim-addon-nix
        vim-markdown
        vim-monokai-pro
        vim-nix
      ];

    vimAlias = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    oh-my-zsh = {
      plugins = [
        "git"
        "sudo"
        "docker"
      ];

      enable = true;
      theme = "agnoster";
    };
  };
}
