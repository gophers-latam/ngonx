# Get version from git hash
git_hash := $(shell git rev-parse --short HEAD || echo 'development')

# project version
# version = $(shell git describe --tags --abbrev=0 || echo 'development')
version = $(shell git tag | sort -V | tail -1 || echo 'development')
# Get current date
current_time = $(shell date +"%Y-%m-%d:T%H:%M:%S")


# Add linker flags
linker_flags = '-s -X main.buildTime=${current_time} -X main.versionHash=${git_hash} -X main.version=${version}'

# Build binaries for current OS and Linux
.PHONY:
compile:
	@echo "Building binaries..."

	GOOS=linux GOARCH=amd64 go build -ldflags=${linker_flags} -o ./build/ngonxctl-${version}-linux-amd64 cmd/main.go
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -ldflags=${linker_flags} -o ./build/ngonxctl-${version}-windows-amd64.exe cmd/main.go

gocert:
	go run ./tools/generate_cert.go

gossl:
	./scripts/generate.sh

#Only use if you have installed UPX compress
compress:
	./upx -9 -q ./build/ngonxctl-${version}-linux-amd64