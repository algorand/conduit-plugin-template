LDFLAGS += -X github.com/algorand/conduit/version.Hash=$(shell git log -n 1 --pretty="%H")
LDFLAGS += -X github.com/algorand/conduit/version.ShortHash=$(shell git log -n 1 --pretty="%h")
LDFLAGS += -X github.com/algorand/conduit/version.CompileTime=$(shell date -u +%Y-%m-%dT%H:%M:%S%z)
LDFLAGS += -X "github.com/algorand/conduit/version.ReleaseVersion=Custom Plugin Build"

conduit:
	go build -o conduit cmd/conduit/main.go -ldflags='${LDFLAGS}'
	./cmd/conduit/conduit -v

test:
	go test ./...

fmt:
	go fmt ./...

release:
	@echo "\nConfiguring .goreleaser"
	build/sync-config.sh
	@echo "Build everything with:"
	@echo "   goreleaser release --skip-publish --snapshot --clean"
