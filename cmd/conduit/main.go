package main

import (
	"fmt"
	"os"

	// Imports for built-in plugins
	_ "github.com/algorand/conduit/conduit/plugins/exporters/all"
	_ "github.com/algorand/conduit/conduit/plugins/importers/all"
	_ "github.com/algorand/conduit/conduit/plugins/processors/all"

	_ "github.com/algorand/conduit-plugin-template/plugin/exporter"
	_ "github.com/algorand/conduit-plugin-template/plugin/importer"
	_ "github.com/algorand/conduit-plugin-template/plugin/processor"

	"github.com/algorand/conduit/pkg/cli"
)

func main() {
	conduitCmd := cli.MakeConduitCmdWithUtilities()
	if err := conduitCmd.Execute(); err != nil {
		fmt.Fprintf(os.Stderr, "%v\n", err)
		os.Exit(1)
	}
	os.Exit(0)
}
