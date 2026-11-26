all: patch build

init:
	git submodule update --init

update:
	git submodule update --remote
	cd R && git checkout 54abeec

patch:
	bash patch.sh

build:
	bash build.sh
