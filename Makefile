build:
	shards build dots -p --release

install: build
	cp bin/dots /usr/local/bin/dots

dev:
	shards build dots -p 