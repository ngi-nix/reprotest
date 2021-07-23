{ fetchFromGitLab
, python3Packages
, callPackage
, lib

, diffoscope
, disorderfs 
, libfaketime
, debianutils # schroot
, qemu
}:

with python3Packages;

let
  version = "0.7.16";
in
buildPythonApplication {
  pname = "reprotest";
  inherit version;

  propagatedBuildInputs = (builtins.filter (x: x != null)
    [ diffoscope disorderfs libfaketime debianutils qemu ])
  ++ [ distro libarchive-c python_magic setuptools
       (callPackage ./rstr.nix {})
     ];

  patches = [ ./patches/0001-Add-NixOS-system-interface.patch ]; 

  postFixup = ''
    wrapPythonProgramsIn $out/lib/python?.?/site-packages/reprotest/virt/ "$out $pythonPath"
  '';

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "reproducible-builds";
    repo = "reprotest";
    rev = version;
    sha256 = "sha256-ibdjBzIUfiBLa9ELXT6N6b1KBNZh6Y694Q0ZNHv072g=";
  };

  meta = with lib; {
    homepage = "https://salsa.debian.org/reproducible-builds/reprotest";
    description = "Reprotest builds the same source code twice in different environments, and then checks the binaries produced by each build for differences.";
    license = licenses.unfree; # license unspeficied
    platforms = platforms.unix;
    maintainers = with maintainers; [ magic_rb ];
  };
}
