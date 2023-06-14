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
	./build/node.sh

clean: docker-stop
	rm -rf run_data

release:
	@echo "\nConfiguring .goreleaser"
	build/sync-config.sh
	@echo "Build everything with:"
	@echo "   goreleaser release --skip-publish --snapshot --clean"

docker-node: docker-stop
	docker run -d -p 4190:8080 --name conduit-template-follower \
  -e ADMIN_TOKEN=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa \
  -e TOKEN=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa \
  -e PROFILE=conduit \
  -e NETWORK=mainnet \
  algorand/algod:beta

docker-status:
		curl -qs -H "Authorization: Bearer aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" "localhost:4190/v2/status?pretty"

docker-stop:
	docker stop conduit-template-follower > /dev/null 2>&1  || true
	docker rm conduit-template-follower > /dev/null 2>&1 || true

demo:
	cd build/demo && vhs < demo.tape
