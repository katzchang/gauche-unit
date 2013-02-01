(define-module gauche.unit.assertions
  (export assert
	  is
	  contains
	  raises
	  raises-error
	  is-greater-than)

  ;; assertion
  (define (assert actual matcher)
    (define (match? matcher actual) ((car matcher) actual))
    (define (description-of matcher) (cadr matcher))
    (define (describe-mismatch matcher actual) ((caddr matcher) actual))
    (define (describe matcher actual)
      (string-append "expected: " (description-of matcher) ", but: " (describe-mismatch matcher actual)))
    (if (match? matcher actual)
	#t
	(error (describe matcher actual))))
  
  (define default-mismatch-messenger
    (lambda (actual) (string-append "was " (->s actual))))
  
  ;; is matcher
  (define (is expected)
    (list
     (lambda (actual) (equal? expected actual))
     (->s expected)
     default-mismatch-messenger))
  
  ;; contains matcher
  (define (contains expected)
    (define (contains? item list)
      (if (any (lambda (e) (equal? e item)) list) #t #f))
    (list
     (lambda (actual) (contains? expected actual))
     (string-append "contains " (->s expected))
     default-mismatch-messenger))
  
  ;; is greater than matcher
  (define (is-greater-than expected)
    (let ((test? (cond ((number? expected) <)
		       ((string? expected) string<?)
		       (else (lambda (e a) (error (string-append "can not compare " (->s e) " and " (->s a))))))))
      (list
       (lambda (actual) (test? expected actual))
       (string-append "greater than " (->s expected))
       default-mismatch-messenger)))
  
  ;; raises matcher
  (define (raises-error)
    (list
     (lambda (promise-actual)
       (if (promise? promise-actual)
	   (guard
	    (exc ((condition-has-type? exc <error>) #t)
		 (else #f))
	    (not (force promise-actual)))
	   (error "actual must be a promise.")))
     (string-append "raises error")
     (lambda (actual) "not be raised.")))

  (define (raises expected)
    (list
     (lambda (promise-actual)
       (if (promise? promise-actual)
	   (guard
	    (exc ((condition-has-type? exc <error>)
		  (equal? (slot-ref exc 'message) expected))
		 ((string? exc) (equal? exc expected))
		 (else #f))
	    (not (force promise-actual)))
	   (error "actual must be a promise.")))
     (string-append "raises '" (x->string expected) "'")
     (lambda (actual) "not be raised.")))

  (define (->s i)
    (string-append (x->string (current-class-of i)) ":" (x->string i)))

)
