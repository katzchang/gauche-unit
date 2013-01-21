GOSH=/usr/local/bin/gosh
L=./gu.scm

test:
	$(GOSH) -l $(L) ./*test.scm
