{
  description = "Lefthook setup";
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { 
          inherit system; 
          config.allowUnfree = true; # Required for latest Terraform..
        };
        lefthook-bin =  pkgs.symlinkJoin {
          name = "lefthook-env";
          paths = with pkgs; [
            actionlint
            golangci-lint
            gotest
            hadolint
            nodePackages.prettier
            shellcheck
            shfmt
            terraform
            tflint
            yamllint
          ];
          # symlinkJoin can't handle symlinked dirs and nodePackages,
          # thus symlink ./bin -> ./lib/node_modules/.bin/.
          postBuild = ''
            for f in $out/lib/node_modules/.bin/*; do
              path="$(readlink --canonicalize-missing "$f")"
              ln -s "$path" "$out/bin/$(basename $f)"
            done
          '';
        };
      in {
        packages = {
          default = lefthook-bin;
        };
      });
}
