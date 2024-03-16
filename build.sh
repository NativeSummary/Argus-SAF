#!/bin/bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
set -e

if [ ! -e "$SCRIPTPATH/amandroid.zip" ]; then
  wget https://www.fengguow.dev/resources/amandroid.zip -O "$SCRIPTPATH/amandroid.zip"
fi

if [ ! -e "$SCRIPTPATH/amandroid.checksum" ]; then
  wget https://www.fengguow.dev/resources/amandroid.checksum -O "$SCRIPTPATH/amandroid.checksum"
fi

mkdir -p "$SCRIPTPATH/.amandroid_stash"
if [ ! -e "$SCRIPTPATH/.amandroid_stash/amandroid" ]; then
  unzip "$SCRIPTPATH/amandroid.zip" -d "$SCRIPTPATH/.amandroid_stash"
fi

if [ ! -e "$SCRIPTPATH/.amandroid_stash/amandroid.checksum" ]; then
  mv "$SCRIPTPATH/amandroid.checksum" "$SCRIPTPATH/.amandroid_stash/amandroid.checksum"
fi

docker image rm jnsaf || true
docker build . --tag jnsaf
