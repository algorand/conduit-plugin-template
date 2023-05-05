# Conduitu Plugin Templates

Templates to get you started with [Conduit](https://github.com/algorand/conduit) plugin development.

See the `plugin` package for an example of each available plugin interface.

## Quickstart

The plugins are all properly registered with the `main.go` function which
exposes all of the upstream utilities. For example, see the 3 template plugins in the `list` subcommand:
```bash
> go run cmd/main.go list
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
> go run cmd/main.go list importers importer_template
name: importer_template
config:
  config_string: "This is a sample config string"
  config_int: 42
```

Finally, they are also available with the `init` subcommand:
```bash
> go run cmd/main.go init --importer importer_template --processors processor_template --exporter exporter_template
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
