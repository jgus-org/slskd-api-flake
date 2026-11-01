{
  description = "slskd-api: a Python client for slskd, the Soulseek daemon";

  inputs = {
    # Unfollowed on purpose: flake-lib resolves the org formatter from its own nixpkgs pin.
    flake-lib.url = "github:jgus-org/flake-lib/v1";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      flake-lib,
      nixpkgs,
    }:
    flake-lib.lib.mkPythonFlake {
      inherit nixpkgs self;
      payload.packages =
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
              license = pkgs.lib.licenses.agpl3Plus;
            };
            pname = "slskd-api";
            pyproject = true;
            pythonImportsCheck = [ "slskd_api" ];
          };
        };
      upstream = {
        pin = import ./pin.nix;
        # The PyPI distribution name uses an underscore; the Nix attribute name follows the dash convention.
        pname = "slskd_api";
        type = "pypi";
      };
    };
}
