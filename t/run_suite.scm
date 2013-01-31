(use gauche.sequence)

(define (main args)
  (exit (if (run-suite '(t.hello-suite)) 0 1)))

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
	  ret)))

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
		   exports))))
