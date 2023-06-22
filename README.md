# Conduit Plugin Templates

This repository is designed for someone who understands how [Conduit](https://github.com/algorand/conduit)
works and would like to extend its functionality by building a plugin.

Plugin templates are implemented in the `plugin` package. There you'll find
`importer`, `processor` and `exporter` templates. These have no functionality
and should be modified.

## Overview

This template project provides you with everything to get started with a
Conduit plugin. This includes:
* Boilerplate implementations of each plugin.
* Main function that registers them in a binary.
* Scripts to get the stack up and running with a node.
* Release process to distribute your plugin.

## How to use this repo

The most important step is deciding which type of plugin you should use to
implement your idea. An `exporter` is good for sending data to a an external
resource, such as a database or application. `processor` plugins are useful
for applying rules that filter transactions.

### Code

Once you've selected what type of plugin you want to implement, you can start
writing code. Open this project in your preferred Go IDE and navigate to the
`plugin` package.

The different lifecycle phases are implemented as different functions on the
interface. For more details on this see the [Development](https://github.com/algorand/conduit/blob/master/docs/Development.md) documentation.

### Build

A main function is provided at `cmd/conduit/main.go`. It's configured to load
the plugin templates along with the built-in plugins located in the Conduit
repository.

To build is a standard operation, run it with: `make conduit`

This places the `conduit` binary at the project root.

Verify that your plugin(s) are listed in the resulting binary: `./conduit list`

### Test

Just like the released version of Conduit, a `config.yml` file is required and
must be configured. An Algorand node is also required as a data source.

For convenience, consider running your node with docker. This makes it easy to
configure the network you'll connect to and the API tokens. Modify the
following command to suite your needs. Note that you can leave out the
`NETWORK` option to start a private network:
```
docker run -d -p 4190:8080 --name conduit-template-follower \
  -e ADMIN_TOKEN=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa \
  -e TOKEN=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa \
  -e PROFILE=conduit \
  -e NETWORK=testnet \
  algorand/algod:stable
```

With the above config you can configure your conduit data directory:
```
./conduit init --importer algod --processors processor_template --exporter exporter_template -d conduit_data
```

Fill in the algod address and tokens:
```
sed -i \
  -e "s,mode: OFF,mode: ON,
  s,netaddr: \"http:\/\/url:port\",netaddr: \"localhost:4190\",
  s, token: \"\", token: \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa \",
  s,admin-token: \"\",admin-token: \"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa \"," \
  conduit_data/conduit.yml
```

Inspect `conduit.yml` for correctness. If you've added settings for your plugin
fill them in now.

At this point, start conduit: `./conduit -d conduit_data`

If you make changes to your plugin, be sure to run `make conduit` before
restarting the test.

Conduit is also able to use fast catchup to start at a specific round. For some
networks, like mainnet, this may take 30 minutes or more to initialize.  To
start conduit on round 28000000, use the command:
`./conduit -d conduit_data -r 28000000`

### Release

This release process has limited support. Please create an issue here or in the
Conduit repo if you experience problems with it.

Goreleaser can be configured with `make release`. It is setup to cross compile
for multiple platforms, in addition to creating multi-architecture Docker
images.

There are some additional dependencies to get everything to work:
* [goreleaser](https://goreleaser.com/install/)
* Docker
* QEMU (for docker multi-arch builds)
* DockerHub credentials / "docker login"
* Github API Token
