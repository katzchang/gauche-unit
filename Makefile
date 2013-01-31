all: test

test:
	env gosh -I ./ ./t/gu_test.scm
