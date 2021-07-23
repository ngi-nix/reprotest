# reprotest

- upsteam: https://salsa.debian.org/reproducible-builds/reprotest
- ngi-nix: https://github.com/ngi-nix/ngi/issues/83

reprotest is a python application, which is meant to run build processes in separated environments, like LXC or chroot. It uses libfaketime and disorderfs to switch up the conditions between runs and compares the outputs to verify reproduciblity even under varying conditions.

## Using

In order to use this [flake](https://nixos.wiki/wiki/Flakes) you need to have the 
[Nix](https://nixos.org/) package manager installed on your system. Then you can simply run this 
with:

```
$ nix run github:ngi-nix/reprotest
```

You can also enter a development shell with:

```
$ nix develop github:ngi-nix/reprotest
```

For information on how to automate this process, please take a look at [direnv](https://direnv.net/).
