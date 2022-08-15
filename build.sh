#!/bin/bash

reload_runner=false
reload_tests=false
no_cache=false

for var in "$@"
do
  if [ "$var" == "--reload-runner" ]; then
    reload_runner=true;
  elif [ "$var" == "--reload-tests" ]; then
    reload_tests=true;
  elif [ "$var" == "--no-cache" ]; then
    no_cache=true;
  fi
done

args=""

if [ $reload_runner = true ]; then
  args="$args --build-arg runner-rev=\"$(date | sed "s/ //g")\""
fi

if [ $reload_tests = true ]; then
  args="$args --build-arg tests-rev=\"$(date | sed "s/ //g")\""
fi

if [ $no_cache = true ]; then
  args="$args --no-cache"
fi

docker build --network="host" --build-arg commit=$1 $args -t wmas2020:$2 .
