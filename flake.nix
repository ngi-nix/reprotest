{
  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { nixpkgs, self }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems' = systems: fun: nixpkgs.lib.genAttrs systems fun;
      forAllSystems = forAllSystems' supportedSystems;
    in
      with nixpkgs.lib;
    {
      overlays.reprotest = final: prev:
        {
          reprotest = prev.callPackage ./reprotest.nix {};
          reprotestMinimal = final.reprotest.override
            { diffoscope = null;
              disorderfs = null;
              libfaketime = null;
              debianutils = null;
              qemu = null;
            };
        };

      overlay = self.overlays.reprotest;

      defaultPackage = forAllSystems (system:
        let
          pkgs = import nixpkgs
            { inherit system;
              overlays = [ self.overlays.reprotest ];
              config.allowUnfree = true;
            };
        in
          pkgs.reprotest
      );

      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs
            { inherit system;
              overlays = [ self.overlays.reprotest ];
              config.allowUnfree = true;
            };
        in
          { inherit (pkgs) reprotest reprotestMinimal;
          }
      );

      devShell = forAllSystems (system:
        let
          pkgs = import nixpkgs
            { inherit system;
              overlays = [ self.overlays.reprotest ];
              config.allowUnfree = true;
            };
        in
          pkgs.mkShell {
            nativeBuildInputs = with pkgs;
              [ diffoscope disorderfs debianutils qemu
                python3
              ];
            buildInputs = with pkgs;
              [ libfaketime
              ] ++
              (with python3Packages;
                [ distro libarchive-c python_magic setuptools
                  (pkgs.callPackage ./rstr.nix {})
                ]);
          }
      );
    };
}
