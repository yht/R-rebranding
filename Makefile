all: patch build

init:
	git submodule update --init

update:
	git submodule update --remote
	cd R && git checkout 54abeec

deps:
	@echo "Installing build dependencies for Debian/Ubuntu..."
	sudo apt-get update
	sudo apt-get install -y \
	    build-essential \
	    libopenblas-dev \
	    libxml2-dev \
	    libssl-dev \
	    libbz2-dev \
	    liblzma-dev \
	    libpcre2-dev \
	    zlib1g-dev \
	    libicu-dev \
	    libreadline-dev \
	    libx11-dev \
	    libxt-dev \
	    tcl-dev \
	    tk-dev \
	    libcurl4-openssl-dev \
	    pkg-config \
	    autoconf \
	    automake \
	    libtool \
	    gettext

patch:
	bash patch.sh

build:
	bash build.sh

.PHONY: all init update deps patch build
