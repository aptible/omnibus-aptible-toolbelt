#!/bin/bash
set -o errexit
set -o nounset

KEYCHAIN_PASS="foobar"  # Doesn't actually need to be secret - that keychain never leaves CI.
KEYCHAIN_NAME="aptible-toolbelt.keychain"

security delete-keychain "$KEYCHAIN_NAME"  || true
security create-keychain -p "$KEYCHAIN_PASS" "$KEYCHAIN_NAME"
KEYCHAIN_FILE="${HOME}/Library/Keychains/$KEYCHAIN_NAME"

security import "signing/cert.cer" -t cert -k "$KEYCHAIN_FILE" -T /usr/bin/pkgbuild -T /usr/bin/productbuild -T /usr/bin/codesign
security import "signing/key.p12" -t priv -k "$KEYCHAIN_FILE" -P '' -T /usr/bin/pkgbuild -T /usr/bin/productbuild -T /usr/bin/codesign

security -v unlock-keychain -p "$KEYCHAIN_PASS" "$KEYCHAIN_NAME"
security set-keychain-settings -lut 7200 "$KEYCHAIN_NAME"
security set-key-partition-list -S apple-tool:,apple: -s -k "${KEYCHAIN_PASS}" "${KEYCHAIN_NAME}"

# Troubleshooting
security list-keychains -s "$KEYCHAIN_NAME"
security find-identity -s codesign "$KEYCHAIN_NAME"
