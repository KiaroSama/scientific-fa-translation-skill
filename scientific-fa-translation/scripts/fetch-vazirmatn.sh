#!/usr/bin/env bash
# Download Vazirmatn Regular + Bold (Western digits) into a fonts/ directory.
# Do not fetch the UI-FD / Farsi-digits cut.
set -euo pipefail

dest=${1:-fonts}
ver=33.003
url="https://github.com/rastikerdar/vazirmatn/releases/download/v${ver}/vazirmatn-v${ver}.zip"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$dest"
curl -fsSL -o "$tmp/vazirmatn.zip" "$url"
unzip -q -o "$tmp/vazirmatn.zip" \
  "fonts/ttf/Vazirmatn-Regular.ttf" \
  "fonts/ttf/Vazirmatn-Bold.ttf" \
  -d "$tmp"
cp -f "$tmp/fonts/ttf/Vazirmatn-Regular.ttf" "$tmp/fonts/ttf/Vazirmatn-Bold.ttf" "$dest/"
echo "$dest/Vazirmatn-Regular.ttf"
echo "$dest/Vazirmatn-Bold.ttf"
