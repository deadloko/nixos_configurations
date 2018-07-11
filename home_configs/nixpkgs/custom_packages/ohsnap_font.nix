{ stdenv, fetchzip }:

let
  version = "0.1";
in
fetchzip rec {
  name = "ohsnap-font-ttf-${version}";
  url = "https://github.com/deadloko/ohsnap/archive/v0.1.zip";

  postFetch = ''
    unzip $downloadedFile
    mkdir -p "$out/share/fonts/truetype/$destname"
    cp -r "ohsnap-${version}" "$out/share/fonts/truetype/$destname"
  '';

  sha256 = "158p1bi9bsiw0i1s25gzl7xnsffpvdzz59il6hxw9n5fcjj3wlj4";

  meta = with stdenv.lib; {
    description = "A clean fixed width TTF font";
    longDescription = ''
      Monospaced bitmap font
    '';
    homepage = https://github.com/deadloko/ohsnap;
    license = licenses.ofl;
    maintainers = with maintainers; [ deadloko ];
    platforms = platforms.unix;
  };
}
