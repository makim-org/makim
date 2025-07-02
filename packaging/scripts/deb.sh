#!/bin/bash

# Dynamically fetch the version from pyproject.toml
VERSION=$1
ARCHITECTURE=$2
MAKIM_BIN=$(ls ./dist/makim-linux-*)

echo "Building Debian package for Makim version: $VERSION"
echo "Using makim binary: $MAKIM_BIN"

# Build the Debian package using fpm
if [ -z "$VERSION" ]; then
  echo "Error: Version not found in pyproject.toml"
  exit 1
fi
if [ -z "$MAKIM_BIN" ]; then
  echo "Error: makim binary not found in dist directory"
  exit 1
fi
if ! command -v fpm &> /dev/null; then
  echo "Error: fpm is not installed. Please install it to proceed."
  exit 1
fi
if [ ! -f ./packaging/scripts/postinstall.sh ]; then
  echo "Error: postinstall script not found."
  exit 1
fi
if [ ! -f ./packaging/makim.service ]; then
  echo "Error: makim service file not found."
  exit 1
fi
if [ ! -f ./packaging/dependencies.txt ]; then
  echo "Error: dependencies.txt file not found."
  exit 1
fi
if [ ! -d ./dist ]; then
  echo "Error: dist directory not found."
  exit 1
fi
if [ ! -f ./pyproject.toml ]; then
  echo "Error: pyproject.toml not found."
  exit 1
fi
if [ ! -d ./packaging/scripts ]; then
  echo "Error: packaging/scripts directory not found."
  exit 1
fi


# Create the Debian package
fpm -s dir -t deb -n makim -v $VERSION \
 --architecture $ARCHITECTURE \
 --description "Makim" \
 --maintainer "Ivan Ogaswara <ivan.ogasawara@gmail.com>" \
 --depends "apt" \
 --deb-compression "xz" \
 --after-install packaging/scripts/postinstall.sh \
 --deb-pre-depends "apt" \
 $MAKIM_BIN=/usr/local/bin/makim \
 ./packaging/makim.service=/lib/systemd/system/makim.service \
 ./packaging/dependencies.txt=/usr/share/makim/dependencies.txt
