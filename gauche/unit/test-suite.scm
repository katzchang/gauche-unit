(define-module gauche.unit.test-suite
  (export test
	  run-suite
	  run-test)

  (use gauche.sequence)

  (define test
    (lambda mods (exit (run-suite mods))))


  (define (flatmap fn ls)
    (apply append (map fn ls)))
  
  (define (run-suite mods)
    (let1 result (flatmap run-test mods)
	  (let ((total (length result))
		(pass (length (filter (^(x) (eq? x 'ok)) result)))
		(err (length (filter (^(x) (eq? x 'err)) result)))
		(ret (if (any (^(e) (eq? e 'err)) result) #f #t)))
	    (print "total: " total ", pass: " pass ", error: " err)
	    (print (if ret 'ok 'err))
	    err)))
  
  (define (run-test mod)
    (let1 result
	  (eval `(use ,mod) (interaction-environment))
	  (let1 exports (module-exports (find-module mod))
		(map (lambda (s)
		       (print s "...")
		       (guard (e (else (begin (print e) 'err)))
			      (begin
				(eval `(,s) (interaction-environment))
				'ok)))
		     exports)))))
