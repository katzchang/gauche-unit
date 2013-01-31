all: test

test:
	env gosh -I ./ ./gu_test.scm
