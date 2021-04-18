{ callPackage
, symlinkJoin
, stdenv
, autoPatchelfHook
, depot-tools
, glib
, gn
, pkg-config
, python
, glibc
, pciutils
, libX11
, libXext
, libxcb
, xorgproto
, libgcc
, libXi
, libglvnd
}:
let
  deps = callPackage ./gclient-deps.nix { };
  angleClang = callPackage ./clang.nix { };
  src = symlinkJoin {
    name = "angle-src";
    paths = deps ++ [ angleClang ];
  };
  sysRootPaths = [
    libxcb
    libxcb.dev
    libgcc
    glibc
    glibc.dev
    pciutils
    libX11
    libX11.dev
    libXext
    libXext.dev
    libXi
    xorgproto
    libglvnd
    libglvnd.dev
  ];
  sysroot = symlinkJoin {
    name = "angle-sysroot";
    paths = sysRootPaths;
  };
in
stdenv.mkDerivation {
  name = "angle";
  inherit src;
  buildInputs = [
    libxcb
    libX11
    libXext
  ];
  nativeBuildInputs = [ autoPatchelfHook depot-tools glib gn pkg-config python ];
  preConfigure = ''
    touch build/config/gclient_args.gni
  '';
  gnFlags = ''
    sysroot = "${sysroot}"
    is_debug = false
  '';
  buildPhase = ''
    autoninja libEGL libGLESv2
  '';
  outputs = [ "out" "dev" ];
  installPhase = ''
    mkdir -p "$out/lib"
    mkdir -p "$dev/include"
    mv libEGL.so libGLESv2.so "$out/lib/"
    cp -r "$src/include/." "$dev/include/"
  '';
}
