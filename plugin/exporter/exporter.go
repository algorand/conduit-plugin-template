package exporter

import (
	"context"
	_ "embed"
	"fmt"

	"github.com/sirupsen/logrus"
	"gopkg.in/yaml.v2"

	"github.com/algorand/conduit/conduit/data"
	"github.com/algorand/conduit/conduit/plugins"
	"github.com/algorand/conduit/conduit/plugins/exporters"
)

//go:embed sample.yaml
var sampleConfig string

// metadata contains information about the plugin used for CLI helpers.
var metadata = plugins.Metadata{
	Name:         "exporter_template",
	Description:  "Example exporter.",
	Deprecated:   false,
	SampleConfig: sampleConfig,
}

func init() {
	exporters.Register(metadata.Name, exporters.ExporterConstructorFunc(func() exporters.Exporter {
		return &exporterTemplate{}
	}))
}

type Config struct {
	// TODO: your configuration here.
	ConfigString string `yaml:"config_string"`
	ConfigInt    int    `yaml:"config_int"`
}

// ExporterTemplate is the object which implements the exporter plugin interface.
type exporterTemplate struct {
	log *logrus.Logger
	cfg Config
}

func (et *exporterTemplate) Metadata() plugins.Metadata {
	return metadata
}

func (et *exporterTemplate) Config() string {
	ret, _ := yaml.Marshal(et.cfg)
	return string(ret)
}

func (et *exporterTemplate) Close() error {
	return nil
}

func (et *exporterTemplate) Init(_ context.Context, ip data.InitProvider, cfg plugins.PluginConfig, logger *logrus.Logger) error {
	et.log = logger
	if err := cfg.UnmarshalConfig(et.cfg); err != nil {
		return fmt.Errorf("unable to read configuration: %w", err)
	}

	// TODO: Your init logic here.

	return nil
}

func (et *exporterTemplate) Receive(exportData data.BlockData) error {

	// TODO: Your receive block data logic here.

	for _, txn := range exportData.Payset {
		et.log.Tracef("%v", txn)
	}

	for _, acct := range exportData.Delta.Accts.Accts {
		et.log.Tracef("%v", acct)
	}

	for _, asset := range exportData.Delta.Accts.AssetResources {
		et.log.Tracef("%v", asset)
	}

	for _, app := range exportData.Delta.Accts.AppResources {
		et.log.Tracef("%v", app)
	}

	return nil
}
