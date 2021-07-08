{ fetchFromGitLab
, python3Packages
, callPackage

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
}
