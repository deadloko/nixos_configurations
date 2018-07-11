with import <nixpkgs> {};
let
  customGhc = ghc.withHoogle (
    ps: with ps; [
      cabal-install
      doctest
      Glob
      stack
      hdevtools
      hlint
      hspec
    ]
  );
  all-hies = import (
    fetchTarball
      "https://github.com/infinisil/all-hies/tarball/master"
  ) {};
  vscode_for_haskell = pkgs.vscode-with-extensions.override {
    vscodeExtensions = (
      with pkgs.vscode-extensions; [
        alanz.vscode-hie-server
        bbenoist.Nix
        justusadam.language-haskell
      ]
    );
  };
in
{
  environment = stdenvNoCC.mkDerivation {
    name = "dev_environment";
    buildInputs = [
      (all-hies.selection { selector = p: { inherit (p) ghc865; }; })
      customGhc
      vscode_for_haskell
    ];
  };
}
