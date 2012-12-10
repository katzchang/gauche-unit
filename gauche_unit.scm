;; assertion
(define (assert actual matcher)
  (define (match? matcher actual)
    ((car matcher) actual))
  (define (describe matcher actual)
    (string-append "expected: " (description-of matcher) ", but: " (describe-mismatch matcher actual)))
  (define (description-of matcher) (cadr matcher))
  (define (describe-mismatch matcher actual) ((caddr matcher) actual))
  (if (match? matcher actual)
      #t
      (raise (describe matcher actual))))

(define default-mismatch-messenger
  (lambda (actual) (string-append "was " (x->string actual))))
(define (default-description expected)
  (list
   (x->string expected)
   default-mismatch-messenger))

;; matcher
(define (is expected)
    (list
     (lambda (actual) (equal? expected actual))
     (x->string expected)
     default-mismatch-messenger))

(assert (= 1 1) (is #t)) ; #t
(assert (= 1 1) (is #f)) ; error
(assert (= 1 2) (is #f)) ; #t
(assert (= 1 2) (is #t)) ; error
(assert (+ 1 2) (is 3)) ; #t
(assert (+ 1 2) (is 4)) ; error
(assert (substring "ahoge" 1 5) (is "hoge")) ; #t
(assert (substring "ahoge" 1 5) (is "hage")) ; error
(assert (list) (is '()))
(assert (list) (is "hoge"))
(assert (make-list 3 "hoge") (is (list "hoge" "hoge" "hoge")))
(assert (+ 1 1) (is "hoge"))
(assert (+ 1 1) (is "2")) ; TODO: unko discription

;; list contains?
(assert (find (lambda (e) (equal? e 2)) (list 1 2 3)) (is 2))
(assert (find (lambda (e) (equal? e 4)) (list 1 2 3)) (is #f))
(assert (if 2 'true 'false) (is 'true))
(assert (if #f 'true 'false) (is 'false))

(define (contains? item list)
  (if (any (lambda (e) (equal? e item)) list) #t #f))
(assert (contains? 2 (list 1 2 3)) (is #t))
(assert (contains? "2" (list 1 2 3)) (is #f))

(define (contains expected)
    (list
     (lambda (actual) (contains? expected actual))
     (string-append "contains " (x->string expected))
     default-mismatch-messenger))
(assert (list "hoge" "fuga") (contains "fuga")) ; #t
(assert (list "hoge" "fuga") (contains "hage")) ; error

;; is grater than
(define (is-grater-than expected)
  (let ((test? (cond ((number? expected) <)
		     ((string? expected) string<?)
		     (else raise "cannot compare")))
    (list
     (lambda (actual) (test? expected actual))
     (string-append "grater than " (x->string expected))
     default-mismatch-messenger)))

(assert (+ 1 2) (is-grater-than 2)) ; #t
(assert (+ 1 2) (is-grater-than 3)) ; error
(assert (+ 1 2) (is-grater-than 4)) ; error

(assert (string<? "a" "b") (is #t)) ; #t
(assert (string<? "c" "b") (is #t)) ; error
(assert "hoge" (is-grater-than "hage")) ; #t
(assert "hage" (is-grater-than "hoge")) ; error
(assert #t (is-grater-than #f)) ; error

;; raises matcher
(assert
 (guard (exc
	 ((string? exc) (equal? exc "expected: #f, but: was #t"))
	 (else #f))
	(assert #t (is #f)))
 (is #t))

(assert (force (lazy (+ 1 1))) (is 2))
(assert (promise? (lazy (+ 1 1))) (is #t))

((lambda (promise-actual)
   (if (promise? promise-actual)
       (guard (exc
	       ((string? exc) "raised")
	       (else "not raised"))
	      (force promise-actual))
       "???"))
   (lazy (raise "foo")))

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
     (lambda (actual) "not be raised.")))

(assert (lazy (raise "foo")) (raises "foo"))
(assert
 (lazy (assert (lazy (raise "foo")) (raises "bar")))
 (raises "expected: raises 'bar', but: not be raised."))

;(assert
; (lazy (assert (+ 1 2) (is 3)))
; (raises "expected: 2, but: was 3")) ; error

