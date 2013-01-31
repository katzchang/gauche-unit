all: test

test:
	env gosh -I ./ ./t/gu_test.scm

run_suite:
	env gosh -I ./ ./t/run_suite.scm