# slskd-api-flake

A Nix flake that provides [slskd-api](https://pypi.org/project/slskd_api/) (`slskd_api`), a Python client for [slskd](https://github.com/slskd-user/slskd), the Soulseek daemon — built from the project's PyPI source distribution.

## Outputs

- `packages.<system>.slskd-api` — the slskd-api package. The PyPI distribution name is `slskd_api` with an underscore; the Nix attribute name follows the dash convention, and the importable module is `slskd_api`.
- `packages.<system>.default` — the same derivation.
- `packages.<system>.update-version`, `packages.<system>.update-branches` — maintenance outputs that move the pin. Neither is needed to consume the flake.
- `checks.<system>.formatting`, `formatter` — this repository's own files.

There are no overlays, `nixosModules`, devShells or apps: nothing here installs a service.

## Consuming

```nix
# flake inputs
inputs.slskd-api = {
  url = "github:jgus-org/slskd-api-flake";
  inputs.nixpkgs.follows = "nixpkgs";
};

# then, as a member of a python environment
inputs.slskd-api.packages.${system}.slskd-api
```

Following `nixpkgs` is what makes the package usable next to other python code: the derivation is built against that nixpkgs' default CPython and its `requests`, so sharing the nixpkgs puts slskd-api in the same interpreter's package set. Upstream declares `requires-python >= 3.11`. A consumer that follows a nixpkgs whose default `python3` is outside that range is on its own to reconcile.

## Build hosts

`aarch64-darwin`, `aarch64-linux` and `x86_64-linux`, which are flake-lib's default build hosts. slskd-api is pure Python and its one runtime dependency is nixpkgs' own `requests`, so there is nothing compiled in this closure that nixpkgs does not already build.

## What you get

**The version upstream releases, unpatched.** The pin tracks PyPI and the recipe applies no patches. 0.2.4, released 2026-04-10, is the newest release on PyPI.

**A build that cannot drift from the pin.** Upstream's `setup.py` resolves its version through `setuptools-git-versioning` rather than stating one, so the recipe names that plugin in the build system; nixpkgs' metadata check then requires the built wheel to declare exactly the version the pin records, and a mismatch fails the build rather than shipping quietly.

**A check that survives the fleet's test default.** The build verifies the `slskd_api` module imports. Upstream ships a test directory in the sdist, but nixpkgs removes test trees from installed packages and the fleet does not inherit upstream suites on a bump, so no upstream test runs here.
