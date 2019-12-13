#!/bin/bash

docker build --build-arg commit=$1 -t wmats2018:$2 .
