all: build

build:
	@docker build --tag=rpibind .
