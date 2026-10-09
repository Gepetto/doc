{
  description = "Merged doxygen output from our projects and their dependencies";

  inputs.gepetto.url = "github:gepetto/nix";

  outputs =
    inputs:
    inputs.gepetto.lib.mkFlakoboros inputs (
      { ... }:
      let
        inherit (inputs.gepetto.inputs.flakoboros.lib) tmpOverride;
      in
      {
        packages = {
          gepetto-doc = ./package.nix;
          crocoddyl-doc =
            { crocoddyl, fetchFromGitHub }:
            (tmpOverride crocoddyl "3.2.1").overrideAttrs {
              src = fetchFromGitHub {
                inherit (crocoddyl.src) owner repo;
                # https://github.com/loco-3d/crocoddyl/pull/1536 doxygen merge commit
                rev = "be2c718";
                hash = "sha256-LNScCJdyoFICFm12neOLDsSwsgxxyKDEwNqbr/YsuDA=";
              };
              doCheck = false;
            };
          proxsuite-doc =
            { proxsuite, fetchFromGitHub }:
            (tmpOverride proxsuite "0.7.3").overrideAttrs {
              src = fetchFromGitHub {
                inherit (proxsuite.src) owner repo;
                # https://github.com/Simple-Robotics/proxsuite/pull/467 mathjax merge commit
                rev = "d099626";
                hash = "sha256-2iErphdVUy+O389Y6vBfuDmiyIt+qBLdierTZ33eJW0=";
              };
              doCheck = false;
            };
        };
      }
    );
}
