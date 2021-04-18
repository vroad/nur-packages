{ stdenv
, fetchurl
, autoPatchelfHook
, glib
, libxml2
, zlib
}:
let
  sourceFile = builtins.fromJSON (builtins.readFile ./clang-src.json);
  path = "third_party/llvm-build/Release+Asserts";
in
stdenv.mkDerivation rec {
  name = "angle-clang";
  src = fetchurl sourceFile;
  unpackPhase = ":";
  installPhase = ''
    mkdir -p "$out/${path}"
    mkdir -p ${path} && tar -xf ${src} -C "$out/${path}"
  '';
  nativeBuildInputs = [ autoPatchelfHook glib libxml2 zlib ];
}
