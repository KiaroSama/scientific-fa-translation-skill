#!/usr/bin/env bash
# Regression tests for scripts/check-fa.py.
#
# The `good` fixtures must lint clean; the `bad` fixtures must report every
# check id listed below. Run before changing a rule so a loosened regex
# cannot pass silently.
set -uo pipefail

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
lint="$here/../scripts/check-fa.py"
fixtures="$here/fixtures"
fail=0

expect_clean() {
  local file=$1 out rc
  out=$(python3 "$lint" "$file" 2>&1)
  rc=$?
  if [[ $rc -ne 0 ]]; then
    echo "FAIL $(basename "$file"): expected clean, got:"
    echo "$out" | sed 's/^/    /'
    fail=1
  else
    echo "ok   $(basename "$file") lints clean"
  fi
}

expect_checks() {
  local file=$1
  shift
  local out rc missing=()
  out=$(python3 "$lint" "$file" --domains all 2>&1)
  rc=$?
  if [[ $rc -eq 0 ]]; then
    echo "FAIL $(basename "$file"): expected a non-zero exit"
    fail=1
  fi
  local id
  for id in "$@"; do
    grep -q -- "$id" <<<"$out" || missing+=("$id")
  done
  if [[ ${#missing[@]} -gt 0 ]]; then
    echo "FAIL $(basename "$file"): checks not reported: ${missing[*]}"
    fail=1
  else
    echo "ok   $(basename "$file") reports ${#@} expected checks"
  fi
}

expect_no_errors() {
  local file=$1 out errs
  out=$(python3 "$lint" "$file" --domains all 2>&1)
  errs=$(sed -n 's/^check-fa: \([0-9]*\) error.*/\1/p' <<<"$out")
  if [[ ${errs:-1} -ne 0 ]]; then
    echo "FAIL $(basename "$file"): expected 0 errors, got ${errs:-?}"
    echo "$out" | sed 's/^/    /'
    fail=1
  else
    echo "ok   $(basename "$file") has no errors"
  fi
}

expect_clean "$fixtures/good.tex"
expect_clean "$fixtures/good.html"

# The shipped templates must not trigger errors. Placeholder `TITLE` is a
# legitimate unisolated-Latin warning, so errors only.
expect_no_errors "$here/../assets/rtl-document.tex"
expect_no_errors "$here/../assets/rtl-document.html"

expect_checks "$fixtures/bad.tex" \
  arabic-letters eastern-digits zwnj-verb zwnj-plural latin-punct \
  forbidden-fa half-translation fa-morphology split-isolate \
  unisolated-latin code-direction missing-image bookmark-guard \
  figure-direction

expect_checks "$fixtures/bad.html" \
  arabic-letters eastern-digits zwnj-verb forbidden-fa half-translation \
  fa-morphology split-isolate unisolated-latin code-direction html-root \
  mirrored-image missing-image print-css figure-direction

# prepare-figures.py: flatten alpha onto white so print engines cannot
# composite it as a black rectangle.
if python3 -c "import PIL.Image" 2>/dev/null; then
  alpha="$fixtures/figures/alpha.png"
  python3 - "$alpha" <<'PY'
import struct, zlib, sys
from pathlib import Path
path = Path(sys.argv[1])
w, h = 4, 2
# RGBA: first pixel transparent black (the Cairo/WeasyPrint trap), rest white.
row = bytes([
    0,  # filter
    0, 0, 0, 0,
    255, 255, 255, 255,
    255, 255, 255, 255,
    255, 255, 255, 255,
])
raw = b"".join(row for _ in range(h))

def chunk(tag, data):
    c = tag + data
    return struct.pack(">I", len(data)) + c + struct.pack(">I", zlib.crc32(c) & 0xffffffff)

path.write_bytes(
    b"\x89PNG\r\n\x1a\n"
    + chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0))
    + chunk(b"IDAT", zlib.compress(raw))
    + chunk(b"IEND", b"")
)
PY
  prep="$here/../scripts/prepare-figures.py"
  check_out=$(python3 "$prep" "$alpha" --check 2>&1) || check_rc=$?
  if [[ ${check_rc:-0} -ne 0 ]] && grep -q alpha <<<"$check_out"; then
    echo "ok   prepare-figures --check reports alpha"
  else
    echo "FAIL prepare-figures --check missed alpha"
    echo "$check_out" | sed 's/^/    /'
    fail=1
  fi
  python3 "$prep" "$alpha" >/tmp/prep.out 2>&1 || true
  mode=$(python3 -c "from PIL import Image; print(Image.open('$alpha').mode)")
  if [[ $mode == RGB ]]; then
    echo "ok   prepare-figures flattened alpha to RGB"
  else
    echo "FAIL prepare-figures left mode=$mode"
    fail=1
  fi
  rm -f "$alpha" "$alpha.orig"
else
  echo "skip prepare-figures (no Pillow)"
fi

if [[ $fail -eq 0 ]]; then
  echo "all tests passed"
else
  echo "tests failed"
fi
exit $fail
