#!/bin/bash
set -o errexit
set -o nounset
set -o xtrace

# Travis uses rvm, which toys with environment variables enough that it's hard
# to use properly with sudo. So, if rvmsudo is in use, we'll use rvmsudo rather
# than regular sudo.
SUDO="sudo"
if [[ -n "${rvm_path:-}" ]]; then
  echo "Detected rvm: ${rvm_path}"
  SUDO="rvmsudo"
fi

# Since secure_path is set on our CentOS build images, we also need to ensure
# we only use absolute paths when referencing the binaries we want to run.
GEM="$(command -v gem)"
BUNDLE="$(command -v bundle)"
RUBY="$(command -v ruby)"

echo "Using SUDO=${SUDO}, GEM=${GEM}, BUNDLE=${BUNDLE}, RUBY=${RUBY}"

"$GEM" env
"$SUDO" "$GEM" env

"$SUDO" "$BUNDLE" install --without development --binstubs /tmp/binstubs
"$SUDO" env "DOCKER_TAG=${DOCKER_TAG:-native}" "$RUBY" /tmp/binstubs/omnibus build aptible-toolbelt

# Smoke test
time /opt/aptible-toolbelt/bin/aptible version
