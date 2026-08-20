#!/usr/bin/env bash
# Compile a Persian print document and copy the PDF to $HOME/Documents/books.
#
#   build-pdf.sh <file.tex|file.html> [slug] [--verify] [--engine ENGINE]
#
# Engine order for .tex: XeLaTeX (via latexmk when present). For .html:
# Chromium, then WeasyPrint. A missing engine falls back; a *failing* engine
# does not — it reports the error and stops, so a broken build is never
# quietly downgraded.
set -uo pipefail

usage() {
  echo "usage: build-pdf.sh <file.tex|file.html> [slug] [--verify]" \
       "[--engine tex|chromium|weasyprint]" >&2
  exit 2
}

[[ $# -ge 1 ]] || usage

src=""
slug=""
verify=0
engine=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --verify) verify=1; shift ;;
    --engine) engine=${2:-}; shift 2 ;;
    -h|--help) usage ;;
    -*) echo "build-pdf.sh: unknown option: $1" >&2; usage ;;
    *) if [[ -z $src ]]; then src=$1; elif [[ -z $slug ]]; then slug=$1;
       else usage; fi; shift ;;
  esac
done

[[ -n $src ]] || usage
if [[ ! -f $src ]]; then
  echo "build-pdf.sh: not a file: $src" >&2
  exit 1
fi

src_dir=$(cd "$(dirname "$src")" && pwd)
src_base=$(basename "$src")
ext=${src_base##*.}
stem_src=${src_base%.*}
stem=${slug:-$stem_src}
dest_dir="${HOME}/Documents/books"
dest="${dest_dir}/${stem}.pdf"

mkdir -p "$dest_dir"
cd "$src_dir" || exit 1

log() { printf 'build-pdf: %s\n' "$*" >&2; }

have_xelatex() {
  command -v xelatex >/dev/null 2>&1 || return 1
  # xepersian is the part that is usually missing on a bare TeX install.
  if command -v kpsewhich >/dev/null 2>&1; then
    kpsewhich xepersian.sty >/dev/null 2>&1 || return 1
  fi
  return 0
}

find_chrome() {
  local c
  for c in chromium chromium-browser google-chrome google-chrome-stable; do
    if command -v "$c" >/dev/null 2>&1; then printf '%s\n' "$c"; return 0; fi
  done
  return 1
}

show_tex_error() {
  local logfile=$1
  [[ -f $logfile ]] || return 0
  log "--- first TeX errors in ${logfile} ---"
  grep -n '^!' "$logfile" | head -20 >&2 || true
  log "--- last 25 log lines ---"
  tail -25 "$logfile" >&2
}

# 0 = built, 1 = engine unavailable, 2 = engine present but failed.
compile_tex() {
  have_xelatex || return 1
  local pdf="${stem_src}.pdf"
  if command -v latexmk >/dev/null 2>&1; then
    log "engine: latexmk -xelatex"
    latexmk -xelatex -interaction=nonstopmode -halt-on-error \
            -silent "$src_base" >/dev/null 2>&1 || {
      show_tex_error "${stem_src}.log"; return 2; }
  else
    log "engine: xelatex (two passes)"
    local pass
    for pass in 1 2; do
      xelatex -interaction=nonstopmode -halt-on-error "$src_base" \
        >/dev/null 2>&1 || { show_tex_error "${stem_src}.log"; return 2; }
    done
  fi
  [[ -f $pdf ]] || { log "expected PDF missing: ${src_dir}/${pdf}"; return 2; }
  cp -f "$pdf" "$dest" || return 2
  return 0
}

html_to_pdf() {
  local html=$1 out=$2 chrome
  if [[ $engine != weasyprint ]] && chrome=$(find_chrome); then
    log "engine: $chrome --print-to-pdf"
    # Without a virtual-time budget Chromium can print before the webfonts
    # finish loading, which produces fallback boxes for Persian.
    # --disable-gpu paints raster images as black rectangles; do not pass it.
    "$chrome" --headless=new --no-pdf-header-footer \
      --virtual-time-budget=10000 \
      --run-all-compositor-stages-before-draw \
      --print-to-pdf="$out" "file://$(realpath "$html")" || return 2
    return 0
  fi
  if command -v weasyprint >/dev/null 2>&1; then
    log "engine: weasyprint (keeps its bidi warnings; read them)"
    weasyprint "$html" "$out" || return 2
    return 0
  fi
  if python3 -c "import weasyprint" >/dev/null 2>&1; then
    log "engine: weasyprint (python module)"
    python3 -c 'from weasyprint import HTML; import sys;
HTML(sys.argv[1]).write_pdf(sys.argv[2])' "$html" "$out" || return 2
    return 0
  fi
  log "no HTML engine: install Chromium, or WeasyPrint in a venv"
  log "  (python3 -m venv … && pip install weasyprint; see pdf-output.md)"
  return 1
}

verify_pdf() {
  local pdf=$1
  [[ -s $pdf ]] || { log "VERIFY FAIL: $pdf is empty"; return 1; }
  local pages=""
  if command -v pdfinfo >/dev/null 2>&1; then
    pages=$(pdfinfo "$pdf" 2>/dev/null | awk '/^Pages:/{print $2}')
    log "pages: ${pages:-unknown}"
  fi
  if command -v pdffonts >/dev/null 2>&1; then
    log "embedded fonts:"
    pdffonts "$pdf" 2>/dev/null | sed -n '1,8p' >&2
    if ! pdffonts "$pdf" 2>/dev/null | tail -n +3 | grep -q 'yes'; then
      log "VERIFY WARN: no embedded font; Persian may render as boxes"
    fi
  fi
  if command -v pdftoppm >/dev/null 2>&1; then
    local out_prefix="${src_dir}/verify-${stem}"
    local last=${pages:-1}
    pdftoppm -png -r 110 -f 1 -l 1 "$pdf" "${out_prefix}-first" 2>/dev/null
    if [[ -n $pages && $pages -gt 1 ]]; then
      pdftoppm -png -r 110 -f "$last" -l "$last" "$pdf" \
        "${out_prefix}-last" 2>/dev/null
    fi
    log "rasterised samples: ${out_prefix}-*.png — look at them, do not"
    log "  judge RTL from pdftotext"
  fi
  return 0
}

rc=0
case "$ext" in
  tex)
    if [[ $engine == chromium || $engine == weasyprint ]]; then
      html="${stem_src}.html"
      [[ -f $html ]] || { log "no $html next to the .tex"; exit 1; }
      html_to_pdf "$html" "$dest"; rc=$?
    else
      compile_tex; rc=$?
      if [[ $rc -eq 2 ]]; then
        log "XeLaTeX is installed but the document failed to compile."
        log "Fix the TeX error above. Not falling back — a fallback here"
        log "  would hide a real error in the .tex."
        exit 1
      fi
      if [[ $rc -eq 1 ]]; then
        log "xelatex or xepersian not available (see scripts/preflight.sh)"
        html="${stem_src}.html"
        if [[ -f $html ]]; then
          log "falling back to $html"
          html_to_pdf "$html" "$dest"; rc=$?
        else
          log "write the HTML from assets/rtl-document.html and retry:"
          log "  $0 ${src_dir}/${html} ${stem}"
          exit 1
        fi
      fi
    fi
    ;;
  html|htm)
    html_to_pdf "$src_base" "$dest"; rc=$?
    ;;
  *)
    echo "build-pdf.sh: expected .tex or .html, got: $src_base" >&2
    exit 2
    ;;
esac

if [[ $rc -ne 0 ]]; then
  log "build failed"
  exit 1
fi

[[ $verify -eq 1 ]] && verify_pdf "$dest"

echo "$dest"
