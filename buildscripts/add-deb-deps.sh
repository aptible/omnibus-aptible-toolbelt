#!/bin/bash
# Modified from https://superuser.com/questions/280370/how-to-easily-edit-control-file-in-deb-package
if [[ $# -ne 1 ]]; then
  echo 'Adds dependencies to a Debian package'\''s control file and saves it as a new package'
  echo 'usage: add-deb-deps.sh PACKAGE'
  exit 1
fi

if [[ ! -e "$1" ]]; then
  echo "File $1 does not exist."
  exit 1
fi

DEBFILE="$1"
OUTPUT="$(basename "$DEBFILE" .deb)".final.deb
TMPDIR="$(mktemp -d /tmp/deb.XXXXXXXXXX)" || exit 1

trap "rm -rf $TMPDIR" EXIT SIGINT SIGTERM

if [[ -e "$OUTPUT" ]]; then
  echo "Output file $OUTPUT already exists."
  exit 1
fi

dpkg-deb -x "$DEBFILE" "$TMPDIR"
dpkg-deb --control "$DEBFILE" "$TMPDIR"/DEBIAN

CONTROL="$TMPDIR"/DEBIAN/control

if [[ ! -e "$CONTROL" ]]; then
  echo "Control file not found."
  exit 1
fi

if [[ ! -z "$(grep -e '^Depends:' "$CONTROL")" ]]; then
  echo 'Control file already has dependencies.'
  exit 1
fi

echo 'Depends: u2f-host (>=1.1.2)' >> "$CONTROL"
dpkg -b "$TMPDIR" "$OUTPUT"
