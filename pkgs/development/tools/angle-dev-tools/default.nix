{ stdenv
, lib
, python3
, makeWrapper
}:
stdenv.mkDerivation rec {
  name = "angle-dev-tools";
  nativeBuildInputs = [ makeWrapper ];
  src = ./src;
  unpackPhase = ":";
  installPhase = ''
    mkdir -p $out/bin/
    cp -r ${src}/. $out/bin/
    wrapProgram $out/bin/extract-angle-deps \
      --prefix PATH : ${lib.makeBinPath [ python3 ]}
  '';
}
