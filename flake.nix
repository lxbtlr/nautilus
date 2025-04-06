{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    devShells = forEachSupportedSystem ({pkgs}: {
      default =
        {
        packages = with pkgs;
            [
              (pkgs.python311.withPackages (ps: [
                ps.jsonschema
                ps.numpy
                ps.matplotlib
                ps.pandas
              ]))
              gcc
              gtkwave
              iverilog
              cmake
              codespell
              conan
              cppcheck
              doxygen
              gtest
              lcov
              vcpkg
              vcpkg-tool
              grub2
              xorriso
              ubootTools
              binutils
            ]
            ++ (
              if system == "aarch64-darwin"
              then []
              else [gdb]
            );
        };

      #buildInputs = [pkgs.clang-tools];
      #shellHook = ''
      #  PATH="${pkgs.clang-tools}/bin:$PATH"
      #'';
    });
  };
}
