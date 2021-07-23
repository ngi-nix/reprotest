# reprotest

- upsteam: https://salsa.debian.org/reproducible-builds/reprotest
- ngi-nix: https://github.com/ngi-nix/ngi/issues/83

reprotest is a python application, which is meant to run build processes in separated environments, like LXC or chroot. It uses libfaketime and disorderfs to switch up the conditions between runs and compares the outputs to verify reproduciblity even under varying conditions.

## Using

> :warning: Unfornutaly this program is currently **segfaulting**, it's been tested with the null builder only.

```
WARNING:reprotest.build:IGNORING user_group variation; supply more usergroups with --variations=user_group.available+=USER1:GROUP1;USER2:GROUP2 or alternatively, suppress this warning with --variations=-user_group
WARNING:reprotest.build:Not using sudo for domain_host; your build may fail. See man page for other options.
WARNING:reprotest.build:Be sure to `echo 1 > /proc/sys/kernel/unprivileged_userns_clone` if on a Debian system.
Caught Segmentation fault
Traceback (most recent call last):
  File "/nix/store/wh98khrzvf46qvn63qs2v3vkyhsxhvz5-reprotest-0.7.16/lib/python3.8/site-packages/reprotest/__init__.py", line 844, in run
    return 0 if check_func(*check_args) else 1
  File "/nix/store/wh98khrzvf46qvn63qs2v3vkyhsxhvz5-reprotest-0.7.16/lib/python3.8/site-packages/reprotest/__init__.py", line 369, in check
    local_dists += [proc.send(nv) for nv in zip(bnames[1:], build_variations[1:])]
  File "/nix/store/wh98khrzvf46qvn63qs2v3vkyhsxhvz5-reprotest-0.7.16/lib/python3.8/site-packages/reprotest/__init__.py", line 369, in <listcomp>
    local_dists += [proc.send(nv) for nv in zip(bnames[1:], build_variations[1:])]
  File "/nix/store/wh98khrzvf46qvn63qs2v3vkyhsxhvz5-reprotest-0.7.16/lib/python3.8/site-packages/reprotest/__init__.py", line 329, in corun_builds
    bctx.run_build(testbed, build, os.environ, artifact_pattern, testbed_build_pre, no_clean_on_error)
  File "/nix/store/wh98khrzvf46qvn63qs2v3vkyhsxhvz5-reprotest-0.7.16/lib/python3.8/site-packages/reprotest/__init__.py", line 218, in run_build
    testbed.check_exec2(build_argv,
  File "/nix/store/wh98khrzvf46qvn63qs2v3vkyhsxhvz5-reprotest-0.7.16/lib/python3.8/site-packages/reprotest/__init__.py", line 63, in check_exec2
    self.bomb('"%s" failed with status %i' % (' '.join(argv), code),
  File "/nix/store/wh98khrzvf46qvn63qs2v3vkyhsxhvz5-reprotest-0.7.16/lib/python3.8/site-packages/reprotest/__init__.py", line 70, in bomb
    raise _type(m)
reprotest.lib.adtlog.AutopkgtestError: "sh -ec run_build() {
    mkdir -p /tmp/nix-shell.f9sqZt/reprotest.bGNf11/build-experiment-1-aux && \
    SETARCH_ARCH=$(setarch --list | grep -vF "$(uname -m)" | shuf | head -n1) && \
    KERNEL_VERSION=$(uname -r) && \
    if [ ${KERNEL_VERSION#2.6} = $KERNEL_VERSION ]; then SETARCH_OPTS=--uname-2.6; fi && \
    CPU_MAX=$(nproc) && \
    CPU_MIN=$({ echo $CPU_MAX; echo 1; } | sort -n | head -n1) && \
    CPU_NUM=$(if [ $CPU_MIN = $CPU_MAX ];             then echo $CPU_MIN; echo >&2 "only 1 CPU is available; num_cpus is ineffective";             else shuf -i$((CPU_MIN + 1))-$CPU_MAX -n1; fi) && \
    mv /tmp/nix-shell.f9sqZt/reprotest.bGNf11/build-experiment-1/ /tmp/nix-shell.f9sqZt/reprotest.bGNf11/build-experiment-1-before-disorderfs/ && \
    mkdir -p /tmp/nix-shell.f9sqZt/reprotest.bGNf11/build-experiment-1/ && \
    disorderfs -q --shuffle-dirents=yes /tmp/nix-shell.f9sqZt/reprotest.bGNf11/build-experiment-1-before-disorderfs/ /tmp/nix-shell.f9sqZt/reprotest.bGNf11/build-experiment-1/ && \
    umask 0002 && \
    export REPROTEST_BUILD_PATH=/tmp/nix-shell.f9sqZt/reprotest.bGNf11/build-experiment-1/ && \
    export REPROTEST_UMASK=$(umask) && \
    unshare -r --uts sh -ec '
            hostname reprotest-capture-hostname
            domainname "reprotest-capture-domainname"
            "$@"' - \
    faketime +304days+17hours+25minutes \
    taskset -a -c $(echo $(shuf -i0-$((CPU_MAX - 1)) -n$CPU_NUM) | tr ' ' ,) \
    setarch $SETARCH_ARCH $SETARCH_OPTS \
    sh -ec 'cd "$REPROTEST_BUILD_PATH"; unset REPROTEST_BUILD_PATH; umask "$REPROTEST_UMASK"; unset REPROTEST_UMASK; make'
}

cleanup() {
    __c=0; \
    export PATH="/tmp/nix-shell.f9sqZt/reprotest.bGNf11/bin:$PATH" || __c=$?; \
    fusermount -u /tmp/nix-shell.f9sqZt/reprotest.bGNf11/build-experiment-1/ || __c=$?; \
    rmdir /tmp/nix-shell.f9sqZt/reprotest.bGNf11/build-experiment-1/ || __c=$?; \
    mv /tmp/nix-shell.f9sqZt/reprotest.bGNf11/build-experiment-1-before-disorderfs/ /tmp/nix-shell.f9sqZt/reprotest.bGNf11/build-experiment-1/ || __c=$?; \
    rm -rf /tmp/nix-shell.f9sqZt/reprotest.bGNf11/build-experiment-1-aux || __c=$?; \
    exit $__c
}

trap '( cleanup )' HUP INT QUIT ABRT TERM PIPE # FIXME doesn't quite work reliably yet

if ( run_build ); then ( cleanup ); else
    __x=$?; # save the exit code of run_build
    if ( ! false ); then
        if ( cleanup ); then :; else echo >&2 "cleanup failed with exit code $?"; fi;
    fi
    exit $__x
fi" failed with status 1
```

```
[168534.056373] taskset[119497]: segfault at 7f2000000000 ip 00007f203c3169ec sp 00007ffe7ff15c90 error 4 in ld-2.32.so[7f203c308000+20000]
```

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
