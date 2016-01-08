test:
	@echo "Checking if './bin/iocat' runs without syntax error"
	./bin/iocat --help

build:
	coffee -c -o lib src

watch:
	coffee -w -c -o lib src
