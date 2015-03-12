.PHONY: clean build test

all: build

clean:
	@rm -rf kernel/linux*
	@rm -rf rootfs* *.iso
	@rm -rf packages/*/*#*
	@rm -rf packages/*/*tar*

build:
	@echo "Building builder ..."
	@docker build -t vallinux/build .
	@echo "Building image ..."
	@docker run -i -t -v $(pwd):/work --rm vallinux/build

test:
	@./scripts/test.sh
