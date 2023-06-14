#!/usr/bin/env bash

# change to project root.
ROOTDIR="$(dirname "$0")"/..
cd $ROOTDIR

CONDUIT=./cmd/conduit/conduit
ALGOD=localhost:4190
TOKEN=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
ADMIN_TOKEN=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
DATA_DIR=run_data
CONFIG_FILE=$DATA_DIR/conduit.yml

color() { printf "\033[${1}m"; }

red=$(color "0;31")
green=$(color "0;32")
blue=$(color "0;34")

bold_blue=$(color "1;34")
bold_red=$(color "1;31")
bold_green=$(color "1;32")

reset=$(color "0")

echo ""

if [ -d $DATA_DIR ]; then
  echo "${bold_red}Using existing configuration file: ${bold_blue}$CONFIG_FILE${reset}"
else
  mkdir $DATA_DIR
  $CONDUIT init --importer algod --processors processor_template --exporter exporter_template > $CONFIG_FILE

  # 1. Enable metrics.
  # 2. Set algod address.
  # 3. Set auth tokens.
  sed -i \
    -e "s,mode: OFF,mode: ON," \
    -e "s,netaddr: \"http:\/\/url:port\",netaddr: \"$ALGOD\"," \
    -e "s, token: \"\", token: \"$TOKEN\"," \
    -e "s,admin-token: \"\",admin-token: \"$ADMIN_TOKEN\"," \
    $CONFIG_FILE
  echo "${bold_green}Configuration initialized at ${bold_blue}$CONFIG_FILE${reset}."
fi

echo ""
echo "1. Start a node with docker: ${bold_blue}make docker-node${reset}"
echo "2. Run conduit: ${bold_blue}$CONDUIT -d $DATA_DIR${reset}"
echo "   Optionally add ${bold_red}-r 28000000${reset} to start on a specific round."


