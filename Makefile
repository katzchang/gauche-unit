all: test

test:
	env gosh -I . -E "(use gauche.unit) (test 't.gu-test)"

fail_test:
	env gosh -I . -E "(use gauche.unit) (test 't.fail-test)"

