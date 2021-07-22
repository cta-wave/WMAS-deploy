#!/bin/bash

docker build --build-arg commit=$1 -t wmas2020:$2 .
