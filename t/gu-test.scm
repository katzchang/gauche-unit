(define-module t.gu-test
  (export-all)
  (use gauche.unit)

  (define (raises-test)
    (assert (lazy (raise "foo"))
	    (raises "foo"))
    (assert (lazy (assert (lazy (raise "foo")) (raises "bar")))
	    (raises "expected: raises 'bar', but: not be raised.")))
 
#;(assert (lazy (assert (+ 1 2) (is 3)))
	(raises "expected: 2, but: was 3")) ; error


  (define (is-boolean-test)
    (assert (= 1 1) (is #t)) ; #t
    (assert (lazy (assert (= 1 1) (is #f)))
	    (raises "expected: #f, but: was #t")))
  
  (define (is-number-test)
    (assert (+ 1 2) (is 3)) ; #t
    (assert (lazy (assert (+ 1 2) (is 4)))
	    (raises "expected: 4, but: was 3")))
  
  (define (is-string-test)
    (assert (substring "ahoge" 1 5) (is "hoge")) ; #t
    (assert (lazy (assert (substring "ahoge" 1 5) (is "hage")))
	    (raises "expected: hage, but: was hoge")))
  
  (define (is-list-test)
    (assert (list) (is '()))
    (assert (lazy (assert (list) (is "hoge")))
	    (raises "expected: hoge, but: was ()"))
    (assert (make-list 3 "hoge") (is (list "hoge" "hoge" "hoge")))
    (assert (lazy (assert (+ 1 1) (is "hoge")))
	    (raises "expected: hoge, but: was 2")))
  
  (define (is-hard-to-read-message-test)
    (assert (lazy (assert (+ 1 1) (is "2")))
	    (raises "expected: 2, but: was 2"))) ; TODO: unko discription
  
  (define (contains-test)
    (assert (list "hoge" "fuga") (contains "fuga")) ; #t
    (assert (lazy (assert (list "hoge" "fuga") (contains "hage")))
	    (raises "expected: contains hage, but: was (hoge fuga)")))
  
  (define (is-greater-test)
    (assert (+ 1 2) (is-greater-than 2)) ; #t
    (assert (lazy (assert (+ 1 2) (is-greater-than 3)))
	    (raises "expected: greater than 3, but: was 3"))
    (assert (lazy (assert (+ 1 2) (is-greater-than 4)))
	    (raises "expected: greater than 4, but: was 3"))
    
    (assert "hoge" (is-greater-than "hage"))
    (assert (lazy (assert "hage" (is-greater-than "hoge")))
	    (raises "expected: greater than hoge, but: was hage"))
    (assert (lazy (assert #t (is-greater-than #f)))
	    (raises "can not compare #f and #t")))
  )
