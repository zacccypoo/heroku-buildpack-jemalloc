default: heroku-18 heroku-20 heroku-22

VERSION := 5.2.0
ROOT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

clean:
	rm -rf src/ dist/

console:
	@echo "Console Help"
	@echo
	@echo "Specify a verion to install:"
	@echo "    echo 5.2.1 > /env/JEMALLOC_VERSION"
	@echo
	@echo "To vendor jemalloc:"
	@echo "    bin/compile /app/ /cache/ /env/"
	@echo

	@docker run --rm -ti -v $(shell pwd):/buildpack -e "STACK=heroku-20" -w /buildpack heroku/heroku:20-build \
		bash -c 'mkdir /app /cache /env; exec bash'

# Download missing source archives to ./src/
src/jemalloc-%.tar.bz2:
	mkdir -p $$(dirname $@)
	curl -fsL https://github.com/jemalloc/jemalloc/releases/download/$*/jemalloc-$*.tar.bz2 -o $@

.PHONY: heroku-18 heroku-20 docker\:pull

# Updates the docker image to ensure we're building with the latest
# environment.
docker\:pull:
	docker pull heroku/heroku:18-build
	docker pull heroku/heroku:20-build

# Build for heroku-18 stack
heroku-18: src/jemalloc-$(VERSION).tar.bz2 docker\:pull
	docker run --rm -it --volume="$(ROOT_DIR):/wrk" \
		heroku/heroku:18-build /wrk/build.sh $(VERSION) heroku-18

# Build for heroku-20 stack
heroku-20: src/jemalloc-$(VERSION).tar.bz2 docker\:pull
	docker run --rm -it --volume="$(ROOT_DIR):/wrk" \
		heroku/heroku:20-build /wrk/build.sh $(VERSION) heroku-20

# Build for heroku-22 stack
heroku-22: src/jemalloc-$(VERSION).tar.bz2 docker\:pull
	docker run --rm -it --volume="$(ROOT_DIR):/wrk" \
		heroku/heroku:22-build /wrk/build.sh $(VERSION) heroku-22

# Build recent releases for all supported stacks
all:
	$(MAKE) heroku-18 heroku-20 heroku-22 VERSION=3.6.0
	$(MAKE) heroku-18 heroku-20 heroku-22 VERSION=4.0.4
	$(MAKE) heroku-18 heroku-20 heroku-22 VERSION=4.1.1
	$(MAKE) heroku-18 heroku-20 heroku-22 VERSION=4.2.1
	$(MAKE) heroku-18 heroku-20 heroku-22 VERSION=4.3.1
	$(MAKE) heroku-18 heroku-20 heroku-22 VERSION=4.4.0
	$(MAKE) heroku-18 heroku-20 heroku-22 VERSION=4.5.0
	$(MAKE) heroku-18 heroku-20 heroku-22 VERSION=5.0.1
	$(MAKE) heroku-18 heroku-20 heroku-22 VERSION=5.1.0
	$(MAKE) heroku-18 heroku-20 heroku-22 VERSION=5.2.0
	$(MAKE) heroku-18 heroku-20 heroku-22 VERSION=5.2.1
	$(MAKE) heroku-18 heroku-20 heroku-22 VERSION=5.3.0
