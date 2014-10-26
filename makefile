all: test build

test:
	./cli_test.sh

build:
	cp cli.sh hoster
	chmod +x hoster

install:
	cp hoster /usr/bin/hoster
