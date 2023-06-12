#!/usr/bin/env bash

# change to project root.
cd "$(dirname "$0")"/..

CONDUIT_GORELEASER_URL=https://raw.githubusercontent.com/winder/conduit/will/goreleaser-env/.goreleaser.yaml
curl -qs $CONDUIT_GORELEASER_URL --output .goreleaser.yaml

# Swap in custom docker image name.
# Remove extra files -- it is in the upstream image.
sed -i \
  -e 's/DOCKER_NAME=.*/DOCKER_NAME=custom\/conduit/' \
  -e '/extra_files:/,+1d' \
  .goreleaser.yaml

cat <<EOL >> Dockerfile
# Build this Dockerfile with goreleaser.
# The binary must be present at /conduit
FROM algorand/conduit
ADD conduit /usr/local/bin/conduit
EOL
