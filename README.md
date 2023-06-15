# Conduit Plugin Templates

Templates to get you started with [Conduit](https://github.com/algorand/conduit) plugin development.

See the `plugin` package for an example of each available plugin interface.

## Quickstart

1. Install dependencies:
    * A terminal with `make`, `bash` and `git` available.
    * [Go build environment](https://go.dev/doc/install)
2. [Fork this project and clone it locally](https://docs.github.com/en/get-started/quickstart/fork-a-repo).
3. Build the project: `make conduit`
4. Test the project: `make run`, and follow the printed instructions.

See the [documentation](https://developer.algorand.org/docs/get-details/conduit/Development/) for more.

![Conduit Quickstart](build/demo/demo.gif)

## Overview

This template project provides you with everything to get started with a
Conduit plugin. This includes:
* Boilerplate implementations of each plugin.
* Main function that registers them in a binary.
* Scripts to get the stack up and running with a node.
* Release process to distribute your plugin.

### Boilerplate

The interfaces are implemented and demonstrate how to build, configure and
register each of the different plugin types with the Conduit framework.

An example `main.go` pulls together the upstream plugins, the local plugins,
and launches the standard Conduit CLI along with all of the config utilities.
For example, see the 3 template plugins in the `list` subcommand:
```bash
> go run cmd/conduit/main.go list
importers:
  algod             - Importer for fetching blocks from an algod REST API.
  file_reader       - Importer for fetching blocks from files in a directory created by the 'file_writer' plugin.
  importer_template - Example importer.

processors:
  filter_processor   - Filter transactions out of the results according to a configurable pattern.
  noop               - noop processor
  processor_template - Example processor.

exporters:
  exporter_template - Example exporter.
  file_writer       - Exporter for writing data to a file.
  noop              - noop exporter
  postgresql        - Exporter for writing data to a postgresql instance.
```

The config samples are also available:
```bash
> go run cmd/conduit/main.go list importers importer_template
name: importer_template
config:
  config_string: "This is a sample config string"
  config_int: 42
```

Finally, the `init` command can be used to create a configuration template:
```bash
> go run cmd/conduit/main.go init --importer importer_template --processors processor_template --exporter exporter_template
... global config omitted ...

# The importer is typically an algod follower node.
importer:
name: importer_template
config:
  config_string: "This is a sample config string"
  config_int: 42

# Zero or more processors may be defined to manipulate what data
# reaches the exporter.
processors:
  - name: processor_template
    config:
      config_string: "This is a sample config string"
      config_int: 42

# An exporter is defined to do something with the data.
exporter:
name: exporter_template
config:
  config_string: "This is a sample config string"
  config_int: 42
```

### Testing

A simple configuration is available to launch your project with a predefined
configuration. Use `make run` and follow the instructions printed to the
terminal.

### Release

Goreleaser can be configured with `make release`. It is setup to cross compile
for multiple platforms, in addition to creating multi-architecture Docker
images.

There are some additional dependencies to get everything to work:
* [goreleaser](https://goreleaser.com/install/)
* Docker
* QEMU (for docker multi-arch builds)
* DockerHub credentials / "docker login"
* Github API Token

If you're interested in going through this process please create an issue here
or in the upstream Conduit repo. The current support is pretty minimal.
