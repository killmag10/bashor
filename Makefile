RM:= rm
MAN:= man

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
	$(RM) docs/man/bashor.7

test:
	# Run tests.
	./test

man: generateMan
	$(MAN) -l docs/man/bashor.7

generateMan: docs/man/bashor.7

docs/man/bashor.7:
	# Generate the man page, this will take some time.
	./scripts/generateManuell > docs/man/bashor.7
