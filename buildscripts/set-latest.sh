#!/bin/bash
set -o errexit
set -o nounset

# this file is needed because the version is set by: `"#{semver}~#{platform}.#{platform_version}"`
# in `util/version.rb`, which contains a latest timestamp by default. this timestamp is generated in
# the build and as such is not nown ahead of time. 

# this script just searches for the latest build by file extension, and makes a copy of it as 'latest'
# for use in s3. ideal replacement to this issue would be to use releases/builds in github itself

rename_file_copy_to_latest() {
    # drops all the stuff that's usually caught by the wildcard in the find function "*" and replaces with `latest``
    if [[ "$1" == *".metadata.json" ]]; then
        # moves metadata file with latest suffix
        mv "$1" "deploy/${TRAVIS_REPO_SLUG}/latest/aptible-toolbelt-latest_${DOCKER_TAG}_${TRAVIS_CPU_ARCH}${PKG_FILE_EXT}.metadata.json"
    elif [[ "$1" == *"${PKG_FILE_EXT}" ]]; then
        # moves versioned file (rpm/deb) with latest suffix
        mv "$1" "deploy/${TRAVIS_REPO_SLUG}/latest/aptible-toolbelt-latest_${DOCKER_TAG}_${TRAVIS_CPU_ARCH}${PKG_FILE_EXT}"
    else
        echo "Found file that will not be renamed: $1"
    fi
}
export -f rename_file_copy_to_latest

cp -R pkg "deploy/${TRAVIS_REPO_SLUG}/latest/"
find "deploy/${TRAVIS_REPO_SLUG}/latest" -name "aptible-toolbelt*" | xargs -I {} bash -c 'rename_file_copy_to_latest "$@"'
