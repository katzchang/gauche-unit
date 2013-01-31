(define-module gauche.unit
  (export-all)

  ;; assertion
  (define (assert actual matcher)
    (define (match? matcher actual) ((car matcher) actual))
    (define (description-of matcher) (cadr matcher))
    (define (describe-mismatch matcher actual) ((caddr matcher) actual))
    (define (describe matcher actual)
      (string-append "expected: " (description-of matcher) ", but: " (describe-mismatch matcher actual)))
    (if (match? matcher actual)
	#t
	(raise (describe matcher actual))))
  
  (define default-mismatch-messenger
    (lambda (actual) (string-append "was " (x->string actual))))
  
  ;; is matcher
  (define (is expected)
    (list
     (lambda (actual) (equal? expected actual))
     (x->string expected)
     default-mismatch-messenger))
  
  ;; contains matcher
  (define (contains expected)
    (define (contains? item list)
      (if (any (lambda (e) (equal? e item)) list) #t #f))
    (list
     (lambda (actual) (contains? expected actual))
     (string-append "contains " (x->string expected))
     default-mismatch-messenger))
  
  ;; is greater than matcher
  (define (is-greater-than expected)
    (let ((test? (cond ((number? expected) <)
		       ((string? expected) string<?)
		       (else (lambda (e a) (raise (string-append "can not compare " (x->string e) " and " (x->string a))))))))
      (list
       (lambda (actual) (test? expected actual))
       (string-append "greater than " (x->string expected))
       default-mismatch-messenger)))
  
  ;; raises matcher
  (define (raises expected)
    (list
     (lambda (promise-actual)
       (if (promise? promise-actual)
	   (guard (exc
		   ((string? exc) (equal? exc expected))
		   (else #f))
		  (not (force promise-actual)))
	   (raise "actual must be a promise.")))
     (string-append "raises '" (x->string expected) "'")
     (lambda (actual) "not be raised."))))