LDFLAGS += -X github.com/algorand/conduit/version.Hash=$(shell git log -n 1 --pretty="%H")
LDFLAGS += -X github.com/algorand/conduit/version.ShortHash=$(shell git log -n 1 --pretty="%h")
LDFLAGS += -X github.com/algorand/conduit/version.CompileTime=$(shell date -u +%Y-%m-%dT%H:%M:%S%z)
LDFLAGS += -X "github.com/algorand/conduit/version.ReleaseVersion=Custom Plugin Build"

conduit:
	cd cmd/conduit && go build -ldflags='${LDFLAGS}'
	./cmd/conduit/conduit -v

test:
	go test ./...

fmt:
	go fmt ./...

run: conduit
	@echo "\nSetting up a trivial processor/exporter config.\n"
	./build/node.sh

clean:
	rm -rf run_data

release:
	@echo "\nConfiguring .goreleaser"
	build/sync-config.sh
	@echo "Build everything with:"
	@echo "   goreleaser release --skip-publish --snapshot --clean"
