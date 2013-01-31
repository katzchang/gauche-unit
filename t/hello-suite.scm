(use gauche.unit)

(define (test description . procs)
  (print procs))

#;(test "hello"
 (assert 1 (is 1))
 (assert "xhoge" (is "hoge")))

(define-module t.hello-suite
  (export hello-test)
  (use gauche.unit)
  (define (test description . procs)
    eval procs)
  (define (hello-test) (test
   (assert 1 (is 1))
   (assert "xhoge" (is "hoge")))))