GOBINARY ?= go
GOARCH ?= amd64

LDFLAG_LOCATION := github.com/metal-toolbox/vogelkop/internal/version
GIT_COMMIT  := $(shell git rev-parse --short HEAD)
GIT_BRANCH  := $(shell git symbolic-ref -q --short HEAD)
GIT_SUMMARY := $(shell git describe --tags --dirty --always)
VERSION     := $(shell git describe --tags 2> /dev/null)
BUILD_DATE  := $(shell date +%s)

build:
	GOOS=linux GOARCH=$(GOARCH) $(GOBINARY) build -o vogelkop \
	   -ldflags \
		"-X $(LDFLAG_LOCATION).GitCommit=$(GIT_COMMIT) \
         -X $(LDFLAG_LOCATION).GitBranch=$(GIT_BRANCH) \
         -X $(LDFLAG_LOCATION).GitSummary=$(GIT_SUMMARY) \
         -X $(LDFLAG_LOCATION).Version=$(VERSION) \
         -X $(LDFLAG_LOCATION).BuildDate=$(BUILD_DATE)"
lint:
	go run github.com/golangci/golangci-lint/cmd/golangci-lint@v1.57 run --config .golangci.yml --timeout=5m --out-format colored-line-number

lint-fix:
	go run github.com/golangci/golangci-lint/cmd/golangci-lint@v1.57 run --fix --config .golangci.yml --timeout=5m --out-format colored-line-number

test: lint
	CGO_ENABLED=0 $(GOBINARY) test -timeout 1m -v -covermode=atomic ./...
