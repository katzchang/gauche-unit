(use gauche.unit)

(define-module t.hello-suite
  (export hello-test)

  (use gauche.unit)
  (define (hello-test)
   (assert 1 (is 1))
   (assert "hoge" (is "hogex"))))