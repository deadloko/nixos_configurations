{ stdenv, fetchzip }:

let
  version = "2.1.0";
in
fetchzip rec {
  name = "terminus-nerd-font-ttf-${version}";
  url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/Terminus.zip";

  postFetch = ''
    unzip $downloadedFile
    mkdir -p "$out/share/fonts/truetype/$destname/terminus_nerd"
    cp -v ./*.ttf "$out/share/fonts/truetype/$destname/terminus_nerd"
  '';

  sha256 = "1jfvvvchc972ysjccc5wqaq334bpfqsxd0qkykwmn66gh2llcm3h";

  meta = with stdenv.lib; {
    description = "A clean fixed width TTF font";
    longDescription = ''
      Monospaced bitmap font
    '';
    homepage = https://github.com/ryanoasis/nerd-fonts;
    license = licenses.ofl;
    maintainers = with maintainers; [ deadloko ];
    platforms = platforms.unix;
  };
}
