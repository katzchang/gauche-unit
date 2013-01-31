(use gauche.unit)
(use gauche.sequence)

(use t.hello-suite)

(let1 result
      (let1 mod (find-module 't.hello-suite)
	    (let1 exports (module-exports mod)
		  (print "tests: " exports)
		  (map (lambda (s)
		     (print s "...")
		     (guard (e (else (begin (print e) 'err)))
			    (begin
			      (eval `(,s) (interaction-environment))
#;			      (print ".")
			      'ok)))
		   exports)))
      (let ((total (length result))
	    (pass (length (filter (^(x) (eq? x 'ok)) result)))
	    (err (length (filter (^(x) (not x)) result)))
	    (ret (fold (^(a b) (and a b)) #t result)))
	(print "total: " total ", pass: " pass ", error: " err)
	(print (if ret 'ok 'err))
	(exit (if ret 0 1))))



