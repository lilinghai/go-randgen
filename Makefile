
all:resource test bin

resource:
	go generate ./resource

bin:
	go build -o go-randgen cmd/go-randgen/*.go

test:
	# close cache by -count=1
	go test -race -coverprofile=cover.out -count=1 ./...
	go tool cover -html=cover.out -o coverage.html

debug:
	go build -o go-randgen-debug -gcflags "-N -l" cmd/go-randgen/*.go

build_image:
	docker build . -t hub.pingcap.net/lilinghai/go-randgen

push_image:
	docker push hub.pingcap.net/lilinghai/go-randgen

darwin: # cross compile to mac
	GOOS=darwin GOARCH=amd64 go build -o go-randgen-darwin cmd/go-randgen/*.go

linux:
	GOOS=linux GOARCH=amd64 go build -o go-randgen-linux cmd/go-randgen/*.go

.PHONY: all resource bin test debug darwin build_image push_image
