with import <nixpkgs> {};
{
  environment = stdenvNoCC.mkDerivation {
    name = "latex_environment";
    buildInputs = [
      pkgs.texlive.combined.scheme-full
      pkgs.texstudio
    ];
  };
}
