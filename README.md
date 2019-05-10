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

### Foreign build via Docker ###

Use:

```
# Other DOCKER_TAG values are available. Check
# https://github.com/aptible/aptible-omnibus-builder for available builders.
DOCKER_TAG=debian-8 buildscripts/docker.sh
```

## Copyright and License

MIT License, see [LICENSE](LICENSE.md) for details.

Copyright (c) 2019 [Aptible](https://www.aptible.com) and contributors.
