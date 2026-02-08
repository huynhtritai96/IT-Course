#!/usr/bin/env bash
set -euo pipefail

# Install Node.js v22.13.0 (linux-x64) to /usr/local
VERSION="v22.13.0"
DIST="node-${VERSION}-linux-x64"
TARBALL="${DIST}.tar.xz"
BASE_URL="https://nodejs.org/download/release/${VERSION}"

cd /tmp

# Download tarball and checksums
curl -fsSLO "${BASE_URL}/${TARBALL}"
curl -fsSLO "${BASE_URL}/SHASUMS256.txt"

# Verify checksum
grep " ${TARBALL}$" SHASUMS256.txt | sha256sum -c -

# Remove existing Node.js from /usr/local (if present)
sudo rm -rf /usr/local/bin/node /usr/local/bin/npm /usr/local/bin/npx /usr/local/include/node /usr/local/lib/node_modules /usr/local/share/doc/node /usr/local/share/man/man1/node.1

# Install
tar -xJf "${TARBALL}"
sudo cp -r "${DIST}/"* /usr/local/

# Verify
node -v
npm -v
