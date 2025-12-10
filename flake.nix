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
              (python3.withPackages
                (ps: [
                  ps.matplotlib
                  ps.numpy
                ]))
            ];
          }
    );
    packages = forAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        slides = pkgs.stdenv.mkDerivation {
          name = "slides";
          src = ./.;
          buildInputs = [
            pkgs.typst
            pkgs.public-sans
          ];
          FONTCONFIG_FILE = pkgs.makeFontsConf {
            fontDirectories = [
              pkgs.public-sans
            ];
          };
          buildPhase = ''
            runHook preBuild
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
