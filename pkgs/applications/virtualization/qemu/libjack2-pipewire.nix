{ stdenv
, libjack2
, pipewire
}:

stdenv.mkDerivation {
  pname = "pipewire-jack-dev";
  version = libjack2.version;
  nativeBuildInputs = [ xorg.lndir ];

  dontUnpack = true;
  installPhase = ''
    cp -r ${libjack2}/ $out/
    chmod 644 $out/lib/*.so
    chmod 755 $out/lib
    rm $out/lib/*.so*
    cp ${pipewire.jack}/lib/*.so* $out/lib/
  '';
}
