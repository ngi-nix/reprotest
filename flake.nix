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
    {
      overlays.reprotest = final: prev:
        {
          reprotest = prev.callPackage ./reprotest.nix {};
          reprotestMinimal = final.override
            { diffoscope = null;
              disorderfs = null;
              libfaketime = null;
              debianutils = null;
              qemu = null;
            };
        };

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
    };
}
