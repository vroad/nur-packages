{ ... }:
let
  sources = import ./nix/sources.nix;
  unstablePkgs = import sources.nixpkgs-unstable { };
in
{
  modules = import ./modules; # NixOS modules

  looking-glass-client =
    unstablePkgs.looking-glass-client.overrideAttrs (oldAttrs: rec {
      version = "3df7d30cd5b551b23e41781313cef389239e27bc";
      src = unstablePkgs.fetchFromGitHub {
        owner = "gnif";
        repo = "LookingGlass";
        rev = version;
        sha256 = "sha256-UzZQU5SzJ2mo9QBweQB0VJSnKfzgTG5QaKpIQN/6LCE=";
        fetchSubmodules = true;
      };
    });
}
