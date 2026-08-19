#!/usr/bin/env bash
# Compile a XeLaTeX document and copy the PDF to ~/Documents/books.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: build-pdf.sh <file.tex> [slug]" >&2
  exit 2
fi

tex=$1
if [[ ! -f "$tex" ]]; then
  echo "build-pdf.sh: not a file: $tex" >&2
  exit 1
fi

tex_dir=$(cd "$(dirname "$tex")" && pwd)
tex_base=$(basename "$tex")
stem=${2:-${tex_base%.tex}}
dest_dir="${HOME}/Documents/books"
dest="${dest_dir}/${stem}.pdf"

if ! command -v xelatex >/dev/null 2>&1; then
  echo "build-pdf.sh: xelatex not found" >&2
  exit 1
fi

mkdir -p "$dest_dir"
cd "$tex_dir"

xelatex -interaction=nonstopmode -halt-on-error "$tex_base"
xelatex -interaction=nonstopmode -halt-on-error "$tex_base"

pdf="${tex_base%.tex}.pdf"
if [[ ! -f "$pdf" ]]; then
  echo "build-pdf.sh: expected PDF missing: ${tex_dir}/${pdf}" >&2
  exit 1
fi

cp -f "$pdf" "$dest"
echo "$dest"
