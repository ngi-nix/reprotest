# reprotest

- upsteam: https://salsa.debian.org/reproducible-builds/reprotest
- ngi-nix: https://github.com/ngi-nix/ngi/issues/83

reprotest is a python application, which is meant to run build processes in separated environments, like LXC or chroot. It uses libfaketime and disorderfs to switch up the conditions between runs and compares the outputs to verify reproduciblity even under varying conditions.
