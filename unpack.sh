#!/bin/bash

RECURSIVE=0
VERBOSE=0
DRYRUN=0

# simple usage help function
usage() {
    echo "usage: $0 [-rvhn] files..." >&2
    echo >&2
    echo "    -h    Display this help" >&2
    echo "    -r    Recurse directories" >&2
    echo "    -v    Be verbose" >&2
    echo "    -n    Dry-run" >&2 # just used for debugging
}

# unpacking compressed files function
do_unpack() {
    ext=${1##*.}

    cmd=
    case $ext in
    zip)
        cmd=unzip
        ;;
    gz)
        cmd=gunzip
        ;;
    bz2)
        cmd=bunzip2
        ;;
    esac

    if [ -z $cmd ]; then return; fi

    # just used for debugging
    if [ $DRYRUN -eq 1 ]; then
        cmd="echo $cmd"
    fi

    if [ $VERBOSE -eq 1 ]; then
        echo "Unpacking $1..."
    fi

    $cmd $1
}

# inserting recived flags into an array
args=$(getopt -o rvhn -- "$@")

if [ $? -ne 0 ]; then
    usage
    exit 2
fi

eval "set -- $args"

# flags cases loop
while true; do
    case $1 in
    -r)
        RECURSIVE=1
        shift
        ;;
    -v)
        VERBOSE=1
        shift
        ;;
    -h)
        usage
        exit 0
        ;;
    -n)
        DRYRUN=1
        shift
        ;;
    --)
        shift
        break
        ;;
    esac
done

for file in "$@"; do
    do_unpack $file
done
