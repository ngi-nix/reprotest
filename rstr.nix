{ python3Packages }:

with python3Packages;

let
  version = "2.2.6";
  pname = "rstr";
in
buildPythonPackage {
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XeqCIybkGODJgWyc0Urpx74tTNQzQEPDl/ICvCri7aQ=";
  };
}
