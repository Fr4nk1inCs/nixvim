{
  description = "Fr4nk1in's NixVim Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-utils.url = "github:numtide/flake-utils";
    git-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs = {
    self,
    nixpkgs,
    nixvim,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};

        minimal = nixvim'.makeNixvimWithModule {
          inherit pkgs;
          module = import ./package.nix {isMinimal = true;};
        };

        full = nixvim'.makeNixvimWithModule {
          inherit pkgs;
          module = import ./package.nix {isMinimal = false;};
        };

        fullWsl = nixvim'.makeNixvimWithModule {
          inherit pkgs;
          module = import ./package.nix {
            isMinimal = false;
            isWsl = true;
          };
        };
      in {
        checks = {
          default = nixvimLib.check.mkTestDerivationFromNixvimModule {
            inherit pkgs;
            module = import ./package.nix {};
          };
          preCommit = inputs.git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              alejandra.enable = true;
              statix.enable = true;
              deadnix.enable = true;
              commitizen.enable = true;
            };
          };
        };

        packages = {
          default = full;
          inherit minimal full fullWsl;
        };

        devShells.default = pkgs.mkShell {
          inherit (self.checks.${system}.preCommit) shellHook;
          buildInputs = self.checks.${system}.preCommit.enabledPackages;
        };
      }
    );
}
