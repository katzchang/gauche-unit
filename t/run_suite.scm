;(define target-mudule "t.hello-suite")

(use gauche.unit)
(use gauche.sequence)

(use t.hello-suite)

(let1 mod (find-module 't.hello-suite)
      (let1 exports (module-exports mod)
	    (print "tests: " exports)
	    (for-each
	     (lambda (s)
	       (print "running " s)
	       (guard (e (else (print e)))
		      (begin
			(eval `(,s) (interaction-environment))
			(print 'ok))))
	     exports)
	    )
      )

