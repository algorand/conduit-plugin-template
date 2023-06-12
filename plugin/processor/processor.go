package processor

import (
	"context"
	_ "embed"
	"fmt"

	"github.com/sirupsen/logrus"
	"gopkg.in/yaml.v2"

	"github.com/algorand/conduit/conduit/data"
	"github.com/algorand/conduit/conduit/plugins"
	"github.com/algorand/conduit/conduit/plugins/processors"
)

//go:embed sample.yaml
var sampleConfig string

// metadata contains information about the plugin used for CLI helpers.
var metadata = plugins.Metadata{
	Name:         "processor_template",
	Description:  "Example processor.",
	Deprecated:   false,
	SampleConfig: sampleConfig,
}

func init() {
	processors.Register(metadata.Name, processors.ProcessorConstructorFunc(func() processors.Processor {
		return &processorTemplate{}
	}))
}

type Config struct {
	// TODO: your configuration here.
	ConfigString string `yaml:"config_string"`
	ConfigInt    int    `yaml:"config_int"`
}

// processorTemplate is the object which implements the processor plugin interface.
type processorTemplate struct {
	log *logrus.Logger
	cfg Config
}

func (pt *processorTemplate) Metadata() plugins.Metadata {
	return metadata
}

func (pt *processorTemplate) Config() string {
	ret, _ := yaml.Marshal(pt.cfg)
	return string(ret)
}

func (pt *processorTemplate) Close() error {
	return nil
}

func (pt *processorTemplate) Init(_ context.Context, _ data.InitProvider, cfg plugins.PluginConfig, log *logrus.Logger) error {
	pt.log = log
	if err := cfg.UnmarshalConfig(&pt.cfg); err != nil {
		return fmt.Errorf("unable to read configuration: %w", err)
	}

	// TODO: Your init code here.

	return nil
}

func (pt *processorTemplate) Process(input data.BlockData) (data.BlockData, error) {
	pt.log.Infof("Processing block %d", input.Round())

	// TODO: Your processing code here.

	return input, nil
}
