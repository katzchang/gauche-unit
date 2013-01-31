(use gauche.unit)

(define-module t.hello-suite
  (export hello-test)

  (use gauche.unit)
  (define (test description . procs)
    eval procs)

  (define (hello-test) (test
   (assert 1 (is 1))
   (assert "hoge" (is "hoge")))))