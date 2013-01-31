;(define target-mudule "t.hello-suite")

(use gauche.unit)
(use gauche.sequence)

(use t.hello-suite)

(exit 
 (let1 mod (find-module 't.hello-suite)
      (let1 exports (module-exports mod)
	    (print "tests: " exports)
	    (if (fold (^(a b) (and a b)) #t
		      (map
		       (lambda (s)
			 (print "running " s)
			 (guard (e (else (begin (print e) #f)))
				(begin
				  (eval `(,s) (interaction-environment))
				  (print 'ok)
				  #t)))
		       exports))
		0
		1))))

