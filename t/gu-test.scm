(define-module t.gu-test
  (export-all)
  (use gauche.unit)

  (define (raises-test)
    (assert (lazy (raise "foo"))
	    (raises "foo"))
    (assert (lazy (assert (lazy (raise "foo")) (raises "bar")))
	    (raises-error)))
 
#;(assert (lazy (assert (+ 1 2) (is 3)))
	(raises "expected: 2, but: was 3")) ; error

  (define (is-boolean-test)
    (assert (= 1 1) (is #t))
    (assert (lazy (assert (= 1 1) (is #f)))
	    (raises-error)))
  
  (define (is-number-test)
    (assert (+ 1 2) (is 3))
    (assert (lazy (assert (+ 1 2) (is 4)))
	    (raises-error)))
  
  (define (is-string-test)
    (assert (substring "ahoge" 1 5) (is "hoge")) ; #t
    (assert (lazy (assert (substring "ahoge" 1 5) (is "hage")))
	    (raises-error)))
  
  (define (is-list-test)
    (assert (list) (is '()))
    (assert (lazy (assert (list) (is "hoge")))
	    (raises-error))
    (assert (make-list 3 "hoge") (is (list "hoge" "hoge" "hoge")))
    (assert (lazy (assert (+ 1 1) (is "hoge")))
	    (raises-error)))
  
  (define (is-hard-to-read-message-test)
    (assert (lazy (assert (+ 1 1) (is "2")))
	    (raises-error)))
  
  (define (contains-test)
    (assert (list "hoge" "fuga") (contains "fuga")) ; #t
    (assert (lazy (assert (list "hoge" "fuga") (contains "hage")))
	    (raises-error)))
  
  (define (is-greater-test)
    (assert (+ 1 2) (is-greater-than 2)) ; #t
    (assert (lazy (assert (+ 1 2) (is-greater-than 3)))
	    (raises-error))
    (assert (lazy (assert (+ 1 2) (is-greater-than 4)))
	    (raises-error))
    
    (assert "hoge" (is-greater-than "hage"))
    (assert (lazy (assert "hage" (is-greater-than "hoge")))
	    (raises-error))
    (assert (lazy (assert #t (is-greater-than #f)))
	    (raises-error)))
  )
