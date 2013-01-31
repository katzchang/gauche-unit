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
  (define count-all length)
  (define (count-if item ls)
    (length (collect item ls)))

  (define (run-suite mods)
    (let1 result (flatmap run-test mods)
	  (let ((total (count-all result))
		(pass (count-if 'ok result))
		(err (count-if 'err result)))
	    (print "total: " total ", pass: " pass ", error: " err)
	    (print (if (= err 0) 'ok 'err))
	    err)))

  (define env (interaction-environment))
  (define (run-test mod)
    (eval `(use ,mod) env)
    (let1 exports (module-exports (find-module mod))
	  (map (^(s)
		 (print s "...")
		 (guard (e (else (begin (print e) 'err)))
			(begin
			  (eval `(,s) env)
			  'ok)))
	   exports))))