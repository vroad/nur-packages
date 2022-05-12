{ lib, stdenv, fetchFromGitHub, kernel }:
let
  kdir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
in
stdenv.mkDerivation rec {
  pname = "looking-glass-module";
  version = "0a768a5a7fa12529469c2c6522de56fb70939a6d";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "LookingGlass";
    rev = version;
    sha256 = "sha256-r9FOWMxWZNWpZszCnRppt00hL8D8kOEa1FXpRK3K/t8=";
  };
  sourceRoot = "source/module";

  makeFlags = with kernel; [
    "KDIR=${kdir}"
  ];
  hardeningDisable = [ "pic" "format" ];
  installPhase = ''
    INSTALL_MOD_PATH="$out" make -C "${kdir}" "M=$PWD" modules_install
  '';

  meta = with lib; {
    description = "A kernel module which implements a basic interface to the IVSHMEM device for LookingGlass";
    homepage = "https://looking-glass.io/";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
  };
}
