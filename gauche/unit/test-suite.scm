(define-module gauche.unit.test-suite
  (export test
	  run-suite
	  run-test)

  (use gauche.sequence)
  (define test
    (lambda mods (exit (run-suite mods))))

  (define (flatmap fn ls)
    (apply append (map fn ls)))
  
  (define (collect item ls)
    (filter (^(x) (eq? x item)) ls))
  (define (run-suite mods)
    (let1 result (flatmap run-test mods)
	  (let ((total (length result))
		(pass (length (collect 'ok result)))
		(err (length (collect 'err result))))
	    (print "total: " total ", pass: " pass ", error: " err)
	    (print (if (= err 0) 'ok 'err))
	    err)))

  (define env (interaction-environment))
  (define (run-test mod)
    (let1 result
	  (eval `(use ,mod) env)
	  (let1 exports (module-exports (find-module mod))
		(map (lambda (s)
		       (print s "...")
		       (guard (e (else (begin (print e) 'err)))
			      (begin
				(eval `(,s) env)
				'ok)))
		     exports)))))
