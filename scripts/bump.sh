#!/usr/bin/env bash
# Pin the formula to a published npm version: scripts/bump.sh 0.1.0-alpha.7
set -euo pipefail

version="${1:?usage: scripts/bump.sh <npm-version>}"
formula="$(dirname "$0")/../Formula/nodemantis.rb"
tarball="https://registry.npmjs.org/node-mantis/-/node-mantis-${version}.tgz"

tmp="$(mktemp)"
curl -fsSL "$tarball" -o "$tmp"
sha256="$(shasum -a 256 "$tmp" | awk '{print $1}')"
rm -f "$tmp"

sed -i.bak -E \
  -e "s|node-mantis-[^\"]+\.tgz|node-mantis-${version}.tgz|" \
  -e "s|^  version \"[^\"]+\"|  version \"${version}\"|" \
  -e "s|^  sha256 \"[^\"]+\"|  sha256 \"${sha256}\"|" \
  "$formula"
rm -f "${formula}.bak"

echo "Pinned nodemantis formula to ${version} (${sha256})"
