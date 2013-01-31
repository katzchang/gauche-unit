(use gauche.unit)

(define-module t.hello-suite
  (export-all)

  (use gauche.unit)

  (define (hello-test)
   (assert 1 (is 1))
   (assert "hoge" (is "hoge")))

  (define (hello-test2)
   (assert 1 (is 1))
   (assert "hoge" (is "hoge")))

  (define (error-test)
    (assert 1 (is 2)))

  )