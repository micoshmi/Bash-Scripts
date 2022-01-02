#!/bin/bash

TIME=1
USER=
COUNT=-1

# giving a simple usage help
usage() {
  echo "usage: $0 [-h] [-c count] [-t time] [-u user] process" >&2
  echo >&2
  echo "	-c count  Number of times to ping (dafault is infinite)" >&2
  echo "	-t time   Time between pings (default: $TIME)" >&2
  echo "	-u user   Restrict to user (default all users)" >&2
  echo "	-h        Display this help" >&2
}

# parse the command line into $args
args=$(getopt -o hc:t:u: -- "$@")

# if getopt fails (i.e. unlisted arguments are used) print usage and exit with
# non-zero exit status
if [ $? -ne 0 ]; then
  usage
  exit 2
fi

# sets $args back to the commandline args
eval "set -- $args"

while true; do
  case $1 in
  -c)
    COUNT=$2
    shift
    shift
    ;;
  -t)
    TIME=$2
    shift
    shift
    ;;
  -u)
    USER=$2
    shift
    shift
    ;;
  -h)
    usage
    exit 0
    ;;
  --)
    shift
    break
    ;;
  esac
done

#  a placeholder for the user in the message below, set to all users
U="all users"

# if $USER is not empty, set it to that username in quotes
if ! [ -z $USER ]; then
  U="'$USER'"
fi

echo "pinging '$1' for $U"

# counting number of iterations
C=0
while true; do
  GRP="^"
  if ! [ -z $USER ]; then
    GRP="^$USER\$"
  fi

  n=$(ps -C $1 -o user= | grep -c "$GRP")
  echo "$1: $n instances..."
  C=$(($C + 1))
  if [ $C -eq $COUNT ]; then exit 0; fi
  sleep $TIME
done
