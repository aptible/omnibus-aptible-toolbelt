Aptible Toolbelt
================

[![Build Status](https://travis-ci.org/aptible/omnibus-aptible-toolbelt.svg?branch=master)](https://travis-ci.org/aptible/omnibus-aptible-toolbelt)

An Omnibus package for the Aptible CLI.


Why use the Aptible Toolbelt?
-----------------------------

- All dependencies are pinned, which means the Aptible CLI when installed via
  the Aptible Toolbelt starts a lot faster than when installed via RubyGems.
- The Aptible Toolbelt will eventually include utilities that the Aptible CLI
  relies on (e.g. `pg_dump`). You might need to install those manually
  otherwise.

Where can I download the Aptible Toolbelt?
------------------------------------------

The download links can be found [here in our documentation](https://deploy-docs.aptible.com/docs/cli). 

These links are versioned semantically, but one can also download the __latest__ version with the following link: 

```
# versioned link
https://omnibus-aptible-toolbelt.s3.amazonaws.com/aptible/omnibus-aptible-toolbelt/{{TRAVIS_BRANCH}}/{{CLI_BUILD_NUMBER}}/pkg/aptible-toolbelt_{{CLI_VERSION}}%2B{{CLI_TIMESTAMP}}~{{OS_TAG}}_{{CPU_ARCHITECTURE}}.{DISTRO_PACKAGE_EXTENSION}}


# example versioned link
https://omnibus-aptible-toolbelt.s3.amazonaws.com/aptible/omnibus-aptible-toolbelt/master/340/pkg/aptible-toolbelt_0.19.3%2B20220317192554~debian.9.13-1_amd64.deb


# latest link
https://omnibus-aptible-toolbelt.s3.amazonaws.com/aptible/omnibus-aptible-toolbelt/latest/aptible-toolbelt_latest_{{OS_TAG}}_{{CPU_ARCHITECTURE}}.{{DISTRO_PACKAGE_EXTENSION}}

# example deb link
https://omnibus-aptible-toolbelt.s3.amazonaws.com/aptible/omnibus-aptible-toolbelt/latest/aptible-toolbelt_latest_debian.9.13-1_amd64.deb
```

Developer Notes
---------------

This repository can be used to build packages locally, or via Docker. It relies
heavily on external caching to make builds fast (which usually means using your
workstation disk, but can also work in a CI environment — check `.travis.yml`
to see how that works).

In all cases, the resulting package will be found in `./pkg`.

### Native build ###

To make a native build (i.e. a build for the platform you're currently using),
use:

```
sudo mkdir -p /opt/aptible-toolbelt
sudo chown -R "$USER" /opt/aptible-toolbelt
bundle install
bundle exec omnibus build aptible-toolbelt
```

To build on macOS locally, you'll need to remove the `signing_identity` from 
`aptible-toolbelt.rb` from the `:pkg` package or add the production signing
certificate, `.cer`, to your keychain (i.e. open with Keychain Access).

### Updating MacOS certificate ###

First, you'll need to generate a new "Developer ID Installer" certificate via
the [Apple Developer Program site](https://developer.apple.com/account/resources/certificates/list).

To do this using a PKCS12 key, you can run (e.g.):

```
openssl req -new -keyform pkcs12 -key key.p12 -out cert.csr
```

Once you have a signing certificate from Apple, you'll need to encrypt the key
and certificate so that they can be accessed in Travis builds:

```
# Copy cert.cer and key.p12 into signing/ folder
cd signing/
tar cf secrets.tar cert.cer key.p12
travis encrypt-file --com -R aptible/omnibus-aptible-toolbelt secrets.tar
```

This final command will print new Travis secure ENV variables which you'll
need to copy and paste into buildscripts/travis-pre-build.sh, overwriting the
old values.

### Foreign build via Docker ###

Use:

```
# Other DOCKER_TAG values are available. Check
# https://github.com/aptible/aptible-omnibus-builder for available builders.
DOCKER_TAG=debian-8 buildscripts/docker.sh
```

### External Dependencies ### 

Be cautious when making breaking changes to build result paths.

Downstream consumers of this repository's outputs include:

* [Our homebrew cask for OSX installation](https://github.com/Homebrew/homebrew-cask/blob/master/Casks/aptible.rb)
* [Our PR generate](https://github.com/aptible/toolbelt-auto-update/blob/master/bin/toolbelt-auto-update#L64-L65), which looks for new CLI versions and opens PR's against our public docs and aptible-integration repos
* Update our [Windows and Mac OS package instructions](https://github.com/aptible/scripts/blob/master/doc/ReleaseNewCLIVersion.md)

## Copyright and License

MIT License, see [LICENSE](LICENSE.md) for details.

Copyright (c) 2019 [Aptible](https://www.aptible.com) and contributors.
