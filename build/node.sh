#!/usr/bin/env bash

# change to project root.
ROOTDIR="$(dirname "$0")"/..
cd $ROOTDIR

CONDUIT=./cmd/conduit/conduit
ALGOD=
TOKEN=
DATA_DIR=run_data
CONFIG_FILE=$DATA_DIR/conduit.yml

if [ -d $DATA_DIR ]; then
  echo "Using existing data directory: $DATA_DIR"
else
  echo "Initializing data directory: $DATA_DIR"
  mkdir $DATA_DIR
  $CONDUIT init --importer algod --processors processor_template --exporter exporter_template > $CONFIG_FILE

  # 1. Configure metrics.
  # 2. Configure archival mode.
  # 3. Configure the algod URL.
  # 4. Configure the non-admin API token.
  sed -i \
    -e "s/mode: OFF/mode: ON/" \
    -e 's/mode: "follower"/mode: "archival"/' \
    -e "s/netaddr: \"http:\/\/url:port\"/netaddr: \"$ALGOD\"/" \
    -e "s/ token: \"\"/ token: \"$TOKEN\"/" \
    $CONFIG_FILE
fi

echo "To customize, modify $CONFIG_FILE and run again."

echo "Data dir configured, run conduit with:"
echo "  $CONDUIT -d $DATA_DIR"

echo "To start on a specific round:"
echo "  $CONDUIT -d $DATA_DIR -r 15000000"

echo "For additional round data, setup an algod follower node:"
echo "1. run docker command:"
echo "    docker run --rm -it -p 4190:8080 --name algod-test-run -e ADMIN_TOKEN=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa -e TOKEN=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa -e PROFILE=conduit -e NETWORK=mainnet algorand/algod:nightly"
echo "2. update algod section of $CONFIG_FILE:"
echo "     mode: \"follower\""
echo "     netaddr: \"localhost:4190\""
echo "     token: \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa \""
echo "     admin-token: \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa \""
echo "3. $CONDUIT -d $DATA_DIR"


