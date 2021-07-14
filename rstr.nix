{ python3Packages
, lib
}:

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

  meta = with lib; {
    homepage = "https://pypi.org/project/rstr/";
    description = "Generate random strings in Python";
    license = licenses.unfree; # idk which bsd it is
    platforms = platforms.unix;
    maintainers = with maintainers; [ magic_rb ];
  };
}
