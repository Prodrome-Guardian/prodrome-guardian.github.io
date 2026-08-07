#!/usr/bin/env bash
# Regenerate index.html from the page source.
#
# The source file is a fragment (no <html>/<head>) because that is the format the
# Claude artifact host expects. This script wraps it with _head.html so the same
# content can be published as a standalone site. Edit the source, run this, commit.
#
#   ./build.sh [path/to/source.html]

set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
src="${1:-$here/src/page.html}"

if [[ ! -f "$src" ]]; then
  echo "error: source not found at $src" >&2
  echo "pass the path explicitly:  ./build.sh ../page.html" >&2
  exit 1
fi

cat "$here/_head.html" "$src" > "$here/index.html"
printf '\n</body>\n</html>\n' >> "$here/index.html"

echo "built index.html  ($(wc -c < "$here/index.html") bytes) from $src"
