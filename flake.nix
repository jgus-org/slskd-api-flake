{
  description = "slskd-api: a Python client for slskd, the Soulseek daemon";

  inputs = {
    flake-lib = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:jgus-org/flake-lib/v1";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      flake-lib,
      nixpkgs,
    }:
    let
      packages =
        {
          buildPackage,
          pkgs,
          python,
          ...
        }:
        {
          slskd-api = buildPackage {
            build-system = with python; [
              setuptools
              setuptools-git-versioning
            ];
            dependencies = [ python.requests ];
            meta = {
              description = "API wrapper to interact with slskd, the Soulseek daemon.";
              license = pkgs.lib.licenses.agpl3Only;
            };
            pname = "slskd-api";
            pyproject = true;
            pythonImportsCheck = [ "slskd_api" ];
          };
        };
    in
    flake-lib.lib.mkPythonFlake {
      inherit nixpkgs self;
      payload.overlays = packages;
      # PyPI carries the 0.1.x sdists under the hyphenated distribution name (slskd-api-0.1.5.tar.gz); the underscore name pinned below exists only from 0.2.0, so versions under this floor can never be fetched or branched.
      updateBranches.minimumTrackingVersion = "0.2.0";
      upstream = {
        pin = import ./pin.nix;
        # The PyPI distribution name uses an underscore; the Nix attribute name follows the dash convention.
        pname = "slskd_api";
        type = "pypi";
      };
    };
}
