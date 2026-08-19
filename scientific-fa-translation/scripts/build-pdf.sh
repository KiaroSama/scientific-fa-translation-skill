#!/usr/bin/env bash
# Compile a Persian print document and copy the PDF to ~/Documents/books.
# Engine order: XeLaTeX (for .tex), then Chromium, then WeasyPrint (for .html).
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: build-pdf.sh <file.tex|file.html> [slug]" >&2
  exit 2
fi

src=$1
if [[ ! -f "$src" ]]; then
  echo "build-pdf.sh: not a file: $src" >&2
  exit 1
fi

src_dir=$(cd "$(dirname "$src")" && pwd)
src_base=$(basename "$src")
ext=${src_base##*.}
stem_src=${src_base%.*}
stem=${2:-$stem_src}
dest_dir="${HOME}/Documents/books"
dest="${dest_dir}/${stem}.pdf"

mkdir -p "$dest_dir"
cd "$src_dir"

find_chrome() {
  local c
  for c in chromium chromium-browser google-chrome google-chrome-stable; do
    if command -v "$c" >/dev/null 2>&1; then
      printf '%s\n' "$c"
      return 0
    fi
  done
  return 1
}

html_to_pdf() {
  local html=$1
  local out=$2
  local chrome
  if chrome=$(find_chrome); then
    "$chrome" --headless --disable-gpu --no-pdf-header-footer \
      --print-to-pdf="$out" "file://$(realpath "$html")"
    return 0
  fi
  if command -v weasyprint >/dev/null 2>&1; then
    weasyprint "$html" "$out"
    return 0
  fi
  if python3 -c "import weasyprint" >/dev/null 2>&1; then
    python3 -c 'from weasyprint import HTML; import sys; HTML(sys.argv[1]).write_pdf(sys.argv[2])' \
      "$html" "$out"
    return 0
  fi
  echo "build-pdf.sh: need Chromium or WeasyPrint for HTML (xelatex missing or .html input)" >&2
  echo "build-pdf.sh: install weasyprint in a venv, or: pip install --user --break-system-packages weasyprint" >&2
  return 1
}

compile_tex() {
  if ! command -v xelatex >/dev/null 2>&1; then
    return 1
  fi
  xelatex -interaction=nonstopmode -halt-on-error "$src_base"
  xelatex -interaction=nonstopmode -halt-on-error "$src_base"
  local pdf="${src_base%.tex}.pdf"
  if [[ ! -f "$pdf" ]]; then
    echo "build-pdf.sh: expected PDF missing: ${src_dir}/${pdf}" >&2
    return 1
  fi
  cp -f "$pdf" "$dest"
  return 0
}

case "$ext" in
  tex)
    if compile_tex; then
      echo "$dest"
      exit 0
    fi
    html_fallback="${stem_src}.html"
    if [[ -f "$html_fallback" ]]; then
      echo "build-pdf.sh: xelatex not usable; falling back to $html_fallback" >&2
      html_to_pdf "$html_fallback" "$dest"
      echo "$dest"
      exit 0
    fi
    echo "build-pdf.sh: xelatex not found and no ${html_fallback} next to the .tex" >&2
    echo "build-pdf.sh: write the HTML from assets/rtl-document.html and retry:" >&2
    echo "  $0 ${src_dir}/${html_fallback} ${stem}" >&2
    exit 1
    ;;
  html|htm)
    html_to_pdf "$src_base" "$dest"
    echo "$dest"
    ;;
  *)
    echo "build-pdf.sh: expected .tex or .html, got: $src_base" >&2
    exit 2
    ;;
esac
