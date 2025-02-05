#!/usr/bin/env bash

set -o errexit

if [[ $# -ne 3 ]]; then
    echo >&2 "Usage: $0 GRASS_COMMAND GRASS_SOURCE_CODE DATA_DIR"
    exit 1
fi

GRASS_COMMAND="$1"
GRASS_SOURCE_CODE="$2"
DATABASE="$3"

DATABASE=$(realpath -s "$DATABASE")

# Install module from addons if not available (as in v7).
if ! "$GRASS_COMMAND" --tmp-location XY --exec g.download.location --help; then
    "$GRASS_COMMAND" --tmp-location XY --exec \
        g.extension g.download.location
fi
# Download only if the directory does not exist.
if [ ! -d "$DATABASE/nc_spm_full_v2alpha2" ]; then
    "$GRASS_COMMAND" --tmp-location XY --exec \
        g.download.location url=https://grass.osgeo.org/sampledata/north_carolina/nc_spm_full_v2alpha2.tar.gz path="$DATABASE"
fi

cd "$GRASS_SOURCE_CODE"

"$GRASS_COMMAND" --tmp-location XY --exec \
    python3 -m grass.gunittest.main \
    --grassdata "$DATABASE" --location nc_spm_full_v2alpha2 --location-type nc \
    --min-success 50
