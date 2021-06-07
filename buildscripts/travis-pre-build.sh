#!/bin/bash
set -o errexit
set -o nounset

if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
  if  [[ "$TRAVIS_SECURE_ENV_VARS" = "true" ]]; then
    openssl aes-256-cbc -K "$encrypted_3b9f0b9d36d1_key" -iv "$encrypted_3b9f0b9d36d1_iv" -in signing/secrets.tar.enc -out signing/secrets.tar -d
    unset "encrypted_3b9f0b9d36d1_key"
    unset "encrypted_3b9f0b9d36d1_iv"
    ( cd signing && tar xvf secrets.tar )
    sudo buildscripts/osx-load-signing.sh
  else
    # We don't have credentials, but we'd still want the build to run. Clear
    # the signing identity from config/projects/aptible-toolbelt.rb
    sed -i '' 's/^.*signing_identity.*$//g' config/projects/aptible-toolbelt.rb
    echo 'WARNING: No credentials; package will NOT be signed'
  fi
fi
