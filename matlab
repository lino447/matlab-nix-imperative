#!/bin/sh

CAN_LIB_DIR=$(
    find /nix/store -name libcanlib.so -exec dirname {} \; | sort | tail -n 1)
if [ -n "$CAN_LIB_DIR" ]; then
    export LD_LIBRARY_PATH=$CAN_LIB_DIR:$LD_LIBRARY_PATH
fi

default_version=2023a
default_dir() {
    version="$1"
    echo "$HOME/MATLAB/R$version"
}

paren_args() {
    for a in "$@"; do
        echo "'$a'"
    done
}


if [ -z "$MATLAB_DIR" ]; then
    test "$MATLAB_VERSION" || MATLAB_VERSION="$default_version"
    MATLAB_DIR="$(default_dir "$MATLAB_VERSION")"
fi

nix_dir="$(dirname "$(readlink -f "$0")")"

desktop=-desktop
for a in "$@"; do
    test "$a" = "-nodesktop" && desktop=''
done


runScript="$MATLAB_DIR/bin/matlab $desktop $(paren_args "$@")"
exec nix-shell --argstr runScript "$runScript" "$nix_dir"/matlab.nix
