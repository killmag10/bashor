RM:= rm
MAN:= man
PATH_BIN:= bin

.PHONY: \
	all \
	install \
	uninstall \
	clean \
	test \
	man \
	generateMan

all:

install:
	# Nothing to do.

uninstall:
	# Nothing to do.

clean:
	# Remove generated man page.
	$(RM) doc/man/bashor.7

test:
	# Run tests.
	$(PATH_BIN)/test

testGraphic:
	# Run tests.
	$(PATH_BIN)/testGraphic

testGraphicExtended:
	# Run tests.
	$(PATH_BIN)/testGraphicExtended

man: generateMan
	$(MAN) -l doc/man/bashor.7

generateMan: doc/man/bashor.7

doc/man/bashor.7:
	# Generate the man page, this will take some time.
	$(PATH_BIN)/generateManuell > doc/man/bashor.7
