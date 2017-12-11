default: heroku-16 cedar-14

VERSION := 5.0.1
ROOT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

clean:
	rm -rf src/ dist/

# Download missing source archives to ./src/
src/jemalloc-%.tar.bz2:
	mkdir -p $$(dirname $@)
	curl -fsL https://github.com/jemalloc/jemalloc/releases/download/$*/jemalloc-$*.tar.bz2 -o $@

.PHONY: cedar-14 heroku-16

# Build for cedar-14 stack
cedar-14: src/jemalloc-$(VERSION).tar.bz2
	docker run -it --volume="$(ROOT_DIR):/wrk" \
		heroku/cedar:14 /wrk/build.sh $(VERSION) cedar-14

# Build for heroku-16 stack
heroku-16: src/jemalloc-$(VERSION).tar.bz2
	docker run -it --volume="$(ROOT_DIR):/wrk" \
		heroku/heroku:16-build /wrk/build.sh $(VERSION) heroku-16

# Build recent releases for all supported stacks
all:
	$(MAKE) cedar-14 VERSION=3.6.0
	$(MAKE) cedar-14 VERSION=4.5.0
	$(MAKE) cedar-14 VERSION=5.0.1
	$(MAKE) heroku-16 VERSION=3.6.0
	$(MAKE) heroku-16 VERSION=4.5.0
	$(MAKE) heroku-16 VERSION=5.0.1
