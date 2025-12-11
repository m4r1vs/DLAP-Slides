{
  description = "Flake for Typst Slides";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
  };
  outputs = {nixpkgs, ...}: let
    lib = nixpkgs.lib;
    supportedSystems = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
      "riscv64-linux"
      "aarch64-darwin"
    ];
    forAllSystems = lib.genAttrs supportedSystems;
  in {
    devShell = forAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
        with pkgs;
          mkShell {
            FONTCONFIG_FILE = makeFontsConf {
              fontDirectories = [
                public-sans
              ];
            };
            buildInputs = [
              typst
              typstyle
              tinymist
              python3
              cairo
              pkg-config
            ];
            shellHook = ''
              set -o pipefail
              unset SOURCE_DATE_EPOCH # set by nix to 1 to allow reproducible builds over time. We don't want that (for datetime.now in typst)
              if [ ! -d .env ]; then
                python -m venv .env
                source ./.env/bin/activate
                pip install -U pip
                pip install -e .
                echo "Python virtual environment created and activated."
              else
                source ./.env/bin/activate
              fi
            '';
          }
    );
    packages = forAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
        with pkgs; {
          slides = stdenv.mkDerivation {
            name = "slides";
            src = ./.;
            buildInputs = [
              typst
              public-sans
              (python3.withPackages (ps: [
                ps.matplotlib
                ps.numpy
              ]))
            ];
            FONTCONFIG_FILE = makeFontsConf {
              fontDirectories = [
                public-sans
              ];
            };
            buildPhase = ''
              runHook preBuild
              python training_loss_graph.py
              typst compile ./slides.typ -f pdf
              runHook postBuild
            '';
            installPhase = ''
              runHook preInstall
              mkdir -p $out
              cp ./slides.pdf $out/slides.pdf
              runHook postInstall
            '';
          };
        }
    );
  };
}
