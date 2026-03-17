{
  description = "Merged doxygen output from our projects and their dependencies";

  inputs = {
    gepetto.url = "github:gepetto/nix";
    gazebros2nix.follows = "gepetto/gazebros2nix";
    flake-parts.follows = "gepetto/flake-parts";
    nixpkgs.follows = "gepetto/nixpkgs";
    nix-ros-overlay.follows = "gepetto/nix-ros-overlay";
    systems.follows = "gepetto/systems";
    treefmt-nix.follows = "gepetto/treefmt-nix";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        systems = import inputs.systems;
        imports = [
          inputs.gepetto.flakeModule
          {
            gazebros2nix = {
              packages.gepetto-doc = ./.;
              # https://github.com/NixOS/nixpkgs/pull/455633/changes for minify -i
              overrides.minify =
                final:
                (super: rec {
                  version = "2.24.5";
                  src = final.fetchFromGitHub {
                    inherit (super.src) owner repo;
                    rev = "v${version}";
                    hash = "sha256-0OmL/HG4pt2iDha6NcQoUKWz2u9vsLH6QzYhHb+mTL0=";
                  };
                  vendorHash = "sha256-QS0vffGJaaDhXvc7ylJmFJ1s83kaIqFWsBXNWVozt1k=";
                });
            };
          }
        ];
      }
    );
}
